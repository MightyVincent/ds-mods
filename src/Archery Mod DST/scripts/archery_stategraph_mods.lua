bow_attack = State({
    name = "bow",
    tags = { "attack", "notalking", "abouttoattack", "autopredict" },

    onenter = function(inst)
        local buffaction = inst:GetBufferedAction()
--		print("buffaction in host SG : ", buffaction)
        local target = (buffaction ~= nil and buffaction.target) or inst.fatarget or nil
		local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local wornhat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		local quiver = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
		local projinquiver = nil
		
		inst.components.combat:SetTarget(target)
		inst.components.locomotor:Stop()
	
		inst.isBowMagic = false	
		global_magicweaponhasfuel = false
		
		if equip:HasTag("magic") then
			inst.isBowMagic = true
			
			if equip:HasTag("hasfuel") then
				global_magicweaponhasfuel = true
			end
		end
		
		global_havequiver = false
		global_havearrow = false	
		global_projtypeok = false
		
		-- local cooldown = 60 * FRAMES
		
--		print("I am in the state and the quiver is : ", quiver)

		if not inst.isBowMagic then
			if quiver ~= nil and quiver.replica.container ~= nil then
				global_havequiver = true
				projinquiver = quiver.replica.container:GetItemInSlot(1)
			end
			
			if projinquiver ~= nil then
				global_havearrow = true
				global_projtypeok = projinquiver:HasTag("arrow") and projinquiver:HasTag("zrw_valid")
			end
		end
		
--		print("target in host SG : ", target)
		if target ~= nil and not (target:HasTag("wall") or target:HasTag("butterfly")) then
			global_targetisok = true
		else
			global_targetisok = false
		end

		global_conditions_fulfilled = false
		if ((global_havequiver and global_havearrow and global_projtypeok) or (inst.isBowMagic and global_magicweaponhasfuel)) and global_targetisok then
			global_conditions_fulfilled = true
		end
		
--		print("Conditions status is : ", global_havequiver, "   ", global_havearrow, "   ", global_targetisok, "   ", global_projtypeok, "   => ", global_conditions_fulfilled)
		
		if not global_conditions_fulfilled then
			inst.AnimState:PlayAnimation("idle", true)
		end
		
--		print("have arrow : ", global_havearrow, "   /   target is ok : ", global_targetisok)			
		
	    if equip ~= nil and equip.components.zupalexsrangedweapons ~= nil and global_conditions_fulfilled then
			inst.components.combat:StartAttack()
		
--			print("And I found the BOW on the host!")
			if inst.isBowMagic then
				inst.AnimState:PlayAnimation("bow_attack_old")
			else
				inst.AnimState:PlayAnimation("bow_attack")
			end

			inst.xoffsetBS = -70
			inst.yoffsetBS = 90
			inst.zoffsetBS = 0
			
			if inst.AnimState:GetCurrentFacing() == GLOBAL.FACING_UP then
				inst.zoffsetBS = -0.1
				-- if wornhat ~= nil then
-- --					print("hat and face up")
					-- inst.AnimState:Hide("timeline_0")
				-- else
--					print("no hat and face up")
					-- inst.AnimState:Hide("timeline_15")
				-- end
			elseif inst.AnimState:GetCurrentFacing() == GLOBAL.FACING_DOWN then
				inst.xoffsetBS = -65
				inst.yoffsetBS = 85
				-- if wornhat ~= nil then
-- --					print("hat and face down")
					-- inst.AnimState:Hide("timeline_3")
				-- else
--				print("no hat and face down")
				-- inst.AnimState:Hide("timeline_16")
				-- end
			else
				-- if wornhat ~= nil then
-- --					print("hat and face side")
					-- inst.AnimState:Hide("timeline_3")
				-- else
-- --				print("no hat and face side")
				-- inst.AnimState:Hide("timeline_16")
				-- end
			end
        end

		-- inst.sg:SetTimeout(cooldown)
		
        if target ~= nil and target:IsValid() then
            inst:FacePoint(target.Transform:GetWorldPosition())
            inst.sg.statemem.attacktarget = target
        end
    end,

    timeline =
    {		
		TimeEvent(0 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										if inst.isBowMagic then
											inst.beamstring = GLOBAL.SpawnPrefab("beamstring")
											inst.beamstring.Transform:SetPosition(inst:GetPosition():Get())
											inst.beamstring:SetFollowTarget(inst, "swap_beamstring", inst.xoffsetBS, inst.yoffsetBS, inst.zoffsetBS)
											inst.beamstring.AnimState:PlayAnimation("drawandshoot")
											inst.beamstring.AnimState:SetLayer(GLOBAL.LAYER_WORLD)
--											inst.beamstring.AnimState:SetSortOrder(0)
	
											inst.SoundEmitter:PlaySound("bow_shoot/magicbow_shoot/buzz", "buzz")
										else
											inst.SoundEmitter:PlaySound("bow_shoot/bow_shoot/bow_draw")
										end
									else
										inst.sg:RemoveStateTag("abouttoattack")
										inst:ClearBufferedAction()
									end
								end),	
	
		TimeEvent(8 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										if inst.isBowMagic then
											inst.SoundEmitter:PlaySound("bow_shoot/magicbow_shoot/shot")
										else
											inst.SoundEmitter:PlaySound("bow_shoot/bow_shoot/bow_shoot")
										end
									end
								end),	
	
		TimeEvent(14 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										inst:PerformBufferedAction()
										inst.sg:RemoveStateTag("abouttoattack")
									end
								end),
							
		TimeEvent(16 * FRAMES, function(inst)
									if not global_conditions_fulfilled then
										inst.AnimState:PlayAnimation("idle")
									elseif inst.isBowMagic then
										inst.SoundEmitter:KillSound("buzz")
									end
								end),							
    },

    -- ontimeout = function(inst)
        -- inst.sg:RemoveStateTag("attack")
        -- inst.sg:AddStateTag("idle")
		-- inst.fatarget = nil
    -- end,

    events =
    {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
--		print("I exit the SG of the host NOW")
		inst.fatarget = nil
        inst.components.combat:SetTarget(nil)
        if inst.sg:HasStateTag("abouttoattack") then
            inst.components.combat:CancelAttack()
        end
		
		if inst.isBowMagic and inst.beamstring ~= nil then
			inst.beamstring:Remove()
		end
		
		
		if inst.components.talker then
			if not inst.isBowMagic then
				if not global_havequiver then
					local noquiver_message = "I should first get a quiver!"
					inst.components.talker:Say(noquiver_message)
				elseif not global_havearrow then
					local noammo_message = "My quiver is empty!"
					inst.components.talker:Say(noammo_message)
				elseif not global_projtypeok then
					local badammo_message = "This won't fit it my current weapon..."
					inst.components.talker:Say(badammo_message)
				elseif global_targetislimbo then
					local targetinlimbo_message = "It's too late now..."
					inst.components.talker:Say(targetinlimbo_message)
				elseif not global_targetisok then
					local fail_message = "There's no potential target on sight."
					inst.components.talker:Say(fail_message)
				end
			else
				if not global_magicweaponhasfuel then
					local nomagicfuel_message = "It looks like this stuff ran out of juice."
					inst.components.talker:Say(nomagicfuel_message)
				end
			end
		end
		
		-- inst.AnimState:Show("timeline_0")
		-- inst.AnimState:Show("timeline_3")
		-- inst.AnimState:Show("timeline_15")
		-- inst.AnimState:Show("timeline_16")
		
		inst.isBowMagic = nil
    end,		
})

bow_attack_client = State({
        name = "bow",
        tags = { "attack", "notalking", "abouttoattack", "autopredict" },

    onenter = function(inst)
        local buffaction = inst:GetBufferedAction()
        local target = buffaction ~= nil and buffaction.target or nil
		local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local wornhat = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		local quiver = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
		local projinquiver = nil
		
        inst.components.locomotor:Stop()
		
--		print("I am in the StateGraph for the client !")

		inst.isBowMagic = false	
		global_magicweaponhasfuel = false
		
		if equip:HasTag("magic") then
			inst.isBowMagic = true
			
			if equip:HasTag("hasfuel") then
				global_magicweaponhasfuel = true
			end
		end
		
		global_havequiver = false
		global_havearrow = false	
		global_projtypeok = false

		-- local cooldown = 60 * FRAMES
		
--		print("I am in the state and the quiver is : ", quiver)

		if not inst.isBowMagic then
			if quiver ~= nil and quiver.replica.container ~= nil then
				global_havequiver = true
				projinquiver = quiver.replica.container:GetItemInSlot(1)
			end
			
			if projinquiver ~= nil then
				global_havearrow = true
				global_projtypeok = projinquiver:HasTag("arrow") and projinquiver:HasTag("zrw_valid")
			end
		end
		
		if target ~= nil and not (target:HasTag("wall") or target:HasTag("butterfly")) then
			global_targetisok = true
		else
			global_targetisok = false
		end

		global_conditions_fulfilled = false
		if ((global_havequiver and global_havearrow and global_projtypeok) or (inst.isBowMagic and global_magicweaponhasfuel)) and global_targetisok then
			global_conditions_fulfilled = true
		end
		
--		print("Conditions status is : ", global_havequiver, "   ", global_havearrow, "   ", global_targetisok, "   ", global_projtypeok, "   => ", global_conditions_fulfilled)
		
		if not global_conditions_fulfilled then
			inst.AnimState:PlayAnimation("idle", true)
		end
		
	    if equip ~= nil and equip:HasTag("bow") and global_conditions_fulfilled then
		    inst.replica.combat:StartAttack()
		
			-- inst.AnimState:PlayAnimation("bow_attack")
			
			inst.xoffsetBS = -70
			inst.yoffsetBS = 90
			inst.zoffsetBS = 0
			
			if inst.AnimState:GetCurrentFacing() == GLOBAL.FACING_UP then
				inst.zoffsetBS = -0.1
				-- if wornhat ~= nil then
-- --					print("hat and face up")
					-- inst.AnimState:Hide("timeline_0")
				-- else
-- --					print("no hat and face up")
					-- inst.AnimState:Hide("timeline_15")
				-- end
			elseif inst.AnimState:GetCurrentFacing() == GLOBAL.FACING_DOWN then
				inst.xoffsetBS = -65
				inst.yoffsetBS = 85
				-- if wornhat ~= nil then
-- --					print("hat and face down")
					-- inst.AnimState:Hide("timeline_3")
				-- else
-- --				print("no hat and face down")
				-- inst.AnimState:Hide("timeline_16")
				-- end
			else
				-- if wornhat ~= nil then
-- --					print("hat and face side")
					-- inst.AnimState:Hide("timeline_3")
				-- else
-- --				print("no hat and face side")
				-- inst.AnimState:Hide("timeline_16")
				-- end
			end
        end

		-- inst.sg:SetTimeout(cooldown) 

		if buffaction ~= nil then
			inst:PerformPreviewBufferedAction()
		end
		
        if target ~= nil and target:IsValid() then
            inst:FacePoint(target.Transform:GetWorldPosition())
            inst.sg.statemem.attacktarget = target
        end
    end,

    timeline =
    {
		TimeEvent(0 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										if inst.isBowMagic then
											inst.AnimState:PlayAnimation("bow_attack_old")
											inst.SoundEmitter:PlaySound("bow_shoot/magicbow_shoot/buzz", "buzz", nil, true)
										else
											inst.AnimState:PlayAnimation("bow_attack")
											inst.SoundEmitter:PlaySound("bow_shoot/bow_shoot/bow_draw")
										end
									else
										inst.sg:RemoveStateTag("abouttoattack")
										inst:ClearBufferedAction()
									end
							end),	

		-- TimeEvent(2 * FRAMES, function(inst)
									-- if global_conditions_fulfilled then
										-- inst.AnimState:PlayAnimation("bow_attack")
									-- end
							-- end),
							
		TimeEvent(8 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										if inst.isBowMagic then
											inst.SoundEmitter:PlaySound("bow_shoot/magicbow_shoot/shot", nil, nil, true)
										else
										inst.SoundEmitter:PlaySound("bow_shoot/bow_shoot/bow_shoot", nil, nil, true)
										end
									end
							end),	
							
		TimeEvent(14 * FRAMES, function(inst)
								if global_conditions_fulfilled then
									inst:ClearBufferedAction()
									inst.sg:RemoveStateTag("abouttoattack")
								end
							end),
							
		TimeEvent(16 * FRAMES, function(inst)
									if not global_conditions_fulfilled then
										inst.AnimState:PlayAnimation("idle")
									elseif inst.isBowMagic then
										inst.SoundEmitter:KillSound("buzz")
									end
								end),
    },

    -- ontimeout = function(inst)
        -- inst.sg:RemoveStateTag("attack")
        -- inst.sg:AddStateTag("idle")
    -- end,

    events =
    {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
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
		
		if inst.components.talker then
			if not inst.isBowMagic then
				if not global_havequiver then
					local noquiver_message = "I should first get a quiver!"
					inst.components.talker:Say(noquiver_message)
				elseif not global_havearrow then
					local noammo_message = "My quiver is empty!"
					inst.components.talker:Say(noammo_message)
				elseif not global_projtypeok then
					local badammo_message = "This won't fit it my current weapon..."
					inst.components.talker:Say(badammo_message)
				elseif global_targetislimbo then
					local targetinlimbo_message = "It's too late now..."
					inst.components.talker:Say(targetinlimbo_message)
				elseif not global_targetisok then
					local fail_message = "There's no potential target on sight."
					inst.components.talker:Say(fail_message)
				end
			else
				if not global_magicweaponhasfuel then
					local nomagicfuel_message = "It looks like this stuff ran out of juice."
					inst.components.talker:Say(nomagicfuel_message)
				end
			end
		end
		
		-- inst.AnimState:Show("timeline_0")
		-- inst.AnimState:Show("timeline_3")
		-- inst.AnimState:Show("timeline_15")
		-- inst.AnimState:Show("timeline_16")
		
		inst.isBowMagic = nil
    end,		
})

crossbow_attack = State({
    name = "crossbow",
    tags = { "attack", "notalking", "abouttoattack", "autopredict" },

    onenter = function(inst)
        local buffaction = inst:GetBufferedAction()
        local target = (buffaction ~= nil and buffaction.target) or inst.fatarget or nil
		local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local wornhat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		local quiver = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
		local projinquiver = nil
		
		global_weapname = equip.prefab
		
		inst.components.combat:SetTarget(target)
		inst.components.locomotor:Stop()
		
		local ArrowsInInv = false
		
--		local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES
		local cooldown = 50 * FRAMES
		
--		print("I am in the state and the quiver is : ", quiver)
		
		if quiver ~= nil and quiver.replica.container ~= nil then
			global_havequiver = true
			projinquiver = quiver.replica.container:GetItemInSlot(1)
		else
			global_havequiver = false
		end
		
		global_projtypeok = false
		if projinquiver ~= nil then
			global_havearrow = true
			global_projtypeok = projinquiver:HasTag("bolt") and projinquiver:HasTag("zrw_valid")
		else
			global_havearrow = false
		end
		
		if equip:HasTag("zupalexsrangedweapons") and (equip:HasTag("crossbow") or equip:HasTag("musket")) and equip:HasTag("readytoshoot") then
			global_xbowisarmed = true
		else
			global_xbowisarmed = false
		end
		
		if target ~= nil and not (target:HasTag("wall") or target:HasTag("butterfly")) then
			global_targetisok = true
		else
			global_targetisok = false
		end		
	
		if equip:HasTag("musket") then
			global_havequiver = true
			global_havearrow = true
			global_projtypeok = true
		end
	
		global_conditions_fulfilled = false	
		if global_havequiver and global_havearrow and global_targetisok and global_projtypeok and global_xbowisarmed then
			global_conditions_fulfilled = true
		end
		
--		print("Conditions status is : ", global_havequiver, "   ", global_havearrow, "   ", global_targetisok, "   ", global_projtypeok, "   => ", global_conditions_fulfilled)
		
		if not global_conditions_fulfilled then
			inst.AnimState:PlayAnimation("idle", true)
		end
			
--		print("have arrow : ", global_havearrow, "   /   target is ok : ", global_targetisok)			
			
	    if equip ~= nil and global_conditions_fulfilled then
			inst.components.combat:StartAttack()
		
--			print("And I found the BOW on the host!")
			inst.AnimState:PlayAnimation("crossbow_attack")

			if wornhat ~= nil then
				if inst.AnimState:GetCurrentFacing() == GLOBAL.FACING_UP then
--					print("hat and face up")
					inst.AnimState:Hide("timeline_0")
				elseif inst.AnimState:GetCurrentFacing() == GLOBAL.FACING_DOWN then
--					print("hat and face down")
					inst.AnimState:Hide("timeline_3")
				else
--					print("hat and face side")
					inst.AnimState:Hide("timeline_3")
				end
			else
				if inst.AnimState:GetCurrentFacing() == GLOBAL.FACING_UP then
--					print("no hat and face up")
					inst.AnimState:Hide("timeline_15")
				elseif inst.AnimState:GetCurrentFacing() == GLOBAL.FACING_DOWN then
--					print("no hat and face down")
					inst.AnimState:Hide("timeline_16")
				else
--					print("no hat and face side")
					inst.AnimState:Hide("timeline_16")
				end
			end
        end

		inst.sg:SetTimeout(cooldown)
		
        if target ~= nil and target:IsValid() then
            inst:FacePoint(target.Transform:GetWorldPosition())
            inst.sg.statemem.attacktarget = target
        end
    end,

    timeline =
    {	
		TimeEvent(0 * FRAMES, function(inst)
									if not global_conditions_fulfilled then
										inst.sg:RemoveStateTag("abouttoattack")
										inst:ClearBufferedAction()
									end
								end),
	
		TimeEvent(15 * FRAMES, function(inst)
									if not global_conditions_fulfilled then
										inst.AnimState:PlayAnimation("idle")
									end
								end),
	
		TimeEvent(18 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										if global_weapname == "crossbow" then
											inst.SoundEmitter:PlaySound("bow_shoot/bow_shoot/bow_shoot", nil, nil, true)
										elseif global_weapname == "musket" then
											inst.SoundEmitter:PlaySound("bow_shoot/musket/shot", nil, nil, true)
										end
									end
								end),	
	
		TimeEvent(23 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										inst.sg:RemoveStateTag("abouttoattack")
										inst:PerformBufferedAction()
									end
								end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
		inst.fatarget = nil
    end,

    events =
    {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
--		print("I exit the SG of the host NOW")
		inst.fatarget = nil
        inst.components.combat:SetTarget(nil)
        if inst.sg:HasStateTag("abouttoattack") then
            inst.components.combat:CancelAttack()
        end
		
		if inst.components.talker then
			if not global_havequiver then
				local noquiver_message = "I should first get a quiver!"
				inst.components.talker:Say(noquiver_message)
			elseif not global_havearrow then
				local noammo_message = "My quiver is empty!"
				inst.components.talker:Say(noammo_message)
			elseif not global_projtypeok then
				local badammo_message = "This won't fit it my current weapon..."
				inst.components.talker:Say(badammo_message)
			elseif not global_xbowisarmed then
				local xbownotarmed_message = "I won't shoot far if I don't arm it first..."
				inst.components.talker:Say(xbownotarmed_message)
			elseif global_targetislimbo then
				local targetinlimbo_message = "It's too late now..."
				inst.components.talker:Say(targetinlimbo_message)
			elseif not global_targetisok then
				local fail_message = "There's no potential target on sight."
				inst.components.talker:Say(fail_message)
			end
		end
		
		inst.AnimState:Show("timeline_0")
		inst.AnimState:Show("timeline_3")
		inst.AnimState:Show("timeline_15")
		inst.AnimState:Show("timeline_16")
    end,		
})


crossbow_arm = State({
    name = "crossbow_arm",
    tags = { "doing", "busy" },

    onenter = function(inst)
		local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local wornhat = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		
		global_weapname = equip.prefab
		global_hasbullet = (inst.components.inventory and inst.components.inventory:Has("musket_bullet", 1 ) or inst.components.inventory:Has("musket_silverbullet", 1)) or equip:HasTag("crossbow")
		
		inst.components.locomotor:Stop()
		inst.sg.statemem.action = inst.bufferedaction
		
		global_finishedarming = false
		
		local cooldown = 130 * FRAMES
			
		if equip:HasTag("zupalexsrangedweapons") and (equip:HasTag("crossbow") or equip:HasTag("musket")) and not equip:HasTag("readytoshoot") then
			global_xbowisarmed = false
		else
			global_xbowisarmed = true
		end
			
		global_conditions_fulfilled = false	
		if not global_xbowisarmed and global_hasbullet then
			global_conditions_fulfilled = true
		end
		
--		print("Conditions status is : ", global_havequiver, "   ", global_havearrow, "   ", global_targetisok, "   ", global_projtypeok, "   => ", global_conditions_fulfilled)
		
		local playerposx, playerposy, playerposz = inst.Transform:GetWorldPosition()
		inst:ForceFacePoint(playerposx, playerposy-50, playerposz)
		
		if not global_conditions_fulfilled then
			inst.AnimState:PlayAnimation("idle", true)
		else	
			if global_weapname == "crossbow" then
				inst.AnimState:PlayAnimation("crossbow_arm")
			elseif global_weapname == "musket" then
				inst.AnimState:PlayAnimation("musket_reload")	
				inst.AnimState:OverrideSymbol("swap_mloader", "swap_mloader", "swap_mloader")
			end

			if wornhat ~= nil then
				inst.AnimState:Hide("timeline_3")
			else
				inst.AnimState:Hide("timeline_16")
			end
        end
		
		inst.sg:SetTimeout(cooldown)
    end,

    timeline =
    {	
		TimeEvent(0 * FRAMES, function(inst)
									if not global_conditions_fulfilled then
										inst:ClearBufferedAction()
									end
								end),
	
		TimeEvent(15 * FRAMES, function(inst)
									inst.sg:RemoveStateTag("busy")
									if not global_conditions_fulfilled then
										inst.AnimState:PlayAnimation("idle")
									end
								end),
	
		TimeEvent(31 * FRAMES, function(inst)
									if global_conditions_fulfilled and global_weapname == "crossbow" then
										inst.SoundEmitter:PlaySound("bow_shoot/bow_shoot/bow_draw", nil, nil, true)
										inst.AnimState:OverrideSymbol("swap_object", "swap_crossbow", "swap_crossbow_armed")
									end
								end),	
	
		TimeEvent(62 * FRAMES, function(inst)
									if global_conditions_fulfilled and global_weapname == "crossbow" then
										inst:PerformBufferedAction()
										global_finishedarming = true
									end
								end),

		TimeEvent(63 * FRAMES, function(inst)
									if global_conditions_fulfilled and global_weapname == "musket" then
										inst.SoundEmitter:PlaySound("bow_shoot/musket/reload", nil, nil, true)
									end
								end),	
								
		TimeEvent(103 * FRAMES, function(inst)
									if global_conditions_fulfilled and global_weapname == "musket" then
										inst:PerformBufferedAction()
										global_finishedarming = true
									end
								end),
    },

    ontimeout = function(inst)
		inst.AnimState:OverrideSymbol("swap_object", "swap_crossbow", "swap_crossbow")
		owner.AnimState:ClearOverrideSymbol("swap_mloader")
        inst.sg:GoToState("idle", true)
    end,

    events =
    {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
		inst.AnimState:ClearOverrideSymbol("swap_mloader")
		if inst.bufferedaction == inst.sg.statemem.action then
            inst:ClearBufferedAction()
        end
        inst.sg.statemem.action = nil
	
		if global_weapname == "crossbow" and not global_finishedarming and not global_xbowisarmed then
			inst.AnimState:OverrideSymbol("swap_object", "swap_crossbow", "swap_crossbow")
		end
	
		if inst.components.talker then
			if not global_hasbullet then
				local nobullet_message = "I do not have anything to put in..."
				inst.components.talker:Say(nobullet_message)	
			elseif global_xbowisarmed and global_weapname == "crossbow" then
				local alreadyarmed_message = "If I pull even more on this stuff it will break..."
				inst.components.talker:Say(alreadyarmed_message)
			elseif global_xbowisarmed and global_weapname == "musket" then
				local alreadyarmed_message = "It is probably not a good idea to pile it up..."
				inst.components.talker:Say(alreadyarmed_message)
			end
		end
		
		inst.AnimState:Show("timeline_0")
		inst.AnimState:Show("timeline_3")
		inst.AnimState:Show("timeline_15")
		inst.AnimState:Show("timeline_16")
    end,		
})

crossbow_attack_client = State({
        name = "crossbow",
        tags = { "attack", "notalking", "abouttoattack", "autopredict" },

    onenter = function(inst)
        local buffaction = inst:GetBufferedAction()
        local target = buffaction ~= nil and buffaction.target or nil
		local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local wornhat = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		local quiver = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
		local projinquiver = nil
		
		global_weapname = equip.prefab
		
        inst.components.locomotor:Stop()
        local cooldown = 50 * FRAMES
		
--		print("I am in the StateGraph for the client !")
		
		local ArrowsInInv
		
		if quiver ~= nil and quiver.replica.container ~= nil then
			global_havequiver = true
			projinquiver = quiver.replica.container:GetItemInSlot(1)
		else
			global_havequiver = false
		end
		
		global_projtypeok = false
		if projinquiver ~= nil then
			global_havearrow = true

			global_projtypeok = projinquiver:HasTag("bolt") and projinquiver:HasTag("zrw_valid")
		else
			global_havearrow = false
		end
		
		if equip:HasTag("zupalexsrangedweapons") and (equip:HasTag("crossbow") or equip:HasTag("musket")) and equip:HasTag("readytoshoot") then
			global_xbowisarmed = true
		else
			global_xbowisarmed = false
		end
		
		if target ~= nil and not (target:HasTag("wall") or target:HasTag("butterfly")) then
			global_targetisok = true
		else
			global_targetisok = false
		end
		
		if equip:HasTag("musket") then
			global_havequiver = true
			global_havearrow = true
			global_projtypeok = true
		end
		
		global_conditions_fulfilled = false	
		if global_havequiver and global_havearrow and global_targetisok and global_projtypeok and global_xbowisarmed then
			global_conditions_fulfilled = true
		end
		
--		print("Conditions status is : ", global_havequiver, "   ", global_havearrow, "   ", global_targetisok, "   ", global_projtypeok, "   => ", global_conditions_fulfilled)
		
		if not global_conditions_fulfilled then
			inst.AnimState:PlayAnimation("idle", true)
		end
		
	    if equip ~= nil and global_conditions_fulfilled then
		    inst.replica.combat:StartAttack()
		
			inst.AnimState:PlayAnimation("crossbow_attack")
			
			if wornhat ~= nil then
				if inst.AnimState:GetCurrentFacing() == GLOBAL.FACING_UP then
--					print("hat and face up")
					inst.AnimState:Hide("timeline_0")
				elseif inst.AnimState:GetCurrentFacing() == GLOBAL.FACING_DOWN then
--					print("hat and face down")
					inst.AnimState:Hide("timeline_3")
				else
--					print("hat and face side")
					inst.AnimState:Hide("timeline_3")
				end
			else
				if inst.AnimState:GetCurrentFacing() == GLOBAL.FACING_UP then
--					print("no hat and face up")
					inst.AnimState:Hide("timeline_15")
				elseif inst.AnimState:GetCurrentFacing() == GLOBAL.FACING_DOWN then
--					print("no hat and face down")
					inst.AnimState:Hide("timeline_16")
				else
--					print("no hat and face side")
					inst.AnimState:Hide("timeline_16")
				end
			end
        end

		inst.sg:SetTimeout(cooldown) 

        if target ~= nil and target:IsValid() then
            inst:FacePoint(target.Transform:GetWorldPosition())
            inst.sg.statemem.attacktarget = target
        end
		
		if buffaction ~= nil then
			inst:PerformPreviewBufferedAction()
		end
    end,

    timeline =
    {
		TimeEvent(0 * FRAMES, function(inst)
									if not global_conditions_fulfilled then
										inst.sg:RemoveStateTag("abouttoattack")
										inst:ClearBufferedAction()
									end
								end),
	
		TimeEvent(15 * FRAMES, function(inst)
									if not global_conditions_fulfilled then
										inst.AnimState:PlayAnimation("idle")
									end
								end),
	
		TimeEvent(18 * FRAMES, function(inst)
									if global_conditions_fulfilled then
										if global_weapname == "crossbow" then
											inst.SoundEmitter:PlaySound("bow_shoot/bow_shoot/bow_shoot", nil, nil, true)
										elseif global_weapname == "musket" then
											inst.SoundEmitter:PlaySound("bow_shoot/musket/shot", nil, nil, true)
										end
									end
								end),	
	
		TimeEvent(23 * FRAMES, function(inst)
									if global_conditions_fulfilled then
									inst:ClearBufferedAction()
									inst.sg:RemoveStateTag("abouttoattack")
									end
								end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
    end,

    events =
    {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
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
		
		if inst.components.talker then
			if not global_havequiver then
				local noquiver_message = "I should first get a quiver!"
				inst.components.talker:Say(noquiver_message)
			elseif not global_havearrow then
				local noammo_message = "My quiver is empty!"
				inst.components.talker:Say(noammo_message)
			elseif not global_projtypeok then
				local badammo_message = "This won't fit it my current weapon..."
				inst.components.talker:Say(badammo_message)
			elseif not global_xbowisarmed then
				local xbownotarmed_message = "I won't shoot far if I don't arm it first..."
				inst.components.talker:Say(xbownotarmed_message)
			elseif global_targetislimbo then
				local targetinlimbo_message = "It's too late now..."
				inst.components.talker:Say(targetinlimbo_message)
			elseif not global_targetisok then
				local fail_message = "There's no potential target on sight."
				inst.components.talker:Say(fail_message)
			end
		end
		
		inst.AnimState:Show("timeline_0")
		inst.AnimState:Show("timeline_3")
		inst.AnimState:Show("timeline_15")
		inst.AnimState:Show("timeline_16")
    end,		
})



crossbow_arm_client = State({
    name = "crossbow_arm",
    tags = { "doing", "busy" },

    onenter = function(inst)
		local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local wornhat = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		
		global_weapname = equip.prefab
		
		global_hasbullet = (inst.replica.inventory and inst.replica.inventory:Has("musket_bullet", 1 ) or inst.replica.inventory:Has("musket_silverbullet", 1)) or equip:HasTag("crossbow")
		
		inst.components.locomotor:Stop()
		inst.sg.statemem.action = inst.bufferedaction
		
		local cooldown = 130 * FRAMES
			
		global_finishedarming = false
			
		if equip:HasTag("zupalexsrangedweapons") and (equip:HasTag("crossbow") or equip:HasTag("musket")) and not equip:HasTag("readytoshoot") then
			global_xbowisarmed = false
		else
			global_xbowisarmed = true
		end
			
		global_conditions_fulfilled = false	
		if not global_xbowisarmed and global_hasbullet then
			global_conditions_fulfilled = true
		end
		
--		print("Conditions status is : ", global_havequiver, "   ", global_havearrow, "   ", global_targetisok, "   ", global_projtypeok, "   => ", global_conditions_fulfilled)
		
		local playerposx, playerposy, playerposz = inst.Transform:GetWorldPosition()
		inst:ForceFacePoint(playerposx, playerposy-50, playerposz)
		
		if not global_conditions_fulfilled then
			inst.AnimState:PlayAnimation("idle", true)
		else	
			if global_weapname == "crossbow" then
				inst.AnimState:PlayAnimation("crossbow_arm")
			elseif global_weapname == "musket" then
				inst.AnimState:PlayAnimation("musket_reload")
			end

			if wornhat ~= nil then
				inst.AnimState:Hide("timeline_3")
			else
				inst.AnimState:Hide("timeline_16")
			end
        end

		inst.sg:SetTimeout(cooldown)
		
		inst:PerformPreviewBufferedAction()
    end,

    timeline =
    {		
		TimeEvent(15 * FRAMES, function(inst)
									inst.sg:RemoveStateTag("busy")
									if not global_conditions_fulfilled then
										inst.AnimState:PlayAnimation("idle")
									end
								end),
	
		TimeEvent(31 * FRAMES, function(inst)
									if global_conditions_fulfilled and global_weapname == "crossbow" then
										inst.SoundEmitter:PlaySound("bow_shoot/bow_shoot/bow_draw", nil, nil, true)
										inst.AnimState:OverrideSymbol("swap_object", "swap_crossbow", "swap_crossbow_armed")
									end
								end),	
	
		TimeEvent(62 * FRAMES, function(inst)
									if global_conditions_fulfilled and global_weapname == "crossbow" then
										inst.sg:RemoveStateTag("busy")
										global_finishedarming = true
									end
								end),
								
		TimeEvent(63 * FRAMES, function(inst)
									if global_conditions_fulfilled and global_weapname == "musket" then
										inst.SoundEmitter:PlaySound("bow_shoot/musket/reload", nil, nil, true)
									end
								end),
								
		TimeEvent(103 * FRAMES, function(inst)
									if global_conditions_fulfilled and global_weapname == "musket" then
										inst.sg:RemoveStateTag("busy")
										global_finishedarming = true
									end
								end),
    },

    ontimeout = function(inst)
        inst:ClearBufferedAction()
		if global_weapnae == "crossbow" then
			inst.AnimState:OverrideSymbol("swap_object", "swap_crossbow", "swap_crossbow")
		end
        inst.sg:GoToState("idle", true)
    end,

    events =
    {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)	
		local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	
		if inst.components.talker then
			if not global_hasbullet then
				local nobullet_message = "I do not have anything to put in..."
				inst.components.talker:Say(alreadyarmed_message)				
			elseif global_xbowisarmed and global_weapname == "crossbow" then
				local alreadyarmed_message = "If I pull even more on this stuff it will break..."
				inst.components.talker:Say(alreadyarmed_message)
			elseif global_xbowisarmed and global_weapname == "musket" then
				local alreadyarmed_message = "It is probably not a good idea to pile it up..."
				inst.components.talker:Say(alreadyarmed_message)
			end
		end
		
		if global_weapname == "crossbow" and not global_finishedarming and not global_xbowisarmed then
			inst.AnimState:OverrideSymbol("swap_object", "swap_crossbow", "swap_crossbow")
		end
		
		inst.AnimState:Show("timeline_0")
		inst.AnimState:Show("timeline_3")
		inst.AnimState:Show("timeline_15")
		inst.AnimState:Show("timeline_16")
    end,		
})
