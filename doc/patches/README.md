# issues

### workshop-354415247 Throwable Spears

range check导致的crash
```lua
-- modmain.lua:135~144
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
```

### workshop-385006082 Path Light

灯光调整
```lua
-- path_light.lua:17
local function fuelit_update(inst)
    if TheWorld.state.isday then
        inst.Light:Enable(false)
        inst.AnimState:PlayAnimation("idle_off")
        inst.components.fueled:StopConsuming()
    elseif not inst.components.fueled:IsEmpty() then
        inst.components.fueled:StartConsuming()
        inst.Light:Enable(true)
        inst.Light:SetRadius(2)
        inst.Light:SetFalloff(.6)
        inst.Light:SetIntensity(.7)
        if color1 then
            inst.Light:SetColour(0, 0 / 0, 255 / 255)
        elseif color2 then
            inst.Light:SetColour(255 / 255, 0, 0)
        elseif color3 then
            inst.Light:SetColour(0, 255 / 255, 0)
        else--if color4 then
            inst.Light:SetColour(255 / 255, 255 / 255, 255 / 255)
        end
        inst.AnimState:PlayAnimation("idle_on")
        fuelupdate(inst)
    end
end
```

### workshop-1561425565 RPG Items

~~与某MOD冲突问题~~
```lua
        -- modmain.lua:110~116
		if inst.components.weapon and inst.components.rpgweapon == nil then
			inst:AddComponent("rpgweapon")
		elseif inst.components.armor and inst.components.rpgarmor == nil then
			inst:AddComponent("rpgarmor")
		end
		if not inst.components.named then
			inst:AddComponent("named")
		end
```

~~关闭鉴定机制后前缀重叠问题~~
```lua
        -- rpgarmor.lua:162~173
		if self.discovered == true then
			if not self.renamed then
				self.inst.components.named:SetName(STRINGS.RPGITEMS.ARMOR.NAMES[self.currenttype] .. " ".. self.inst.originalnamepremod)
				self.renamed = true
			end
		else
			if TUNING.RPGITEMSMustUnidentify then
				self.inst.components.named:SetName(self.inst.originalnamepremod .. " (?)")
				self.renamed = true
			else
				self:Identify()
			end
		end

        -- rpgweapon.lua:131~142
		if self.discovered == true then
			if not self.renamed then
				self.inst.components.named:SetName(STRINGS.RPGITEMS.WEAPONS.NAMES[self.currenttype] .. " ".. self.inst.originalnamepremod)
				self.renamed = true
			end
		else
			if TUNING.RPGITEMSMustUnidentify then
				self.inst.components.named:SetName(self.inst.originalnamepremod .. " (?)")
				self.renamed = true
			else
				self:Identify()
			end
		end
```
