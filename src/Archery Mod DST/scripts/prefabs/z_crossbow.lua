local assets=
{	 
	Asset("ANIM", "anim/crossbow.zip"),
    Asset("ANIM", "anim/swap_crossbow.zip"),
	 
    Asset("ATLAS", "images/inventoryimages/crossbow.xml"),
    Asset("IMAGE", "images/inventoryimages/crossbow.tex")
}

local prefabs = {

}

------------------------------------------------------------ CROSSBOWS ------------------------------------------------------------

local function onarmedxbow(inst, armer)
	inst:AddTag("readytoshoot")
	armer.AnimState:OverrideSymbol("swap_object", "swap_crossbow", "swap_crossbow_armed")
end

local function OnEquipXbow(inst, owner)
	ARCHERYFUNCS.AssignProjInQuiver(inst, owner)

	-- owner.replica.combat._attackrange:set(TUNING.BOWRANGE*TUNING.CROSSBOWRANGEMOD)
	
	if inst:HasTag("readytoshoot") then
		owner.AnimState:OverrideSymbol("swap_object", "swap_crossbow", "swap_crossbow_armed")
	else
		owner.AnimState:OverrideSymbol("swap_object", "swap_crossbow", "swap_crossbow")
	end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function crossbowfn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local netw = inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
     
    anim:SetBank("crossbow")
    anim:SetBuild("crossbow")
    anim:PlayAnimation("crossbow_idle")
 
	inst:AddTag("crossbow") -- Tag is not doing anything by itself. I can be called by other stuffs though.
	inst:AddTag("ranged")
	inst:AddTag("usequiverproj")
	
 --The following section is suitable for a DST compatible prefab.
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
    inst.components.inventoryitem.imagename = "crossbow"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/crossbow.xml"
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquipXbow )
    inst.components.equippable:SetOnUnequip( ARCHERYFUNCS.CommonOnUnequip )
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange((TUNING.BOWRANGE*TUNING.CROSSBOWRANGEMOD - 2), TUNING.BOWRANGE*TUNING.CROSSBOWRANGEMOD)
    inst.components.weapon:SetProjectile("bolt")
	inst.components.weapon:SetOnAttack(ARCHERYFUNCS.onattack)
	
	inst:AddComponent("zupalexsrangedweapons")
	inst.components.zupalexsrangedweapons:SetCooldownTime(1.5)
	inst.components.zupalexsrangedweapons:SetOnArmedFn(onarmedxbow)
	
    MakeHauntableLaunch(inst)
 
    return inst
end

return  Prefab("common/inventory/crossbow", crossbowfn, assets, prefabs)