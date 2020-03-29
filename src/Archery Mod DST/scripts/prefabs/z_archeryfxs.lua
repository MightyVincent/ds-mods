local assets=
{

}

local prefabs = {

}

local function AlignToOwner(inst)
    if inst.followtarget ~= nil then
		local ownerrot = inst.followtarget.Transform:GetRotation()
        inst.Transform:SetRotation(ownerrot)
    end
end


local function SetFollowTarget(inst, target, follow_symbol, follow_x, follow_y, follow_z)
    inst.followtarget = target
	if inst.followtarget ~= nil then
		inst.Follower:FollowSymbol(target.GUID, follow_symbol, follow_x, follow_y, follow_z)
		inst.savedfollowtarget = target
	elseif inst.savedfollowtarget ~= nil then
		inst:Remove()
	end
end

local function poisoncloudfn(proxy)
	local inst = CreateEntity()

	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddFollower()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

    inst.AnimState:SetBank("fx")
    inst.AnimState:SetBuild("bow")
    inst.AnimState:PlayAnimation("poisoncloud", true)
	
	-----------------------------------------------------
    inst:AddTag("FX")
	inst:AddTag("NOCLICK")

    inst.persists = false

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.SetFollowTarget = SetFollowTarget

    return inst
end

local function stuneffectfn(proxy)
	local inst = CreateEntity()

	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddFollower()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

    inst.AnimState:SetBank("fx")
    inst.AnimState:SetBuild("bow")
    inst.AnimState:PlayAnimation("stuneffect", true)
	
	-----------------------------------------------------
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
	
    inst.persists = false

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.SetFollowTarget = SetFollowTarget

    return inst
end

local function musketsmokefn(anim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()
	inst.entity:AddAnimState()
    inst:AddTag("NOCLICK")
    inst:AddTag("FX")

    inst.AnimState:SetBank("collapse")
    inst.AnimState:SetBuild("structure_collapse_fx")
    inst.AnimState:PlayAnimation("collapse_small")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
    inst:DoTaskInTime(1, inst.Remove)

	inst:ListenForEvent("animover", inst.Remove)
	
    return inst
end

return  Prefab("common/fx/poisoncloud", poisoncloudfn, assets),
		Prefab("common/fx/stuneffect", stuneffectfn, assets),
		Prefab("common/fx/musketsmoke", musketsmokefn, assets)	