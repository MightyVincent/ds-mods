local function init(prefabName)
    AddPrefabPostInit(prefabName, function(inst, ...)
        if inst.components.finiteuses ~= nil then
            function inst.components.finiteuses:Use()
                self:SetUses(self.total)
            end
        end
    end)
end

if config.tent_uses == 0 then
    init("tent")
elseif config.tent_uses then
    TUNING.TENT_USES = config.tent_uses
end

if config.siesta_uses == 0 then
    init("siestahut")
elseif config.siesta_uses then
    TUNING.SIESTA_CANOPY_USES = config.siesta_uses
end

