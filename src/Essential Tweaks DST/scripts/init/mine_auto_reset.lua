local prefabNames = {
    "trap_teeth",
    "trap_teeth_maxwell",
    "trap_bramble",
}

for _, prefabName in ipairs(prefabNames) do
    AddPrefabPostInit(prefabName, function(prefab)
        if prefab.components.mine ~= nil then
            local mine = prefab.components.mine
            local function _ResetInTime(self, timeout)
                self.inst:DoPeriodicTask(timeout, function()
                    if (self.issprung) then
                        self:Reset()
                    end
                end)
            end

            local _Explode = mine.Explode
            function mine:Explode(target)
                _Explode(self, target)
                _ResetInTime(self, 5)
            end

            local _OnLoad = mine.OnLoad
            function mine:OnLoad(data)
                _OnLoad(self, data)
                _ResetInTime(self, 5)
            end
        end
    end)
end
