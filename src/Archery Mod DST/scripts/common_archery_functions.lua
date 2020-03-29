ARCHERYFUNCS = {}

local function mywidgetsetup(container, prefab, data)
    local t = data
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
    end
end

local widgetprops =
{
    "numslots",
    "acceptsstacks",
    "issidewidget",
    "type",
    "widget",
    "itemtestfn",
}

function ARCHERYFUNCS.MyWidgetSetup(self, prefab, data)
	for i, v in ipairs(widgetprops) do
        removesetter(self, v)
    end

    mywidgetsetup(self, prefab, data)
    self.inst.replica.container:WidgetSetup(prefab, data)

    for i, v in ipairs(widgetprops) do
        makereadonly(self, v)
    end
end

function ARCHERYFUNCS.MyWidgetSetup_replica(self, prefab, data)
    mywidgetsetup(self, prefab, data)
    if self.classified ~= nil then
        self.classified:InitializeSlots(self:GetNumSlots())
    end
    if self.issidewidget then
        if self._onputininventory == nil then
            self._owner = nil
            self._ondropped = function(inst)
                if self._owner ~= nil then
                    local owner = self._owner
                    self._owner = nil
                    if owner.HUD ~= nil then
                        owner:PushEvent("refreshcrafting")
                    end
                end
            end
            self._onputininventory = function(inst, owner)
                self._ondropped(inst)
                self._owner = owner
                if owner ~= nil and owner.HUD ~= nil then
                    owner:PushEvent("refreshcrafting")
                end
            end
            self.inst:ListenForEvent("onputininventory", self._onputininventory)
            self.inst:ListenForEvent("ondropped", self._ondropped)
        end
    end
end

function ARCHERYFUNCS.CommonOnUnequip(inst, owner)		
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

function ARCHERYFUNCS.DoPostAttackTask(inst, attacker)
	local quiver = attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
	local equiphand = attacker.components.inventory and attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	
	if equiphand then
		if equiphand:HasTag("magic") and equiphand:HasTag("bow") then
			if equiphand.components.fueled ~= nil and not equiphand.components.fueled:IsEmpty() then
				equiphand.components.fueled:DoDelta(-1)
			end
		elseif equiphand:HasTag("musket") then
			if equiphand:HasTag("readytoshoot") then
				equiphand:RemoveTag("readytoshoot")
			end
		else	
			if quiver ~= nil and quiver.components.container ~= nil then
				local projinquiver = quiver.components.container:GetItemInSlot(1)
					if projinquiver ~= nil then
						if projinquiver.components.stackable.stacksize == 1 and attacker.components.inventory:Has(projinquiver.prefab, 1) then
							local projtotransfer = SpawnPrefab(projinquiver.prefab)
							local amounttotransfer = select(2, attacker.components.inventory:Has(projinquiver.prefab, 1))
							quiver.components.container:ConsumeByName(projinquiver.prefab,1)
							
							if amounttotransfer < projtotransfer.components.stackable.maxsize then
								projtotransfer.components.stackable:SetStackSize(amounttotransfer)
								attacker.components.inventory:ConsumeByName(projinquiver.prefab,amounttotransfer)
							else
								projtotransfer.components.stackable:SetStackSize(projtotransfer.components.stackable.maxsize)
								attacker.components.inventory:ConsumeByName(projinquiver.prefab,projtotransfer.components.stackable.maxsize)						
							end
							
							quiver.components.container:GiveItem(projtotransfer)
						else
							quiver.components.container:ConsumeByName(projinquiver.prefab,1)				
						end
					end
			end
		end
	end
	
	if equiphand and equiphand:HasTag("crossbow") and equiphand.components.zupalexsrangedweapons then
		-- print("I should disarm the Xbow")
		equiphand:RemoveTag("readytoshoot")
		attacker.AnimState:OverrideSymbol("swap_object", "swap_crossbow", "swap_crossbow")
	end
end

function ARCHERYFUNCS.onattack(inst, attacker, target)
    if target.components.sleeper and target.components.sleeper:IsAsleep() then
        target.components.sleeper:WakeUp()
    end

    if target.components.combat then
        target.components.combat:SuggestTarget(attacker)
    end
end

function ARCHERYFUNCS.AssignProjInQuiver(inst, owner)
	local quiver = owner.components.inventory and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
	
	if quiver then
		local projinquiver = quiver.components.container:GetItemInSlot(1)
		if projinquiver then
			inst.components.weapon:SetProjectile(projinquiver.prefab)
		end
	end
end

function ARCHERYFUNCS.OnFinished(inst)
	inst:Remove()
end

function ARCHERYFUNCS.onthrown_regular(inst, data)
    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
	
	if inst.Physics ~= nil and not inst:HasTag("nocollisionoverride") then
		inst.Physics:ClearCollisionMask()
		inst.Physics:CollidesWith(COLLISION.WORLD)
		if TUNING.COLLISIONSAREON then
			inst.Physics:CollidesWith(COLLISION.OBSTACLES)
		end
	end
	
	local bow = data.thrower
	if bow.components.finiteuses then bow.components.finiteuses:Use() end
	-- local attacker = FindEntity(inst, 1.8, nil, { "player" })
	local attacker = bow.components.inventoryitem:GetGrandOwner()
	-- print("[DST Archery Mod] Check for the attacker -> ", attacker or "NOT FOUND!")
	
	if attacker then 
		inst.components.projectile.owner = attacker 
		
		local weap = attacker.components.inventory and attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		
		-- print("[DST Archery Mod] Check for weapon -> ", weap)
		
		if weap and weap.components.zupalexsrangedweapons then
			weap.components.weapon:onattack(attacker, inst.components.projectile.target)
		end
		
		ARCHERYFUNCS.DoPostAttackTask(inst, attacker)	
	end
end

function ARCHERYFUNCS.onpickup(inst)
	if inst.prefab == "moonstonearrow" then	
		inst.Light:Enable(false)
	end
end

function ARCHERYFUNCS.onputininventory(inst, owner)
	local activeitem = nil
	local quiver = nil
	local projinquiver = nil
	
	if owner.components.inventory ~= nil then
		inst:DoTaskInTime(0, function () 
								activeitem = owner.components.inventory:GetActiveItem()
								quiver = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.QUIVER)
--								print("Active item is : ", activeitem or "UNAVAILABLE", "  / Quiver is : ", quiver or "UNAVAILABLE")
								
								if inst ~= activeitem and quiver ~= nil then
									projinquiver = quiver.replica.container:GetItemInSlot(1)
--									print("Player ", inst.components.inventoryitem.owner, " put ", inst, " in its inventory (owner = ", owner, ")")
--									print("Quiver has : ", projinquiver or "EMPTY")
									if projinquiver == nil then
										local projtostore = SpawnPrefab(string.lower(inst.prefab))
										projtostore.components.stackable:SetStackSize(inst.components.stackable.stacksize)
										quiver.components.container:GiveItem(projtostore, 1)
										inst:Remove()
									elseif projinquiver.prefab == inst.prefab and not projinquiver.components.stackable:IsFull() then
										local currentactivestack = inst.components.stackable.stacksize
										local currentstackinquiver = projinquiver.components.stackable.stacksize
										local stackoverflow = currentactivestack - projinquiver.components.stackable:RoomLeft()			
										
										if stackoverflow <= 0 then
											projinquiver.components.stackable:SetStackSize(currentactivestack + currentstackinquiver)
											inst:Remove()
										else
											projinquiver.components.stackable:SetStackSize(projinquiver.components.stackable.maxsize)
											local projtostore = SpawnPrefab(string.lower(inst.prefab))
											projtostore.components.stackable:SetStackSize(stackoverflow)
											owner:DoTaskInTime(0, function() owner.components.inventory:GiveItem(projtostore) end)
											inst:Remove()
										end
									end								
								end
							end)
	end
end

function ARCHERYFUNCS.onmissarrow_regular(inst, attacker, target)
	local RecChanceBonus = 0
	local zupaproj = inst.components.zupalexsrangedweapons
	
	if attacker and attacker:HasTag("improvedsight") then
		RecChanceBonus = TUNING.VITAMINRRECMOD
	end
	
	local RecChance = zupaproj and zupaproj:GetRecChance(false) + RecChanceBonus
	
	if math.random() <= RecChance and inst:HasTag("recoverable") then
		local currentweaponbaseproj = zupaproj and zupaproj:GetBasicAmmo()
--		print("currentprojbasic in super miss = ", currentprojbasicammo)
		local recoveredarrow = currentweaponbaseproj and SpawnPrefab(currentweaponbaseproj)
		if recoveredarrow then
			recoveredarrow.Transform:SetPosition(inst.Transform:GetWorldPosition())
		end
	end

	inst:Remove()
end

function ARCHERYFUNCS.HITorMISSHandler(inst, attacker, target, DamageToApply, canmiss, canrecover)
	local misschancesmall, misschancebig = inst.components.zupalexsrangedweapons:GetMissChance()
	
	local misschance
	local RecChance
	local RecChanceBonus = 0
	
	local ignoreattack = false
	
	if TUNING.HITCHANCEFLYINGBIRDS and target:HasTag("bird") and target.sg and target.sg:HasStateTag("flying") then
		misschance = 0.995
		ignoreattack = true
	elseif TUNING.HITCHANCEBUGS and target.prefab == "bee" or target.prefab == "butterfly" then
		misschance = 0.99
	elseif canmiss then
		if target:HasTag("rabbit") or target:HasTag("bird") or target:HasTag("mole") or target:HasTag("butterfly") or target:HasTag("bee") or target:HasTag("frog") then 
			misschance = misschancesmall
		else
			misschance = misschancebig
		end
	else
		misschance = -1
	end
	
	local hitscore = math.random()
	
	if attacker:HasTag("improvedsight") then
		misschance = misschance * TUNING.VITAMINRACCMOD
		RecChanceBonus = TUNING.VITAMINRRECMOD
	end
	
--	print("hitscore = ", hitscore)
--	print("miss chance = ", misschance)
	
	if not target:IsInLimbo() then
		if hitscore <= misschance then	
			if attacker ~= nil and attacker.components and attacker.components.talker then
				local miss_message = "I should aim better next time!"
				attacker.components.talker:Say(miss_message)
			end
			
			if not ignoreattack then
				target:PushEvent("attacked", {attacker = attacker, damage = 0.1})
			end
			
			if attacker and inst.prefab == "explosivebolt" and inst.components.zupalexsrangedweapons.specificOnHit then
				inst.components.zupalexsrangedweapons.specificOnHit(inst, attacker, target)
			end
			
			if canrecover and inst:HasTag("recoverable") then
				RecChance = inst.components.zupalexsrangedweapons:GetRecChance(false) + RecChanceBonus
--				print("rec chance = ", RecChance)
				
				if math.random() <= RecChance then
					local rdmshift = Vector3(math.random(-1, 0)+math.random(), math.random(-1, 0)+math.random(), math.random(-1, 0)+math.random())
					local targposx, targposy, targposz = target.Transform:GetWorldPosition()
					local currentprojbasicammo = inst.components.zupalexsrangedweapons:GetBasicAmmo()
		--			print("currentprojbasic in miss = ", currentprojbasicammo)
					local recoveredarrow = SpawnPrefab(currentprojbasicammo)
					recoveredarrow.Transform:SetPosition((targposx + rdmshift.x), (targposy + rdmshift.y), (targposz + rdmshift.z))
				end		
			end
		else	
			if target:HasTag("player") then
				if (1-hitscore) <= TUNING.CRITCHANCEPVP then
	--				print("Score a critical against a Player!")
					DamageToApply = DamageToApply*TUNING.CRITDMGMODPVP
				end
			else
				if (1-hitscore) <= TUNING.CRITCHANCEPVE then
	--				print("Score a critical against a Mob!")
					DamageToApply = DamageToApply*TUNING.CRITDMGMODPVE
				end
			end
				
--			print("Damage To Apply = ", DamageToApply)	
				
			target.components.combat:GetAttacked(attacker, DamageToApply)
			
			if attacker and inst.components.zupalexsrangedweapons.specificOnHit then
				inst.components.zupalexsrangedweapons.specificOnHit(inst, attacker, target)
			end
			
			if canrecover and inst:HasTag("recoverable") then
				RecChance = inst.components.zupalexsrangedweapons:GetRecChance(true) + RecChanceBonus		
--				print("rec chance = ", RecChance)
				
				if math.random() <= RecChance then
					if target.arrowtorecover == nil then
						target.arrowtorecover = {}
						target.arrowtorecover[inst.prefab] = 1
					elseif target.arrowtorecover ~= nil and target.arrowtorecover[inst.prefab] == nil then
						target.arrowtorecover[inst.prefab] = 1
					else
						target.arrowtorecover[inst.prefab] = target.arrowtorecover[inst.prefab] + 1
					end
					
					for k, v in pairs(target.arrowtorecover) do
--						print(k, "  ->  ", v)
					end
--					print("****************************************")
					
					if target.RetrievePinnedArrows == nil then
						if target.components.health and target.components.health:IsDead() then
							local recoveredarrow = SpawnPrefab(inst.components.zupalexsrangedweapons:GetBasicAmmo())
							local rdmshift = Vector3(math.random(-1, 0)+math.random(), math.random(-1, 0)+math.random(), math.random(-1, 0)+math.random())
							local targposx, targposy, targposz = target.Transform:GetWorldPosition()
							recoveredarrow.Transform:SetPosition((targposx + rdmshift.x), (targposy + rdmshift.y), (targposz + rdmshift.z))
						else
							target.RetrievePinnedArrows = function()
															target:DoTaskInTime(0.5, function() 
																						if target.arrowtorecover ~= nil then
																							for k, v in pairs(target.arrowtorecover) do
																								local NbrOfStack = math.ceil(v/20)
																								local LastStackSize = v - (NbrOfStack-1)*20
																								
																								local StS = 1 -- Stack to Spawn
																								while StS <= NbrOfStack do
																									local pinnedarrow = SpawnPrefab(k)								
--																									print("Arrow to recover = ", pinnedarrow.components.zupalexsrangedweapons:GetBasicAmmo())
																									local recoveredarrow = SpawnPrefab(pinnedarrow.components.zupalexsrangedweapons:GetBasicAmmo())
																									pinnedarrow:Remove()
																									
																									if StS == NbrOfStack then
																										recoveredarrow.components.stackable:SetStackSize(LastStackSize)
																									else
																										recoveredarrow.components.stackable:SetStackSize(recoveredarrow.components.stackable.maxsize)
																									end
																									
																									local rdmshift = Vector3(math.random(-1, 0)+math.random(), math.random(-1, 0)+math.random(), math.random(-1, 0)+math.random())
																									local targposx, targposy, targposz = target.Transform:GetWorldPosition()
																									recoveredarrow.Transform:SetPosition((targposx + rdmshift.x), (targposy + rdmshift.y), (targposz + rdmshift.z))
																									StS = StS+1
																								end
																							end						
																							target.arrowtorecover = nil
																						end
																					end					
																				)
														end
							target:ListenForEvent("death", target.RetrievePinnedArrows)
						end
					end
				end	
			end
		end	
	elseif inst:HasTag("recoverable") and attacker then
		if not inst.components.zupalexsrangedweapons.specificOnMiss then
			ARCHERYFUNCS.onmissarrow_regular(inst, attacker, inst)
		else
			inst.components.zupalexsrangedweapons.specificOnMiss(inst, atttacker, inst)
		end
	end
end

function ARCHERYFUNCS.CalcFinalDamage(inst, attacker, target, applydodelta)
	local BaseDamage = inst.components.zupalexsrangedweapons.basedmg
	local DmgModifier = 1.0
	local DmgMultiplier = (attacker.components.combat.damagemultiplier or 1) -- Damage multiplier of a specific character
	
	local AdditionnalDmgMultiplier =
		(inst.components.zupalexsrangedweapons.stimuli == "electric" and
		not (target:HasTag("electricdamageimmune") or (target.components.inventory ~= nil and target.components.inventory:IsInsulated()))
		and TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT * (target.components.moisture ~= nil and target.components.moisture:GetMoisturePercent() or (target:GetIsWet() and 1 or 0)))
		or 0
	
	if attacker ~= nil and attacker.components.sanity ~= nil then
		if inst.prefab == "lightarrow" then 
			if target:HasTag("shadowcreature") then
				DmgModifier = 1.6
				if applydodelta then attacker.components.sanity:DoDelta(5) end
			elseif not target:HasTag("hostile") then
				DmgModifier = 0.6
				if applydodelta then attacker.components.sanity:DoDelta(-10) end					
			end	
		elseif inst.prefab == "shadowarrow" then 
			if target:HasTag("shadowcreature")then
				DmgModifier = 0.2
				if applydodelta then attacker.components.sanity:DoDelta(-10) end
			else 
				if applydodelta then attacker.components.sanity:DoDelta(-2) end
			end
		elseif inst.prefab == "healingarrow" then 
			if target:HasTag("hostile")then
				if applydodelta then attacker.components.sanity:DoDelta(-15) end
			elseif target:HasTag("player")then
				if applydodelta then attacker.components.sanity:DoDelta(-5) end
			end
		end
	end
	
	return BaseDamage*(DmgModifier*DmgMultiplier + AdditionnalDmgMultiplier)
end

function ARCHERYFUNCS.onhitcommon(inst, attacker, target)	
	-- print("Final Damage = ", ARCHERYFUNCS.CalcFinalDamage(inst, attacker, target, false))

	if inst and attacker and target then	
		ARCHERYFUNCS.HITorMISSHandler(inst, attacker, target, ARCHERYFUNCS.CalcFinalDamage(inst, attacker, target, true), true, true)

		if target.components.health and not target.components.health:IsDead() and math.random() < 0.65 then
			if target:HasTag("bird") then
				TheWorld:DoTaskInTime(0.5, function() target.sg:GoToState("flyaway") end)
			elseif target.prefab == "rabbit" then
				TheWorld:DoTaskInTime(0.5, function() target:PushEvent("gohome") end)
			end
		end
	end
	
	if inst:IsValid() then
		inst:Remove()
	end
end

function ARCHERYFUNCS.oncollide(inst, other)
	local attacker = inst.components.projectile and inst.components.projectile.owner

	print("COLLISION! inst :", inst, "with :", other, "(attacker: ", attacker,")")
	
	if not attacker and inst:HasTag("recoverable") then
		local spawnlocx, spawnlocy, spawnlocz = inst.Transform:GetWorldPosition()
		local recoveredarrow = SpawnPrefab(inst.prefab)
		inst:Remove()
		recoveredarrow.Transform:SetPosition(spawnlocx+1, spawnlocy+1, spawnlocz+1)
		return
	end
	
	if attacker and inst:HasTag("explosive") and inst.specificOnHit then
		inst.specificOnHit(inst, attacker, other)
	end
	
	if not attacker and not inst:HasTag("recoverable") then
		inst:Remove()
		return		
	end
	
	if other.components.combat ~= nil and other:IsValid() and not other:IsInLimbo() and not other:HasTag("wall") then
		ARCHERYFUNCS.HITorMISSHandler(inst, attacker, other, ARCHERYFUNCS.CalcFinalDamage(inst, attacker, other, true), false, false)
		return
	elseif not (other:HasTag("campfire") or other:HasTag("watersource") or other:HasTag("sentry")) then
		if inst.components.zupalexsrangedweapons ~= nil and not inst:HasTag("explosive") then	
			if inst:HasTag("recoverable") then
				local inst_x, inst_y, inst_z = inst.Transform:GetWorldPosition()
				local obstacle_x, obstacle_y, obstacle_z = other.Transform:GetWorldPosition()
				local currentprojbasicammo = inst.components.zupalexsrangedweapons:GetBasicAmmo()
				local recoveredarrow = SpawnPrefab(currentprojbasicammo)
				recoveredarrow.Transform:SetPosition((2*inst_x-obstacle_x), (2*inst_y-obstacle_y), (2*inst_z-obstacle_z))
			end
		elseif inst.components.zupalexsrangedweapons ~= nil and inst:HasTag("explosive") then
			inst.components.zupalexsrangedweapons.specificOnHit(inst, attacker, other) -- in case something went wrong before...
		end
 
		if inst:IsValid() then
			inst:Remove()
		end		
	elseif other:HasTag("campfire") or other:HasTag("watersource") or other:HasTag("sentry") then
--		print("Low obstalce encountered")
		RemovePhysicsColliders(inst)
		inst.Physics:CollidesWith(COLLISION.WORLD)
		inst.Physics:CollidesWith(COLLISION.OBSTACLES)
	end
end

function ARCHERYFUNCS.startflickering(inst)
	if inst.flickering == nil then
		inst.flickering = inst:DoPeriodicTask(0.075, function(inst)
														inst.lightstate = inst.Light:IsEnabled()
														inst.Light:Enable(not inst.lightstate)
													end
											)
	end
end

function ARCHERYFUNCS.stopflickering(inst)
	if inst.flickering ~= nil then
		inst.flickering:Cancel()
		inst.flickering = nil
	end
end

----------------------------------------------- CTORFNS --------------------------------------------------------------------------

ARCHERYFUNCS.ctorfns = {}

ARCHERYFUNCS.ctorfns.addlight = function(inst, data)
	local light = inst.entity:AddLight()
	
	inst.Light:SetIntensity(data.intensity or 0.6)
	inst.Light:SetRadius(data.radius or 0.5)
	inst.Light:SetFalloff(data.falloff or 0.75)
	inst.Light:Enable(data.enabled ~= nil and data.enabled or false)
	inst.Light:SetColour((data.r or 0)/255, (data.g or 0)/255, (data.b or 0)/255)
end

ARCHERYFUNCS.ctorfns.emitlight = function(inst, data)
	inst.Light:Enable(true)
end

ARCHERYFUNCS.ctorfns.turnofflight = function(inst, data)
	inst.Light:Enable(false)
end

ARCHERYFUNCS.ctorfns.setondropped = function(inst, data)
	local component = data.component
	local fn = data.fn
	
	if component == nil or fn == nil then
		return
	end

	inst.components.component:SetOnDroppedFn(fn)
end

ARCHERYFUNCS.ctorfns.setonpickup = function(inst, data)
	local component = data.component
	local fn = data.fn
	
	if component == nil or fn == nil then
		return
	end

	inst.components.component:SetOnPickupFn(fn)
end

ARCHERYFUNCS.ctorfns.setprojdmg = function(inst, data)
	if data == nil or data.dmg == nil then
		return
	end	

	inst.components.zupalexsrangedweapons:SetBaseDamage(data.dmg)
end

ARCHERYFUNCS.ctorfns.setbaseproj = function(inst, data)
	local baseproj = (inst:HasTag("arrow") and "arrow_" or "bolt_")
	baseproj = baseproj .. (data.feather or inst.components.zupalexsrangedweapons.feather)
	baseproj = baseproj .. "_" .. (data.body or inst.components.zupalexsrangedweapons.body)
	baseproj = baseproj .. "_" .. (data.head or inst.components.zupalexsrangedweapons.head)
	
	if data.suffix ~= nil then
		baseproj = baseproj .. "_" .. data.suffix
	end

	inst.components.zupalexsrangedweapons.baseproj = baseproj
end

----------------------------------------------- SHOOTFNS --------------------------------------------------------------------------

ARCHERYFUNCS.shootfns = {}

ARCHERYFUNCS.shootfns.emitlight = function(inst, data)
	inst.Light:Enable(true)
end


----------------------------------------------- HITFNS --------------------------------------------------------------------------

ARCHERYFUNCS.hitfns = {}

ARCHERYFUNCS.hitfns.firefn = function(inst, attacker, target, data)
	target.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_impact_fire")
	
--	print("I am shooting a Fire Arrow")
	
	if target.components.burnable then
        target.components.burnable:Ignite(nil, attacker)
    end
    if target.components.freezable then
        target.components.freezable:Unfreeze()
    end
    if target.components.health then
        target.components.health:DoFireDamage((TUNING.BOWDMG*(TUNING.FIREARROWDMGMOD/2.0)), attacker)
    end
end

ARCHERYFUNCS.hitfns.icefn = function(inst, attacker, target, data)
--	print("I am shooting an Ice Arrow")
   
    if target.components.burnable then
        if target.components.burnable:IsBurning() then
            target.components.burnable:Extinguish()
        elseif target.components.burnable:IsSmoldering() then
            target.components.burnable:SmotherSmolder()
        end
    end

    if target.components.freezable then
        target.components.freezable:AddColdness(1)
        target.components.freezable:SpawnShatterFX()
    end
end

ARCHERYFUNCS.hitfns.thunderfn = function(inst, attacker, target, data)
	if inst:AddTag("discharged") then
		return
	end

	local lightningstrike = SpawnPrefab("lightning")
	lightningstrike.Transform:SetPosition(target.Transform:GetWorldPosition())
	
	if not target:HasTag("stunned") then
		target:AddTag("stunned")
		
		if TheWorld.ismastersim and target.stuneffect == nil and target.components.health and not target.components.health:IsDead() then
			local symboltofollow = nil
			local symboltofollow_x = 0
			local symboltofollow_y = -100
			local symboltofollow_z = 0.02
		
			symboltofollow = target.components.combat.hiteffectsymbol
		
			if (symboltofollow == "marker" or symboltofollow == nil) and target.components.burnable then
				for k, v in pairs(target.components.burnable.fxdata) do
					if v.follow ~= nil then
						symboltofollow = v.follow
						symboltofollow_x = v.x
						symboltofollow_y = v.y - 190
						symboltofollow_z = v.z
					end
				end
			end
		
		
			if symboltofollow ~= nil and symboltofollow ~= "marker" then
				target.stuneffect = SpawnPrefab("stuneffect")
				target.stuneffect.Transform:SetPosition(target:GetPosition():Get())
				target.stuneffect:SetFollowTarget(target, symboltofollow, symboltofollow_x, symboltofollow_y, symboltofollow_z)
				target:ListenForEvent("death", function()
													if target.stuneffect ~= nil then
														target.stuneffect:SetFollowTarget(nil)
														target.stuneffect = nil
													end
												end
									)	
			end
		end
		
		if target.components.locomotor then
			target.preventmoving = target:DoPeriodicTask(0, function(target) target.components.locomotor:Stop() end)
			target.electricstun = target:DoPeriodicTask(4, function(target) 
																	target:RemoveTag("stunned")
																	
																	if TheWorld.ismastersim and target.stuneffect  ~= nil then
																		target.stuneffect:SetFollowTarget(nil)
																		target.stuneffect = nil
																	end
																	
																	if target.electricstun then
																		target.electricstun:Cancel()
																		target.electricstun = nil
																	end
																
																	if target.preventmoving then
																		target.preventmoving:Cancel()
																		target.preventmoving = nil
																	end
																end
															)															
		end
	end
	
	if TheWorld.state.israining then
		if math.random() <= 0.5 then
			if attacker.components.playerlightningtarget then
				attacker.components.playerlightningtarget:DoStrike()
				TheWorld:PushEvent("ms_sendlightningstrike", attacker:GetPosition())
			end
		end
	end
end

ARCHERYFUNCS.hitfns.healfn = function(inst, attacker, target, data)
	if target ~= nil then
		if target.components.health ~= nil and not target.components.health:IsDead() then
		target.components.health:DoDelta(25)
		end
		
		if target.components.sanity ~= nil then
			target.components.sanity:DoDelta(-5)
		end
	end
end

----------------------------------------------- MISSFNS --------------------------------------------------------------------------

ARCHERYFUNCS.missfns = {}