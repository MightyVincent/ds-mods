local debuglog = false

local function HandleCancelTrackJungle(classified, callback, force)
	HandleTrackTaskCanceling(classified.entity:GetParent(), "counter_monkey_bow_kills", "z_bow_skin_jungle", "countermonkeybowkillsdirty", callback, force)
end

local function TestRandomDrop(classified)
	math.randomseed(os.time())
	
	local draw = math.random()
	
	if draw < classified.counter_monkey_bow_kills:value()/100 then
		if debuglog then print("Successful draw for counter_monkey_bow_kills => " .. tostring(draw) .. " / required " .. classified.counter_monkey_bow_kills:value()/100) end
		return true
	end
	
	if debuglog then print("Failed draw for counter_monkey_bow_kills => " .. tostring(draw) .. " / required " .. classified.counter_monkey_bow_kills:value()/100) end
	return false
end

local function OnCounterMonkeyBowKillsDirty(classified)
	if debuglog then print("Received event dirty from task counter_monkey_bow_kills ( " .. tostring(classified.entity:GetParent()) .. " ) = " .. tostring(classified.counter_monkey_bow_kills:value())) end
	if TestRandomDrop(classified) then
		GrantSkin(classified.entity:GetParent(), ResolveMglStr("z_bow_skin_jungle", curr_encr))
		classified.counter_monkey_bow_kills:set_local(0)
		HandleCancelTrackJungle(classified, OnCounterMonkeyBowKillsDirty, true)
	end
end

local function TrackTask(player, data)
	local classified = player and player.player_classified
	if classified and classified.counter_monkey_bow_kills and data and data.victim and data.victim.prefab == "monkey" then
		classified.counter_monkey_bow_kills:set(classified.counter_monkey_bow_kills:value()+1)
		
		if GetIsHostPlayer(player) and TestRandomDrop(classified) then
			GrantSkin(player, ResolveMglStr("z_bow_skin_jungle", curr_encr))
			classified.counter_monkey_bow_kills:set_local(0)
			HandleCancelTrackJungle(player, OnCounterMonkeyBowKillsDirty, true)
		end
	elseif classified and classified.counter_monkey_bow_kills == nil then
		classified:RemoveEventCallback("killed", TrackTask, player)
	end
end

local function condfn(classified)
	classified.counter_monkey_bow_kills = GLOBAL.net_byte(classified.GUID, "am_counter_monkey_bow_kills", "countermonkeybowkillsdirty")
	
	if not GLOBAL.TheWorld.ismastersim then
		classified:ListenForEvent("countermonkeybowkillsdirty", OnCounterMonkeyBowKillsDirty)

		TryDoUntil(classified, CheckForReplicated, 0.1, 0, 5, function(classified)
			HandleCancelTrackJungle(classified, OnCounterMonkeyBowKillsDirty)
		end)
	
		return classified
	end
	
	SetupNewTrackTask(classified, "counter_monkey_bow_kills")
	
	TryDoUntil(classified, CheckForReplicated, 0.1, 0, 5, function(classified)
		if debuglog then print("Install the progress track for z_bow_skin_jungle ( " .. tostring(classified.entity:GetParent()) .. " )") end
		
		classified:ListenForEvent("killed", TrackTask, classified.entity:GetParent())
		classified:DoTaskInTime(1, function(classified) classified.counter_monkey_bow_kills:set_local(0) end)
		HandleCancelTrackJungle(classified, OnCounterMonkeyBowKillsDirty)
	end)
end

local function onsavefn(player, data)
	local classified = player and player.player_classified
	if classified and classified._am_tracktasks["counter_monkey_bow_kills"] and classified.counter_monkey_bow_kills ~= nil and classified.counter_monkey_bow_kills:value() > 0 then
		data.counter_monkey_bow_kills = classified.counter_monkey_bow_kills:value()
	end
end

local function onloadfn(player, data)
	if data.counter_monkey_bow_kills ~= nil then
		if debuglog then print("Waiting to restoring monkey kills for " .. tostring(player) .. " => " .. tostring(data.counter_monkey_bow_kills)) end
		player:DoTaskInTime(5, function(player)
			local classified = player and player.player_classified
			if classified and classified._am_tracktasks["counter_monkey_bow_kills"] and classified.counter_monkey_bow_kills then
				if debuglog then print("Restoring monkey kills") end
				classified.counter_monkey_bow_kills:set_local(data.counter_monkey_bow_kills)
			end
		end)
	end
end

return condfn, onsavefn, onloadfn