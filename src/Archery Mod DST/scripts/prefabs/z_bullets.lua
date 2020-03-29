local assets=
{
    Asset("ATLAS", "images/inventoryimages/musket_bullet.xml"),
    Asset("IMAGE", "images/inventoryimages/musket_bullet.tex")
}

local prefabs = {
	"musketsmoke"
}

local function shootmusketbullet(inst)
	local smoke = SpawnPrefab("musketsmoke")
	local smokeposx, smokeposy, smokeposz = inst.Transform:GetWorldPosition()
	smoke.Transform:SetPosition(smokeposx, smokeposy, smokeposz)
	smoke.AnimState:SetScale(0.5,0.5,-1)
	
    inst.AnimState:PlayAnimation("flight")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function musket_bulletfn() 
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local netw = inst.entity:AddNetwork()
 
    MakeInventoryPhysics(inst)
 
 	anim:SetBank("bullet")
    anim:SetBuild("musket")
    anim:PlayAnimation("idle")
 
	inst:AddTag("projectile") -- Tag is not doing anything by itself. I can be called by other stuffs though.
	inst:AddTag("bullet")
	inst:AddTag("zrw_valid")
	
 --The following section is suitable for a DST compatible prefab.
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then	
        return inst
    end
----------------------------------------------------------------
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "musket_bullet"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/musket_bullet.xml"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(0)
	inst:AddComponent("projectile")	
	inst.components.projectile:SetSpeed(80)
	inst.components.projectile:SetOnHitFn(ARCHERYFUNCS.onhitcommon)
	inst.components.projectile:SetOnMissFn(inst.Remove)
	inst.components.projectile:SetLaunchOffset(Vector3(1, 1.05, 0))
	inst.components.projectile:SetOnThrownFn(shootmusketbullet)
	inst:ListenForEvent("onthrown", ARCHERYFUNCS.onthrown_regular)
	
	inst:AddComponent("zupalexsrangedweapons")
	inst.components.zupalexsrangedweapons:SetBaseDamage(TUNING.BOWDMG*TUNING.MUSKETDMGMOD)
	 
    return inst
end

return  Prefab("common/inventory/musket_bullet", musket_bulletfn, assets, prefabs)