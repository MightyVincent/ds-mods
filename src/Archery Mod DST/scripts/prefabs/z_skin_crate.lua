local assets =
{
    Asset("ANIM", "anim/swap_skin_crate.zip"),
}

local prefabs =
{

}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("am_skin_crate")
    inst.AnimState:SetBuild("swap_skin_crate")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

return Prefab("am_skin_crate", fn, assets, prefabs)