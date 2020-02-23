local prefabs = {
    "trap",
    "birdtrap",
}

for _, prefab in ipairs(prefabs) do
    AddPrefabPostInit(prefab, function(inst)
        if inst.components.trap ~= nil then
            local trap = inst.components.trap

            local _Harvest = trap.Harvest
            function trap:Harvest(doer)
                local inventory = doer ~= nil and doer.components.inventory or nil
                if inventory ~= nil then
                    -- hack
                    local _GiveItem = inventory.GiveItem
                    function inventory:GiveItem(item, slot, src_pos)
                        if item == trap.inst and src_pos == trap.inst:GetPosition() then
                            -- nothing, don't pick it up
                        else
                            _GiveItem(self, item, slot, src_pos)
                        end
                    end

                    _Harvest(self, doer)
                    self.inst:PushEvent("ondropped")

                    -- restore
                    inventory.GiveItem = _GiveItem
                else
                    _Harvest(self, doer)
                end
            end
        end
    end)
end

--[[
local includeBuild = {
    trap = true,
    birdtrap = true,
}
AddComponentPostInit("trap", function(self)
    if includeBuild[self.inst.AnimState:GetBuild()] then
        local _Harvest = self.Harvest
        function self:Harvest(doer)
            local inventory = doer ~= nil and doer.components.inventory or nil
            if inventory ~= nil then
                local trap = self
                local _GiveItem = inventory.GiveItem

                function inventory:GiveItem(item, slot, src_pos)
                    if item == trap.inst and src_pos == trap.inst:GetPosition() then
                        -- nothing, don't pick it up
                    else
                        _GiveItem(self, item, slot, src_pos)
                    end
                end

                _Harvest(self, doer)
                self.inst:PushEvent("ondropped")

                inventory.GiveItem = _GiveItem
            else
                _Harvest(self, doer)
            end
        end
    end
end)
]]
