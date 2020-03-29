local assets=
{
    Asset("ANIM", "anim/musket.zip"),
    Asset("ANIM", "anim/swap_musket.zip"),
	
    Asset("ATLAS", "images/inventoryimages/musket.xml"),
    Asset("IMAGE", "images/inventoryimages/musket.tex")
}

local prefabs = {

}

---------------------------------------------------------MUSKET-----------------------------------------------------------------------------------

local function OnEquipMusket(inst, owner)
	-- owner.replica.combat._attackrange:set(TUNING.BOWRANGE*TUNING.MUSKETRANGEMOD)

    owner.AnimState:OverrideSymbol("swap_object", "swap_musket", "swap_musket")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onarmedmusket(inst, armer, projtouse)
	if not inst:HasTag("readytoshoot") then		
		local inventory = armer.components.inventory
		if projtouse then
			if inventory and inventory:Has(projtouse, 1) then
				inventory:ConsumeByName(projtouse, 1)
				inst:AddTag("readytoshoot")
			end
		elseif inventory and inventory:Has("musket_bullet", 1) then
			inventory:ConsumeByName("musket_bullet", 1)
			inst:AddTag("readytoshoot")
		elseif inventory and inventory:Has("musket_silverbullet", 1) then
			inventory:ConsumeByName("musket_silverbullet", 1)
			inst:AddTag("readytoshoot")
		end
	end
end

local function OnSaveMusket(inst, data)
	if inst:HasTag("readytoshoot") then
		data.loaded = 1
	end
end

local function OnLoadMusket(inst, data)
	if data~= nil and data.loaded and data.loaded == 1 then
		inst:AddTag("readytoshoot")
	end
end

local function musketfn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local netw = inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
     
    anim:SetBank("musket")
    anim:SetBuild("musket")
    anim:PlayAnimation("musket_idle")
 
	inst:AddTag("musket") -- Tag is not doing anything by itself. I can be called by other stuffs though.
	inst:AddTag("ranged")
	
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
    inst.components.inventoryitem.imagename = "musket"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/musket.xml"
	
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquipMusket )
    inst.components.equippable:SetOnUnequip( ARCHERYFUNCS.CommonOnUnequip )
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange((TUNING.BOWRANGE*TUNING.MUSKETRANGEMOD-2), TUNING.BOWRANGE*TUNING.MUSKETRANGEMOD)
    inst.components.weapon:SetProjectile("musket_bullet")
	inst.components.weapon:SetOnAttack(ARCHERYFUNCS.onattack)
	
	inst:AddComponent("zupalexsrangedweapons")
	inst.components.zupalexsrangedweapons:SetOnArmedFn(onarmedmusket)
	inst.components.zupalexsrangedweapons:SetCooldownTime(1.3)
	
	inst.OnSave = OnSaveMusket
	inst.OnLoad = OnLoadMusket

    MakeHauntableLaunch(inst)
 
    return inst
end


return  Prefab("common/inventory/musket", musketfn, assets, prefabs)