local debuglog = false

local function HandleCancelTrackSpike(classified, callback, force)
	HandleTrackTaskCanceling(classified.entity:GetParent(), "counter_marsh_bow_kills", "z_bow_skin_spike", "countermarshbowkillsdirty", callback, force)
end

local reward_entities = {
	tentacle = true,
	merm = true,
	frog = true,
}

local function OnCounterMarshBowKillDirty(classified)
	if debuglog then print("Received event dirty from task counter_marsh_bow_kills ( " .. tostring(classified.entity:GetParent()) .. " ) = " .. tostring(classified.counter_marsh_bow_kills:value())) end

	if classified.counter_marsh_bow_kills:value() >= 30 then
		GrantSkin(classified.entity:GetParent(), ResolveMglStr("z_bow_skin_spike", curr_encr))
		classified.counter_marsh_bow_kills:set_local(0)
		HandleCancelTrackSpike(classified, OnCounterMarshBowKillDirty, true)
	end
end

local function TrackTask(player, data)
	local classified = player and player.player_classified
	if classified and player.components and player.components.inventory and classified.counter_marsh_bow_kills then
		local weapon = player.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
		if weapon and weapon:HasTag("bow") and weapon:HasTag("zupalexsrangedweapons") and data and data.victim and (reward_entities[data.victim.prefab] or data.victim:HasTag("player")) then
			if debuglog then print("Player " .. tostring(player) .. " killed a valid entity for the spike bow") end
			local x, y, z = player.Transform:GetWorldPosition()
			if GLOBAL.TheWorld.Map:GetTileAtPoint(x, 0, z) == GLOBAL.GROUND.MARSH then
				if debuglog then print("Player " .. tostring(player) .. " was standing on a marsh turf while performing this kill") end
				classified.counter_marsh_bow_kills:set(classified.counter_marsh_bow_kills:value()+(data.victim:HasTag("player") and 30 or 1))
				
				if GetIsHostPlayer(player) and classified.counter_marsh_bow_kills:value() >= 30 then
					GrantSkin(player, ResolveMglStr("z_bow_skin_spike", curr_encr))
					classified.counter_marsh_bow_kills:set_local(0)
					HandleCancelTrackSpike(player.player_classified, OnCounterMarshBowKillDirty, true)
				end
			end
		end
	elseif classified and classified.counter_marsh_bow_kills == nil then
		classified:RemoveEventCallback("killed", TrackTask, player)
	end
end

local function condfn(classified)	
	classified.counter_marsh_bow_kills = GLOBAL.net_smallbyte(classified.GUID, "am_counter_marsh_bow_kills", "countermarshbowkillsdirty")
	
	if not GLOBAL.TheWorld.ismastersim then
		classified:ListenForEvent("countermarshbowkillsdirty", OnCounterMarshBowKillDirty)
		
		TryDoUntil(classified, CheckForReplicated, 0.1, 0, 5, function(classified)
			HandleCancelTrackSpike(classified, OnCounterMarshBowKillDirty)
		end)
		
		return classified
	end
	
	SetupNewTrackTask(classified, "counter_marsh_bow_kills")
	
	TryDoUntil(classified, CheckForReplicated, 0.1, 0, 5, function(classified)
		if debuglog then print("Install the progress track for z_bow_skin_spike ( " .. tostring(classified.entity:GetParent()) .. " )") end
		
		classified:ListenForEvent("killed", TrackTask, classified.entity:GetParent())
		classified:DoTaskInTime(1, function(classified) classified.counter_marsh_bow_kills:set_local(0) end)
		HandleCancelTrackSpike(classified, OnCounterMarshBowKillDirty)
	end)
end

local function onsavefn(player, data)
	local classified = player and player.player_classified
	if classified and classified._am_tracktasks["counter_marsh_bow_kills"] and classified.counter_marsh_bow_kills ~= nil and classified.counter_marsh_bow_kills:value() > 0 then
		data.counter_marsh_bow_kills = classified.counter_marsh_bow_kills:value()
	end
end

local function onloadfn(player, data)
	if data and data.counter_marsh_bow_kills ~= nil then
		if debuglog then print("Waiting to restoring marsh kills for " .. tostring(player) .. " => " .. tostring(data.counter_marsh_bow_kills)) end
		player:DoTaskInTime(5, function(player) 
			local classified = player.player_classified
			if classified and classified._am_tracktasks["counter_marsh_bow_kills"] and classified.counter_marsh_bow_kills then
				if debuglog then print("Restoring marsh kills") end
				classified.counter_marsh_bow_kills:set(data.counter_marsh_bow_kills)
			end
		end)
	end
end

return condfn, onsavefn, onloadfn