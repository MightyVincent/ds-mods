local prefabNames = {
    "trap",
    "birdtrap",
}

for _, prefabName in ipairs(prefabNames) do
    AddPrefabPostInit(prefabName, function(prefab)
        if prefab.components.trap ~= nil then
            local trap = prefab.components.trap

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
