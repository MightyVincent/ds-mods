local assets=
{
	Asset("ANIM", "anim/carvers.zip"),
	Asset("ANIM", "anim/swap_carver.zip"),
	
	Asset("ANIM", "anim/ui_carver.zip"),
	
	Asset("ATLAS", "images/inventoryimages/carver.xml"),
    Asset("IMAGE", "images/inventoryimages/carver.tex")
}

local prefabs = {
	"feather_crow", "feather_robin", "feather_robin_winter", "feather_canary"
}

local accepted_feathers = {}

for k, v in pairs(ARCHERY_INGREDIENTS_INFOS.feathers) do
	accepted_feathers[k] = true
end

local accepted_bodies = {}

for k, v in pairs(ARCHERY_INGREDIENTS_INFOS.bodies) do
	accepted_bodies[k] = true
end

local accepted_heads = {}

for k, v in pairs(ARCHERY_INGREDIENTS_INFOS.heads) do
	accepted_heads[k] = true
end

local carverwidgetparams = {
    widget =
    {
        slotpos =
        {
            Vector3(-125, 0, 0), 
            Vector3(0, 0, 0),
            Vector3(125, 0, 0), 
        },
        animbank = "ui_carver",
        animbuild = "ui_carver",
        pos = Vector3(100, -200, 0),
        side_align_tip = 0,
        buttoninfo =
        {
            text = "CARVE",
            position = Vector3(0, -75, 0),
        }
    },
    acceptsstacks = true,
    type = "carver",
}

function carverwidgetparams.itemtestfn(container, item, slot)
    if slot == 1 and accepted_feathers[item.prefab] then
		return true
	elseif slot == 2 and accepted_bodies[item.prefab] then
		return true
	elseif slot == 3 and accepted_heads[item.prefab] then
		return true
	else
		return false
	end
end

function carverwidgetparams.widget.buttoninfo.fn(inst)
    if inst.components.container ~= nil then
		local feather = inst.components.container:GetItemInSlot(1)
		local body = inst.components.container:GetItemInSlot(2)
		local head = inst.components.container:GetItemInSlot(3)
		
		local results, feather_remain, body_remain, head_remain = ARCHERYFUNCS.ProcessCarverRecipe(feather, body, head)
		
		if inst._worker then
			if results ~= nil then inst._worker.components.inventory:GiveItem(results) end
			if feather_remain ~= nil then inst._worker.components.inventory:GiveItem(feather_remain) end
			if body_remain ~= nil then inst._worker.components.inventory:GiveItem(body_remain) end
			if head_remain ~= nil then inst._worker.components.inventory:GiveItem(head_remain) end
		end
    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
        SendModRPCToServer(MOD_RPC["Archery Mod"]["RequestProcessCarverCrafting"], inst)
    end
end

local function HasEnoughIngredients(feather, body, head)
	local feather_stacksize = 1
	local body_stacksize = 1
	local head_stacksize = 1

	if feather.replica and feather.replica.stackable then
		feather_stacksize = feather.replica.stackable:StackSize()
	end
	
	if body.replica and body.replica.stackable then
		body_stacksize = body.replica.stackable:StackSize()
	end
	
	if head.replica and head.replica.stackable then
		head_stacksize = head.replica.stackable:StackSize()
	end
	
	if 	ARCHERY_INGREDIENTS_INFOS.feathers[feather.prefab].yield*feather_stacksize >= 1 and
		ARCHERY_INGREDIENTS_INFOS.bodies[body.prefab].yield*body_stacksize >= 1 and
		ARCHERY_INGREDIENTS_INFOS.heads[head.prefab].yield*head_stacksize >= 1 then
		return true
	else
		return false
	end
	
end

local function IsValidRecipe(container)
	local feather = container:GetItemInSlot(1)
	local body = container:GetItemInSlot(2)
	local head = container:GetItemInSlot(3)
	
	local result = ARCHERYFUNCS.GetPrefabRecipe(feather, body, head)
	
	print("Testing if item exists: " .. tostring(result))
	
	local guid = TheSim:SpawnPrefab(result)
	 
	if guid then
		return HasEnoughIngredients(feather, body, head)
	else
		return false
	end
end

function carverwidgetparams.widget.buttoninfo.validfn(inst)
    return inst.replica.container ~= nil and inst.replica.container:IsFull() and IsValidRecipe(inst.replica.container)
end

local function OnEquipCarver(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_carver", "swap_flint_carver")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function ListenForStackChanged(container)
	local callback_fn = function(inst, data)
		-- print("A Stack changed in the carver " .. tostring(container))
		if inst and container._actualwidget then
			container._actualwidget:OnItemGet({})
		elseif TheWorld.ismastersim and container._stackchanged ~= nil then
			-- print("Running on the host for a client: informing client that the stack changed")
			container._stackchanged:set(true)
			container._stackchanged:set_local(false)
		end
	end
	
	return callback_fn
end

local function UpdateButtonState(inst)
	-- print("Received an event stating the stack changed")
	if inst._actualwidget then
		-- print("Updating widget button state")
		inst._actualwidget:OnItemGet({})
	end
end

local function RegisterWidget(container, doer)
	print("Registering the widget for " .. tostring(container))
	
	if container.components and container.components.container then
		local data = doer
		doer = data.doer
		
		container._worker = doer
		
		if doer.HUD ~= nil then
			local actual_widget = doer.HUD.controls.containers[container]
			print(actual_widget)
			container._actualwidget = actual_widget
		end
	elseif container.classified ~= nil and doer == ThePlayer and doer.HUD and container._isopen then
		local actual_widget = doer.HUD.controls.containers[container.inst]
		print(actual_widget)
		container.inst._actualwidget = actual_widget
	end
end

local function arrow_carver_fn()
	local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local netw = inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
 
	inst:AddTag("carver")
	
	anim:SetBank("carvers")
    anim:SetBuild("carvers")
    anim:PlayAnimation("flint_onground")
	
	inst._stackchanged = net_bool(inst.GUID, "carver._stackchanged", "carverstackchanged")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		inst:ListenForEvent("carverstackchanged", UpdateButtonState)
	end
		
	if TheWorld.ismastersim then	
		inst:AddComponent("inspectable")

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = "carver"
		inst.components.inventoryitem.atlasname = "images/inventoryimages/carver.xml"
		
		inst:AddComponent("equippable")
		inst.components.equippable:SetOnEquip( OnEquipCarver )
		inst.components.equippable:SetOnUnequip( function(inst, owner) ARCHERYFUNCS.CommonOnUnequip(inst, owner); inst.components.container:Close() end )

		inst:AddComponent("container")
		inst.components.container.WidgetSetup = ARCHERYFUNCS.MyWidgetSetup
		inst.replica.container.WidgetSetup = ARCHERYFUNCS.MyWidgetSetup_replica
		
		inst:DoTaskInTime(0, function(inst) inst.components.container:WidgetSetup(inst.prefab, carverwidgetparams) end)
		
		inst.components.container.onclosefn = function(inst, doer) 
			inst.components.container:DropEverything()
		end
		
		inst:ListenForEvent("onopen", RegisterWidget)
		
		inst:ListenForEvent("onclose", function() 
			inst._actualwidget = nil
			inst._worker = nil
		end)
		
		inst:ListenForEvent("itemget", function(self, data)
			local item = data.item
			
			if item and item.components and item.components.stackable then
				self:ListenForEvent("stacksizechange", ListenForStackChanged(self), item)
			end
		end)
		
		inst:ListenForEvent("itemlose", function(self, data)
			local item = data.item
			
			if item and item.components and item.components.stackable then
				self:DoTaskInTime(0, function() self:RemoveEventCallback("stacksizechange", ListenForStackChanged(self), item) end)
			end
		end)
		
		inst:ListenForEvent("ms_playerleft", function(src, player) 
			if inst._worker == player then
				inst.components.container:DropEverything()
				inst.components.container:Close()
				inst._worker = nil
			end
		end,
		TheWorld)
		
		inst:AddComponent("zupalexsrangedweapons")
	end
	
	inst:DoTaskInTime(0, function(inst) 
		inst.replica.container.WidgetSetup = ARCHERYFUNCS.MyWidgetSetup_replica
	
		inst.replica.container:WidgetSetup(inst.prefab, carverwidgetparams)
		
		inst._origReplicaOpen = inst.replica.container.Open
		
		inst.replica.container.Open = function(self, doer)
			inst._origReplicaOpen(self, doer)
			RegisterWidget(self, doer)
		end
		
		inst._origReplicaClose = inst.replica.container.Close
		
		inst.replica.container.Close = function(self)
			inst._origReplicaClose(self)
			self.inst._actualwidget = nil
		end
	end)
	
	return inst
end

return Prefab("common/inventory/arrow_carver", arrow_carver_fn, assets, prefabs)