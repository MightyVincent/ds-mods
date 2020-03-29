local prefabNames = {
    "chester",
    "hutch",
    "packim",
}
local leaderNames = {
    "chester_eyebone",
    "hutch_fishbowl",
    "packim_fishbone",
}

-- follower
local function updateFollowerState(followerInst)
    local follower = followerInst and followerInst.components.follower or nil
    if not follower then
        return
    end
    local invincible = false

    local leaderInst = follower.leader
    if leaderInst then
        if leaderInst:HasTag("player") then
            invincible = true
        else
            local owner = leaderInst.components.inventoryitem and leaderInst.components.inventoryitem.owner or nil
            if owner and owner:HasTag("player") then
                invincible = true
            end
        end
    end

    if invincible then
        followerInst:AddTag("playerghost")
        --followerInst:AddTag("notarget")
        --followerInst:AddTag("noattack")
    else
        followerInst:RemoveTag("playerghost")
        --followerInst:RemoveTag("notarget")
        --followerInst:RemoveTag("noattack")
    end
end

for _, prefabName in ipairs(prefabNames) do
    AddPrefabPostInit(prefabName, function(inst)
        inst:ListenForEvent("startfollowing", updateFollowerState)
        inst:ListenForEvent("stopfollowing", updateFollowerState)
    end)
end

local prefabMap = {}
for _, prefabName in ipairs(prefabNames) do
    prefabMap[prefabName] = true
end

local function findAndUpdateFollowerState(leaderInst)
    local leader = leaderInst and leaderInst.components.leader or nil
    if leader then
        for followerInst, _ in pairs(leader.followers) do
            if prefabMap[followerInst.prefab] then
                updateFollowerState(followerInst)
            end
        end
    end
end

for _, prefabName in ipairs(leaderNames) do
    AddPrefabPostInit(prefabName, function(inst)
        inst:ListenForEvent("onputininventory", function(...)
            findAndUpdateFollowerState(inst)
        end)
        inst:ListenForEvent("ondropped", function(...)
            findAndUpdateFollowerState(inst)
        end)
    end)
end

