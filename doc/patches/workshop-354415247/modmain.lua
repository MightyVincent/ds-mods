local ModConfigData = {
    throwable_spear_config = {
        SMALL_MISS_CHANCE = GetModConfigData("SMALL_MISS_CHANCE"),
        SMALL_USES = GetModConfigData("SMALL_USES"),
        SMALL_HITS = {
            frog = false,
            penguin = false,
            eyeplant = false,
        },
        LARGE_USES = GetModConfigData("LARGE_USES"),
        RANGE_CHECK = GetModConfigData("RANGE_CHECK"),
    }
}

PrefabFiles = {
    "spear_projectile"
}
Assets = {
    Asset("ANIM", "anim/spear_projectile.zip"),
}

AddPrefabPostInit("spear", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    inst:AddComponent('spearthrowable')
    inst.components.spearthrowable:SetRange(8, 10)
    inst.components.spearthrowable:SetOnAttack(ModConfigData.throwable_spear_config)
    inst.components.spearthrowable:SetProjectile("spear_projectile")
end)

local SPEARTHROW = AddAction("SPEARTHROW", "Throw Spear", function(act)
    if act.invobject then
        local pvp = GLOBAL.TheNet:GetPVPEnabled()
        local target = act.target
        if target == nil then
            for k, v in pairs(GLOBAL.TheSim:FindEntities(act.pos.x, act.pos.y, act.pos.z, 20)) do
                if v.replica and v.replica.combat and v.replica.combat:CanBeAttacked(act.doer) and
                        act.doer.replica and act.doer.replica.combat and act.doer.replica.combat:CanTarget(v)
                        and (not v:HasTag("wall")) and (pvp or ((not pvp)
                        and (not (act.doer:HasTag("player") and v:HasTag("player"))))) then
                    target = v
                    break
                end
            end
        end
        if target then
            local prefab = act.invobject.prefab
            act.invobject.components.spearthrowable:LaunchProjectile(act.doer, target)
            local newspear = act.doer.components.inventory:FindItem(function(item)
                return item.prefab == prefab
            end)
            if newspear then
                act.doer.components.inventory:Equip(newspear)
            end
        elseif act.doer.components and act.doer.components.talker then
            local fail_message = "There's nothing to throw it at."
            if act.doer.prefab == 'wx78' then
                fail_message = "NO TARGET"
            end
            act.doer.components.talker:Say(fail_message)
        end
        return true
    end
end)
SPEARTHROW.priority = 4
SPEARTHROW.rmb = true
SPEARTHROW.distance = 10
SPEARTHROW.mount_valid = true

local State = GLOBAL.State
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
local FRAMES = GLOBAL.FRAMES

local throw_spear = State({
    name = "throw_spear",
    tags = { "attack", "notalking", "abouttoattack", "autopredict" },
    onenter = function(inst)
        local buffaction = inst:GetBufferedAction()
        local target = buffaction ~= nil and buffaction.target or nil
        inst.components.combat:SetTarget(target)
        inst.components.combat:StartAttack()
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation("throw")

        inst.sg:SetTimeout(2)

        if target ~= nil and target:IsValid() then
            inst:FacePoint(target.Transform:GetWorldPosition())
            inst.sg.statemem.attacktarget = target
        elseif buffaction ~= nil and buffaction.pos ~= nil then
            inst:FacePoint(buffaction.pos)
        end
    end,
    timeline = {
        TimeEvent(7 * FRAMES, function(inst)
            inst:PerformBufferedAction()
            inst.sg:RemoveStateTag("abouttoattack")
        end),
    },
    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
    end,
    events = {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },
    onexit = function(inst)
        inst.components.combat:SetTarget(nil)
        if inst.sg:HasStateTag("abouttoattack") then
            inst.components.combat:CancelAttack()
        end
    end,
})
AddStategraphState("wilson", throw_spear)

local throw_spear_client = State({
    name = "throw_spear",
    tags = { "attack", "notalking", "abouttoattack" },
    onenter = function(inst)
        local buffaction = inst:GetBufferedAction()
        inst.replica.combat:StartAttack()
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation("throw")

        inst.sg:SetTimeout(2)

        if buffaction ~= nil then
            local target = buffaction.target or nil
            if target ~= nil and target:IsValid() then
                inst:FacePoint(target.Transform:GetWorldPosition())
                inst.sg.statemem.attacktarget = target
            elseif buffaction.pos ~= nil then
                inst:ForceFacePoint(buffaction:GetActionPoint():Get())
            end
            inst:PerformPreviewBufferedAction()
        end
    end,
    timeline = {
        TimeEvent(7 * FRAMES, function(inst)
            inst:ClearBufferedAction()
            inst.sg:RemoveStateTag("abouttoattack")
        end),
    },
    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
    end,
    events = {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },
    onexit = function(inst)
        if inst.sg:HasStateTag("abouttoattack") then
            inst.replica.combat:CancelAttack()
        end
    end,
})
AddStategraphState("wilson_client", throw_spear_client)

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(SPEARTHROW, function(inst, action)
    if not inst.sg:HasStateTag("attack") then
        return "throw_spear"
    end
end))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(SPEARTHROW, function(inst, action)
    if not inst.sg:HasStateTag("attack") then
        return "throw_spear"
    end
end))

local function spearthrow_point(inst, doer, pos, actions, right)
    if right then
        local target = nil
        local pvp = GLOBAL.TheNet:GetPVPEnabled()
        if RANGE_CHECK then
            for k, v in pairs(GLOBAL.TheSim:FindEntities(pos.x, pos.y, pos.z, 2)) do
                if v.replica and v.replica.combat and v.replica.combat:CanBeAttacked(doer) and
                        doer.replica and doer.replica.combat and doer.replica.combat:CanTarget(v)
                        and (not v:HasTag("wall")) and (pvp or ((not pvp)
                        and (not (doer:HasTag("player") and v:HasTag("player")))))
                        and (doer.components.playercontroller:IsControlPressed(GLOBAL.CONTROL_FORCE_ATTACK)
                        or not doer.replica.combat:IsAlly(v)) then
                    target = v
                    break
                end
            end
        end
        if target then
            table.insert(actions, GLOBAL.ACTIONS.SPEARTHROW)
        end
    end
end

AddComponentAction("POINT", "spearthrowable", spearthrow_point)

local function spearthrow_target(inst, doer, target, actions, right)
    local pvp = GLOBAL.TheNet:GetPVPEnabled()
    if right and (not target:HasTag("wall"))
            and doer.replica.combat ~= nil
            and doer.replica.combat:CanTarget(target)
            and target.replica.combat:CanBeAttacked(doer)
            and (pvp or ((not pvp)
            and (not (doer:HasTag("player") and target:HasTag("player")))))
            and (doer.components.playercontroller:IsControlPressed(GLOBAL.CONTROL_FORCE_ATTACK)
            or not doer.replica.combat:IsAlly(target)) then
        table.insert(actions, GLOBAL.ACTIONS.SPEARTHROW)
    end
end

AddComponentAction("EQUIPPED", "spearthrowable", spearthrow_target)
