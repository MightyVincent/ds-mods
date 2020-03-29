local assets =
{
    Asset("ANIM", "anim/zupalexsingredients.zip"),
	
	Asset("ATLAS", "images/inventoryimages/z_firefliesball.xml"),
    Asset("IMAGE", "images/inventoryimages/z_firefliesball.tex"),
	
	Asset("ATLAS", "images/inventoryimages/z_bluegoop.xml"),
    Asset("IMAGE", "images/inventoryimages/z_bluegoop.tex")
}


local function z_firefliesballfn(proxy)
	local inst = CreateEntity()

	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.Transform:SetFourFaced()
	
    inst.AnimState:SetBank("firefliesball")
    inst.AnimState:SetBuild("zupalexsingredients")
    inst.AnimState:PlayAnimation("idle")
	
	-----------------------------------------------------

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM    
    inst:AddComponent("inspectable")
    inst:AddComponent("fuel")
    inst.components.fuel.fueltype = FUELTYPE.ZUPALEX

    MakeHauntableLaunch(inst)

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "z_firefliesball"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/z_firefliesball.xml"
	
    return inst
end

local function z_bluegoopfn(proxy)
	local inst = CreateEntity()

	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.Transform:SetFourFaced()
	
    inst.AnimState:SetBank("bluegoop")
    inst.AnimState:SetBuild("zupalexsingredients")
    inst.AnimState:PlayAnimation("idle", true)
	
	-----------------------------------------------------

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM    
    inst:AddComponent("inspectable")
    inst:AddComponent("fuel")
    inst.components.fuel.fueltype = FUELTYPE.ZUPALEX

    MakeHauntableLaunch(inst)

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "z_bluegoop"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/z_bluegoop.xml"
	
    return inst
end

return 	Prefab("common/inventory/z_firefliesball", z_firefliesballfn, assets, prefabs),
		Prefab("common/inventory/z_bluegoop", z_bluegoopfn, assets, prefabs)
