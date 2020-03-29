local assets =
{
    Asset("ANIM", "anim/sparkles.zip"),
	Asset("ANIM", "anim/beamstring.zip")
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

local function sparklesfn(proxy)
	local inst = CreateEntity()

	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddFollower()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("sparkles01")
    inst.AnimState:SetBuild("sparkles")
    inst.AnimState:PlayAnimation("idle", true)
	
	-----------------------------------------------------
    inst:AddTag("FX")

    inst.persists = false

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.SetFollowTarget = SetFollowTarget

    inst:DoPeriodicTask(0, AlignToOwner)

    return inst
end

local function beamstringfn(proxy)
	local inst = CreateEntity()

	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddFollower()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.Transform:SetFourFaced()
	
    inst.AnimState:SetBank("beamstring")
    inst.AnimState:SetBuild("beamstring")
    inst.AnimState:PlayAnimation("drawandshoot")
	
	-----------------------------------------------------
    inst:AddTag("FX")

    inst.persists = false

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.SetFollowTarget = SetFollowTarget

	inst:DoPeriodicTask(0, AlignToOwner)
	
    return inst
end

return 	Prefab("common/fx/sparkles", sparklesfn, assets),
		Prefab("common/fx/beamstring", beamstringfn, assets)
