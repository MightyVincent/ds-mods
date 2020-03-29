local assets=
{
    Asset("ANIM", "anim/bow.zip"),
    Asset("ANIM", "anim/swap_bow.zip"),
	
    Asset("ATLAS", "images/inventoryimages/bow.xml"),
    Asset("IMAGE", "images/inventoryimages/bow.tex"),

    Asset("ANIM", "anim/swap_magicbow.zip"),
	
    Asset("ATLAS", "images/inventoryimages/magicbow.xml"),
    Asset("IMAGE", "images/inventoryimages/magicbow.tex")
}

local prefabs = {
	"sparkles",
	"arrow",
	"goldarrow",
	"moonstonearrow",
	"firearrow",
	"icearrow",
	"thunderarrow",
	"dischargedthunderarrow",
	"shadowarrow",
	"lightarrow",
	"healingarrow"
}

----------------------------------------------------------------------------BOWS--------------------------------------------------------------

local function OnEquipBow(inst, owner)		
	ARCHERYFUNCS.AssignProjInQuiver(inst, owner)
	
    owner.AnimState:OverrideSymbol("swap_object", "swap_bow", "swap_bow")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	
	
	-- local skin_build = inst._skinname
    -- if skin_build ~= nil then
		-- print("This bow has a skin!")
        -- -- owner:PushEvent("equipskinneditem", inst:GetSkinName())
        -- owner.AnimState:OverrideItemSkinSymbol("swap_object", "swap_z_bow_skin_leaf", "swap_z_bow_skin_leaf", inst.GUID, "swap_z_bow_skin_leaf" )
    -- else
        -- owner.AnimState:OverrideSymbol("swap_object", "swap_bow", "swap_bow")
    -- end
end

local function bowfn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local netw = inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
     
    anim:SetBank("bow")
    anim:SetBuild("bow")
    anim:PlayAnimation("bow_idle")
 
	inst:AddTag("bow")
	inst:AddTag("ranged")
	inst:AddTag("usequiverproj")	
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then	
        return inst
    end
----------------------------------------------------------------
	
--	print("BOW USES = " , TUNING.BOWUSES, "   /   BOW DMG = ", TUNING.BOWDMG)
	
	if TUNING.BOWUSES < 201 then
		inst:AddComponent("finiteuses")
		inst.components.finiteuses:SetMaxUses(TUNING.BOWUSES)
		inst.components.finiteuses:SetUses(TUNING.BOWUSES)
		inst.components.finiteuses:SetOnFinished(ARCHERYFUNCS.OnFinished)
	end
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "bow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/bow.xml"
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquipBow )
    inst.components.equippable:SetOnUnequip( ARCHERYFUNCS.CommonOnUnequip )
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange((TUNING.BOWRANGE-2), TUNING.BOWRANGE)
	-- inst._atkrange:set(TUNING.BOWRANGE)
    inst.components.weapon:SetProjectile("arrow")
	inst.components.weapon:SetOnAttack(ARCHERYFUNCS.onattack)
	
	inst:AddComponent("zupalexsrangedweapons")
	inst.components.zupalexsrangedweapons:SetCooldownTime(1.3)

    MakeHauntableLaunch(inst)
	
	ARCHERYFUNCS.MakeSwappableSkin(inst)
 
    return inst
end

----------------------------------------------------------------------------------------------MAGIC BOW-----------------------------------------------------------------

local function SpawnSparkles(inst, owner)
	if inst.sparkles01 == nil then
        inst.sparkles01 = SpawnPrefab("sparkles")
        inst.sparkles01.Transform:SetPosition(inst:GetPosition():Get())
        inst.sparkles01:SetFollowTarget(owner, "swap_object", -100, -300, 0.02)
    end
	
	inst.Light:Enable(true)
	
	local ismoving = false
	
	inst.onlocomote = function(owner)
		if inst.sparkles01 ~= nil then
			if inst.components.fueled ~= nil and not inst.components.fueled:IsEmpty() then
				if owner.components.locomotor.wantstomoveforward and not ismoving then
					ismoving = true
					inst.sparkles01:SetFollowTarget(owner, "swap_hat", 50, -280, 0.02)
					inst.sparkles01.AnimState:PlayAnimation("mov", true)
		--          inst.sparkles01.SoundEmitter:PlaySound("dontstarve/common/fan_twirl_LP", "twirl")
				elseif not owner.components.locomotor.wantstomoveforward and ismoving then
					ismoving = false
					inst.sparkles01:SetFollowTarget(owner, "swap_object", -100, -300, 0.02)
					inst.sparkles01.AnimState:PlayAnimation("idle", true)
		--          inst.sparkles01.SoundEmitter:KillSound("twirl")
				end
			else
				inst:RemoveEventCallback("locomote", inst.onlocomote, owner)
			end
		else
			inst:RemoveEventCallback("locomote", inst.onlocomote, owner)
		end
    end

    inst:ListenForEvent("locomote", inst.onlocomote, owner)
end

local function OnEquipMagicBow(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_magicbow", "swap_magicbow")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	
	-- owner.replica.combat._attackrange:set(TUNING.BOWRANGE)
	
	if inst.components.fueled ~= nil and not inst.components.fueled:IsEmpty() then
		inst:AddTag("hasfuel")
	end
	
	if inst:HasTag("hasfuel") then
		SpawnSparkles(inst, owner)
	end
	
	if inst.components.weapon.projectile == "healingarrow" and not inst:HasTag("healer") then
		inst:AddTag("healer")
	end
end
 
local function OnUnequipMagicBow(inst, owner)		
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

	if inst.sparkles01 ~= nil then
        inst.sparkles01:SetFollowTarget(nil)
        inst.sparkles01 = nil
		inst:RemoveEventCallback("locomote", inst.onlocomote, owner)
    end
	
	inst.Light:Enable(false)
end

local function MBSetNewProjectile(inst, itemprefab)
	local currentproj = inst.components.weapon.projectile
	
	local newproj = nil
	local lightR, lightG, lightB = nil, nil, nil
	
	if itemprefab == "nightmarefuel" then
		newproj = string.lower("shadowarrow")
		lightR = 204/255
		lightG = 0/255
		lightB = 255/255
	elseif itemprefab == "z_firefliesball" then
		newproj = string.lower("lightarrow")	
		lightR = 255/255
        lightG = 253/255
		lightB = 54/255
	elseif itemprefab == "z_bluegoop" then
		newproj = string.lower("healingarrow")	
		lightR = 247/255
		lightG = 116/255
		lightB = 255/255
	end
	
	if newproj ~= nil then
		inst.components.zupalexsrangedweapons:SetFueledBy(itemprefab)
	
--		print("current proj = ", currentproj or "UNAVAILABLE", " / new proj = ", newproj or "UNAVAILABLE")
	
		if currentproj ~= newproj then
			if inst:HasTag("healer") and not newproj == "z_bluegoop" then
				inst:RemoveTag("healer")
			end
		
			inst.Light:SetColour(lightR, lightG, lightB)
			inst.components.weapon:SetProjectile(newproj)
			
--			print("I successfuly set a new projectile : ", inst.components.weapon.projectile)
			
			return true
		else
			return false
		end
	end	
end

local function magicbow_empty(inst)
	if inst.sparkles01 ~= nil then
        inst.sparkles01:SetFollowTarget(nil)
        inst.sparkles01 = nil
    end
	
	inst.Light:Enable(false)
	
	if inst:HasTag("hasfuel") then
		inst:RemoveTag("hasfuel")
	end
end

local function MagicBowCanAcceptFuelItem(self, item)
	if item ~= nil and item.components.fuel ~= nil and (item.components.fuel.fueltype == FUELTYPE.ZUPALEX or item.prefab == "nightmarefuel") then
		return true
	else
		return false
	end
end

local function MagicBowTakeFuel(self, item)		
	if self:CanAcceptFuelItem(item) then
	
		local changeproj = MBSetNewProjectile(self.inst, item.prefab)
	
--		print("changeproj = ", changeproj)
	
		if changeproj then
			self:MakeEmpty()
		end
	
		if not self.inst:HasTag("hasfuel") then
			if self.inst.components.equippable ~= nil and self.inst.components.equippable:IsEquipped() then
				self.inst.Light:Enable(true)
			end
			self.inst:AddTag("hasfuel")
		end
		
		if item.prefab =="nightmarefuel" or item.prefab == "z_bluegoop" then
			self:DoDelta(5)
		elseif item.prefab =="z_firefliesball" then
			self:DoDelta(10)
		end
		
        item:Remove()

        if TheWorld.ismastersim and self.inst.components.equippable ~= nil and self.inst.components.equippable:IsEquipped() and self.inst.sparkles01 == nil then
			local owner = self.inst.components.inventoryitem.owner
            SpawnSparkles(self.inst, owner)
        end

        return true
    end
end

local function MagicBowOnSaveFueled(self)
    if self.currentfuel > 0 then
      return { fuel = self.currentfuel }
    end
end

local function MagicBowOnSave(inst, data)	
	if inst.components.zupalexsrangedweapons and inst.components.zupalexsrangedweapons.fueledby ~= nil then
        data.fueledby = inst.components.zupalexsrangedweapons.fueledby
    end
end

local function MagicBowOnLoad(inst, data)
    if data and data.fueledby then
        MBSetNewProjectile(inst, data.fueledby)
    end
end

local function magicbowfn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local netw = inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
	
    anim:SetBank("magicbow")
    anim:SetBuild("bow")
    anim:PlayAnimation("magicbow_idle")
 
 	local light = inst.entity:AddLight()
	
	inst.Light:SetIntensity(0.8)
	inst.Light:SetRadius(0.5)
	inst.Light:SetFalloff(0.33)
	inst.Light:SetColour(204/255, 0/255, 255/255)
	inst.Light:Enable(false)
 
	inst:AddTag("bow")
	inst:AddTag("ranged")
	inst:AddTag("magic")
	inst:AddTag("NIGHTMARE_fueled") -- to accept the nightmarefuel as well without modifying the fueltype of the nightmarefuel (better compatibility sake)
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then	
        return inst
    end
----------------------------------------------------------------
	
--	print("BOW USES = " , TUNING.BOWUSES, "   /   BOW DMG = ", TUNING.BOWDMG)
	
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "magicbow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/magicbow.xml"
	inst.components.inventoryitem:SetOnDroppedFn(function(inst) inst.Light:Enable(false) end)
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquipMagicBow )
    inst.components.equippable:SetOnUnequip( OnUnequipMagicBow )
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange((TUNING.BOWRANGE - 2), TUNING.BOWRANGE)
    inst.components.weapon:SetProjectile("shadowarrow")
	inst.components.weapon:SetOnAttack(ARCHERYFUNCS.onattack)
	
	inst:AddComponent("zupalexsrangedweapons")
	inst.components.zupalexsrangedweapons:SetCooldownTime(1.3)
	
	inst:AddComponent("fueled")
	inst.components.fueled.accepting = true
	inst.components.fueled.fueltype = FUELTYPE.ZUPALEX
--	inst.components.fueled:InitializeFuelLevel(0)
	inst.components.fueled.maxfuel = 10
	inst.components.fueled:StopConsuming()
	inst.components.fueled.CanAcceptFuelItem = MagicBowCanAcceptFuelItem
	inst.components.fueled.TakeFuelItem = MagicBowTakeFuel
	inst.components.fueled:SetDepletedFn(magicbow_empty)
	
	inst.components.fueled.OnSave = MagicBowOnSaveFueled
	
	inst.OnSave = MagicBowOnSave
	inst.OnLoad = MagicBowOnLoad
	
--	for k, v in pairs(FUELTYPE) do
--		print(v)
--	end
	
    MakeHauntableLaunch(inst)
 
    return inst
end


return  Prefab("common/inventory/bow", bowfn, assets, prefabs),
		Prefab("common/inventory/magicbow", magicbowfn, assets, prefabs)