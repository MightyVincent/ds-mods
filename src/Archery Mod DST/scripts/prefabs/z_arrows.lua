local assets=
{
	Asset("ATLAS", "images/inventoryimages/arrow.xml"),
    Asset("IMAGE", "images/inventoryimages/arrow.tex"),
	Asset("ATLAS", "images/inventoryimages/goldarrow.xml"),
    Asset("IMAGE", "images/inventoryimages/goldarrow.tex"),
	Asset("ATLAS", "images/inventoryimages/moonstonearrow.xml"),
    Asset("IMAGE", "images/inventoryimages/moonstonearrow.tex"),
	Asset("ATLAS", "images/inventoryimages/firearrow.xml"),
    Asset("IMAGE", "images/inventoryimages/firearrow.tex"),
	Asset("ATLAS", "images/inventoryimages/icearrow.xml"),
    Asset("IMAGE", "images/inventoryimages/icearrow.tex"),
	Asset("ATLAS", "images/inventoryimages/thunderarrow.xml"),
    Asset("IMAGE", "images/inventoryimages/thunderarrow.tex"),
	Asset("ATLAS", "images/inventoryimages/dischargedthunderarrow.xml"),
    Asset("IMAGE", "images/inventoryimages/dischargedthunderarrow.tex"),
	
	Asset("ANIM", "anim/swap_arrowhead.zip"),
	Asset("ANIM", "anim/swap_arrowfeather.zip"),
	Asset("ANIM", "anim/swap_arrowbody.zip"),
	
	Asset("ANIM", "anim/bow.zip"),
}

local prefabs = {

}

-- for i, v in ipairs(prefabs) do
	-- table.insert(assets, Asset("ATLAS", "images/inventoryimages/shaft_" .. v .. ".xml"))
	-- table.insert(assets, Asset("ATLAS", "images/inventoryimages/shaft_" .. v .. ".tex"))
-- end

local feather_types = {}
local body_types = {}
local head_types = {}

for k, v in pairs(ARCHERY_INGREDIENTS_INFOS.feathers) do
	if feather_types[v.key] == nil then
		feather_types[v.key] = true
	end
end

for k, v in pairs(ARCHERY_INGREDIENTS_INFOS.bodies) do
	if body_types[v.key] == nil then
		body_types[v.key] = true
	end
end

for k, v in pairs(ARCHERY_INGREDIENTS_INFOS.heads) do
	if head_types[v.key] == nil then
		head_types[v.key] = true
	end
end

for feather, _ in pairs(feather_types) do
	for body, _ in pairs(body_types) do
		for head, _ in pairs(head_types) do
			table.insert(assets, Asset("ATLAS", "images/inventoryimages/ia_" .. body .. "_" .. head .. "_" .. feather .. ".xml"))
			table.insert(assets, Asset("IMAGE", "images/inventoryimages/ia_" .. body .. "_" .. head .. "_" .. feather .. ".tex"))
		end
	end
end

local function shootarrowfn(feather_str, body_str, head_str)	
    return function(inst)
		inst.AnimState:PlayAnimation("arrow_flight")
		
		inst:AddTag("NOCLICK")
		inst.persists = false
		
		local owner = inst.components.projectile.owner
		if owner and not owner:HasTag("player") then
			inst.components.projectile.owner = owner and owner.components.inventoryitem and owner.components.inventoryitem:GetGrandOwner() or owner
		end
		
		if ARCHERY_SHOOT_FNS[feather_str] ~= nil then
			for i, v in ipairs(ARCHERY_SHOOT_FNS[feather_str]) do
				ARCHERYFUNCS.shootfns[v.fn](inst, v.data)
			end
		end
			
		if ARCHERY_SHOOT_FNS[body_str] ~= nil then
			for i, v in ipairs(ARCHERY_SHOOT_FNS[body_str]) do
				ARCHERYFUNCS.shootfns[v.fn](inst, v.data)
			end
		end
			
		if ARCHERY_SHOOT_FNS[head_str] ~= nil then
			for i, v in ipairs(ARCHERY_SHOOT_FNS[head_str]) do
				ARCHERYFUNCS.shootfns[v.fn](inst, v.data)
			end
		end
	end
end

local function specarrowhitfn(feather_str, body_str, head_str)
	return function(inst, attacker, target)
		if ARCHERY_HIT_FNS[feather_str] ~= nil then
			for i, v in ipairs(ARCHERY_HIT_FNS[feather_str]) do
				ARCHERYFUNCS.hitfns[v.fn](inst, attacker, target, v.data)
			end
		end
			
		if ARCHERY_HIT_FNS[body_str] ~= nil then
			for i, v in ipairs(ARCHERY_HIT_FNS[body_str]) do
				ARCHERYFUNCS.hitfns[v.fn](inst, attacker, target, v.data)
			end
		end
			
		if ARCHERY_HIT_FNS[head_str] ~= nil then
			for i, v in ipairs(ARCHERY_HIT_FNS[head_str]) do
				ARCHERYFUNCS.hitfns[v.fn](inst, attacker, target, v.data)
			end
		end
	end
end

local function specarrowmissfn(feather_str, body_str, head_str)
	return function(inst, attacker, target)
		if ARCHERY_MISS_FNS[feather_str] ~= nil then
			for i, v in ipairs(ARCHERY_MISS_FNS[feather_str]) do
				ARCHERYFUNCS.missfns[v.fn](inst, attacker, target, v.data)
			end
		end
			
		if ARCHERY_MISS_FNS[body_str] ~= nil then
			for i, v in ipairs(ARCHERY_MISS_FNS[body_str]) do
				ARCHERYFUNCS.missfns[v.fn](inst, attacker, target, v.data)
			end
		end
			
		if ARCHERY_MISS_FNS[head_str] ~= nil then
			for i, v in ipairs(ARCHERY_MISS_FNS[head_str]) do
				ARCHERYFUNCS.missfns[v.fn](inst, attacker, target, v.data)
			end
		end
	end
end

local function MakeArrowFn(feather_str, body_str, head_str)
	return function()
		local inst = CreateEntity()
		
		local trans = inst.entity:AddTransform()
		local anim = inst.entity:AddAnimState()
		local netw = inst.entity:AddNetwork()
		
		MakeInventoryPhysics(inst)
		
		inst:AddTag("arrow")
		inst:AddTag("zrw_valid")
		
		if ARCHERY_TAGS[feather_str] ~= nil then
			for i, tag in pairs(ARCHERY_TAGS[feather_str]) do
				inst:AddTag(tag)
			end
		end
		
		if ARCHERY_TAGS[body_str] ~= nil then
			for i, tag in pairs(ARCHERY_TAGS[body_str]) do
				inst:AddTag(tag)
			end
		end
		
		if ARCHERY_TAGS[head_str] ~= nil then
			for i, tag in pairs(ARCHERY_TAGS[head_str]) do
				inst:AddTag(tag)
			end
		end
		
		anim:SetBank("arrow_swappable")
		anim:SetBuild("bow")
		anim:PlayAnimation("arrow_idle")
		
		anim:OverrideSymbol("swap_arrowbody", "swap_arrowbody", "body_" .. body_str)
		anim:OverrideSymbol("swap_arrowfeather", "swap_arrowfeather", "feather_" .. feather_str)
		anim:OverrideSymbol("swap_arrowhead", "swap_arrowhead", "head_" .. head_str)
		
		if ARCHERY_CTORS_COMMON[feather_str] ~= nil then
			for i, v in ipairs(ARCHERY_CTORS_COMMON[feather_str]) do
				ARCHERYFUNCS.ctorfns[v.fn](inst, v.data)
			end
		end
		
		if ARCHERY_CTORS_COMMON[body_str] ~= nil then
			for i, v in ipairs(ARCHERY_CTORS_COMMON[body_str]) do
				ARCHERYFUNCS.ctorfns[v.fn](inst, v.data)
			end
		end
		
		if ARCHERY_CTORS_COMMON[head_str] ~= nil then
			for i, v in ipairs(ARCHERY_CTORS_COMMON[head_str]) do
				ARCHERYFUNCS.ctorfns[v.fn](inst, v.data)
			end
		end
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then	
			return inst
		end
		
		inst:AddComponent("weapon")	
		inst.components.weapon:SetDamage(0)
	
		inst:AddComponent("projectile")
		inst.components.projectile:SetSpeed(25)
		inst.components.projectile:SetOnThrownFn(shootarrowfn(feather_str, body_str, head_str))
		inst.components.projectile:SetOnHitFn(ARCHERYFUNCS.onhitcommon)
		inst.components.projectile:SetOnMissFn(ARCHERYFUNCS.onmissarrow_regular)
		inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
		
		inst:ListenForEvent("onthrown", ARCHERYFUNCS.onthrown_regular)	
		
		inst:AddComponent("inspectable")

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = "ia_" .. body_str .. "_" .. head_str .. "_" .. feather_str
		inst.components.inventoryitem.atlasname = "images/inventoryimages/ia_" .. body_str .. "_" .. head_str .. "_" .. feather_str .. ".xml"
		-- inst.components.inventoryitem.imagename = "shaft_" .. feather_prefab
		-- inst.components.inventoryitem.atlasname = "images/inventoryimages/shaft_" .. feather_prefab .. ".xml"
		
		inst:AddComponent("zupalexsrangedweapons")
		inst.components.zupalexsrangedweapons:SetSpecificOnHitfn(specarrowhitfn(feather_str, body_str, head_str))
		inst.components.zupalexsrangedweapons:SetSpecificOnMissfn(specarrowmissfn(feather_str, body_str, head_str))
		inst.components.zupalexsrangedweapons:SetBaseDamage(TUNING.BOWDMG)
		inst.components.zupalexsrangedweapons.feather = feather_str
		inst.components.zupalexsrangedweapons.body = body_str
		inst.components.zupalexsrangedweapons.head = head_str
		
		inst:AddComponent("stackable")
		
		if ARCHERY_CTORS_MASTER[feather_str] ~= nil then
			for i, v in ipairs(ARCHERY_CTORS_MASTER[feather_str]) do
				ARCHERYFUNCS.ctorfns[v.fn](inst, v.data)
			end
		end
		
		if ARCHERY_CTORS_MASTER[body_str] ~= nil then
			for i, v in ipairs(ARCHERY_CTORS_MASTER[body_str]) do
				ARCHERYFUNCS.ctorfns[v.fn](inst, v.data)
			end
		end
		
		if ARCHERY_CTORS_MASTER[head_str] ~= nil then
			for i, v in ipairs(ARCHERY_CTORS_MASTER[head_str]) do
				ARCHERYFUNCS.ctorfns[v.fn](inst, v.data)
			end
		end
		
		return inst
	end
end

local arrow_prefabs = {}

for feather, _ in pairs(feather_types) do
	for body, _ in pairs(body_types) do
		for head, _ in pairs(head_types) do
			table.insert(arrow_prefabs, Prefab("common/inventory/arrow_" .. feather .. "_" .. body .. "_" .. head, MakeArrowFn(feather, body, head), assets, prefabs))
		end
	end
end



local function regulararrowfn()
	return MakeArrowFn("black", "wood", "flint")()
end

local function goldarrowfn()
	return MakeArrowFn("yellow", "wood", "gold")()
end

local function moonstonearrowfn()
	return MakeArrowFn("blue", "wood", "moon")()
end

local function firearrowfn()
	return MakeArrowFn("red", "wood", "fire")()
end

local function icearrowfn()
	return MakeArrowFn("blue", "wood", "ice")()
end

local function thunderarrowfn()
	return MakeArrowFn("yellow", "wood", "horn")()
end

local function dischargedthunderarrowfn(feather_str, body_str)
	return function()
		local inst = MakeArrowFn(feather_str, body_str, "horn")()
		
		inst:AddTag("discharged")
		
		return inst
	end
end


for feather, _ in pairs(feather_types) do
	for body, _ in pairs(body_types) do
		table.insert(arrow_prefabs, Prefab("common/inventory/arrow_" .. feather .. "_" .. body .. "_horn_discharged", dischargedthunderarrowfn(feather, body), assets, prefabs))
	end
end
	


--------------------------------------------------------------------------MAGIC PROJECTILES-------------------------------------------------------------------------

local function commonmagicprojfn(arrowanim, tags) 
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local netw = inst.entity:AddNetwork()
 
    MakeInventoryPhysics(inst)
 
 	anim:SetBank("magicprojectile")
    anim:SetBuild("bow")
    anim:PlayAnimation(arrowanim)
 
	inst:AddTag("projectile") -- Tag is not doing anything by itself. I can be called by other stuffs though.
	inst:AddTag("arrow")
	inst:AddTag("magic")

	if tags ~= nil then
        for i, v in ipairs(tags) do
            inst:AddTag(v)
        end
    end
	
 --The following section is suitable for a DST compatible prefab.
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then	
        return inst
    end
----------------------------------------------------------------

	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(0)
	inst:AddComponent("projectile")	
	
	inst:AddComponent("zupalexsrangedweapons")
	
    inst:ListenForEvent("onthrown", ARCHERYFUNCS.onthrown_regular)
	
    return inst
end

local function shootshadowarrow(inst)
    inst.AnimState:PlayAnimation("shadowarrow_flight")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function shadowarrowfn()
	local inst = commonmagicprojfn("shadowarrow_flight", { "shadow" })
	
	RemovePhysicsColliders(inst)
	
	local light = inst.entity:AddLight()
	
	inst.Light:SetIntensity(0.8)
	inst.Light:SetRadius(3)
	inst.Light:SetFalloff(0.33)
	inst.Light:Enable(true)
	inst.Light:SetColour(119/255, 45/255, 166/255)
	
	inst:AddTag("energy")
	inst:AddTag("nocollisionoverride")
	
	inst.persists = false
	
	if not TheWorld.ismastersim then
        return inst
    end
	
--	inst.Physics:SetCollisionCallback(ARCHERYFUNCS.oncollide)
	
	inst.components.projectile:SetSpeed(40)
	inst.components.projectile:SetOnThrownFn(shootshadowarrow)
	inst.components.projectile:SetOnHitFn(ARCHERYFUNCS.onhitcommon)
	inst.components.projectile:SetOnMissFn(inst.Remove)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	
	return inst
end

local function shootlightarrow(inst)
    inst.AnimState:PlayAnimation("lightarrow_flight")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function lightarrowfn()
	local inst = commonmagicprojfn("lightarrow_flight", { "light" })
	
	RemovePhysicsColliders(inst)
	
	local light = inst.entity:AddLight()
	
	inst.Light:SetIntensity(0.8)
	inst.Light:SetRadius(3)
	inst.Light:SetFalloff(0.33)
	inst.Light:Enable(true)
	inst.Light:SetColour(255/255, 253/255, 54/255)
	
	inst:AddTag("energy")
	inst:AddTag("nocollisionoverride")
	
	inst.persists = false
	
	if not TheWorld.ismastersim then
        return inst
    end
	
--	inst.Physics:SetCollisionCallback(ARCHERYFUNCS.oncollide)
	
	inst.components.projectile:SetSpeed(30)
	inst.components.projectile:SetOnThrownFn(shootlightarrow)
	inst.components.projectile:SetOnHitFn(ARCHERYFUNCS.onhitcommon)
	inst.components.projectile:SetOnMissFn(inst.Remove)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	
	return inst
end

local function shoothealingarrow(inst)
    inst.AnimState:PlayAnimation("healingarrow_flight")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function onhitarrow_healing(inst, attacker, target)
	if target ~= nil then
		if target.components.health ~= nil and not target.components.health:IsDead() then
		target.components.health:DoDelta(25)
		end
		
		if target.components.sanity ~= nil then
			target.components.sanity:DoDelta(-5)
		end
	end
end

local function healingarrowfn()
	local inst = commonmagicprojfn("healingarrow_flight", { "healing" })
	
	RemovePhysicsColliders(inst)
	
	local light = inst.entity:AddLight()
	
	inst.Light:SetIntensity(0.8)
	inst.Light:SetRadius(3)
	inst.Light:SetFalloff(0.33)
	inst.Light:Enable(true)
	inst.Light:SetColour(247/255, 116/255, 255/255)
	
	inst:AddTag("energy")
	inst:AddTag("nocollisionoverride")
	
	inst.persists = false
	
	if not TheWorld.ismastersim then
        return inst
    end
	
--	inst.Physics:SetCollisionCallback(ARCHERYFUNCS.oncollide)
	
	inst.components.zupalexsrangedweapons:SetSpecificOnHitfn(onhitarrow_healing)
	
	inst.components.projectile:SetSpeed(20)
	inst.components.projectile:SetOnThrownFn(shoothealingarrow)
	inst.components.projectile:SetOnHitFn(ARCHERYFUNCS.onhitcommon)
	inst.components.projectile:SetOnMissFn(inst.Remove)
	inst.components.projectile:SetLaunchOffset(Vector3(0.35, 1.05, 0))
	
	return inst
end


return  Prefab("common/inventory/arrow", regulararrowfn, assets, prefabs),
		Prefab("common/inventory/goldarrow", goldarrowfn, assets, prefabs),
		Prefab("common/inventory/moonstonearrow", moonstonearrowfn, assets, prefabs),
		Prefab("common/inventory/firearrow", firearrowfn, assets, prefabs),
		Prefab("common/inventory/icearrow", icearrowfn, assets, prefabs),
		Prefab("common/inventory/thunderarrow", thunderarrowfn, assets, prefabs),
		Prefab("common/inventory/dischargedthunderarrow", dischargedthunderarrowfn("yellow", "wood", "horn"), assets, prefabs),
		Prefab("common/inventory/shadowarrow", shadowarrowfn, assets),
		Prefab("common/inventory/lightarrow", lightarrowfn, assets),
		Prefab("common/inventory/healingarrow", healingarrowfn, assets),
		unpack(arrow_prefabs)
		-- unpack(ReturnPrefabArrows())
		-- unpack(ReturnDischargedHornPrefabs())