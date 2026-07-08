local CorePackages = game:GetService("CorePackages")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local SoundService = game:GetService("SoundService")
local Modules = game:GetService("CoreGui"):WaitForChild("RobloxGui"):WaitForChild("Modules")
local GetFFlagEnableSoundSessionTelemetry = require(Modules.Flags.GetFFlagEnableSoundSessionTelemetry)
local GetFIntSoundSessionTelemetryThrottle = require(Modules.Flags.GetFIntSoundSessionTelemetryThrottle)
local EngineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local default = LoggingProtocol.default
local AggregatedData = require(Modules.AggregatedData)
local PlayingSounds = require(Modules.PlayingSounds)
local t1 = {
	eventName = "SoundSessionPlayback",
	description = " Aggregated session-end event of all music playback data ",
	links = "https://roblox.atlassian.net/wiki/spaces/MUS/pages/2065826132/Scaled+Analytics+Tech+Spec",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = GetFIntSoundSessionTelemetryThrottle(),
	lastUpdated = {
		23,
		13,
		6
	}
}
local t2 = {}
local v15 = AggregatedData.new()
local v16 = PlayingSounds.new(v15)

local function logSessionEvent() -- line: 39
	-- upvalues: v15 (copy), RbxAnalyticsService (copy), EngineFeature (copy), default (copy), t1 (copy)
	local t3 = {}
	local t4 = {}
	local t5 = {}

	for k, v in pairs(v15) do
		table.insert(t3, k)
		table.insert(t4, v.loopcount)
		table.insert(t5, v.playtime)
	end

	local t6 = {
		asset_ids = table.concat(t3, ","),
		loop_counts = table.concat(t4, ","),
		playback_seconds = table.concat(t5, ","),
		placeid = tostring(game.PlaceId),
		sessionid = RbxAnalyticsService:GetSessionId(),
		universeid = tostring(game.GameId)
	}

	if EngineFeature then
		t6.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	default:logRobloxTelemetryEvent(t1, nil, t6)
end
local function aggregateEndSessionData() -- line: 67
	-- upvalues: v16 (copy), logSessionEvent (copy)
	for k, v in pairs(v16.sounds) do
		for k2, _ in pairs(v.instances) do
			v16:removeSound(k, k2)
		end
	end

	logSessionEvent()
end
local function isAudible(p1) -- line: 79
	-- upvalues: UserGameSettings (copy)
	local MasterVolume = UserGameSettings.MasterVolume
	local v40 = not p1.SoundGroup and 1 or p1.SoundGroup.Volume
	local p1Volume = p1.Volume
	local RollOffGain = p1.RollOffGain

	return MasterVolume * v40 * p1Volume * RollOffGain > 0.01
end
local function onPlayed(p2) -- line: 91
	-- upvalues: GetFFlagEnableSoundSessionTelemetry (copy), UserGameSettings (copy), v16 (copy)
	if GetFFlagEnableSoundSessionTelemetry() then
		local MasterVolume = UserGameSettings.MasterVolume
		local v45 = not p2.SoundGroup and 1 or p2.SoundGroup.Volume
		local p2Volume = p2.Volume
		local RollOffGain = p2.RollOffGain

		if MasterVolume * v45 * p2Volume * RollOffGain > 0.01 then
			v16:addSound(p2.SoundId, p2:GetDebugId(10))
		end
	end
end
local function onPaused(p3) -- line: 97
	-- upvalues: GetFFlagEnableSoundSessionTelemetry (copy), v16 (copy)
	if GetFFlagEnableSoundSessionTelemetry() then
		v16:removeSound(p3.SoundId, p3:GetDebugId(10))
	end
end
local function onStopped(p4) -- line: 103
	-- upvalues: GetFFlagEnableSoundSessionTelemetry (copy), v16 (copy)
	if GetFFlagEnableSoundSessionTelemetry() then
		v16:removeSound(p4.SoundId, p4:GetDebugId(10))
	end
end
local function onEnded(p5) -- line: 109
	-- upvalues: GetFFlagEnableSoundSessionTelemetry (copy), v16 (copy)
	if GetFFlagEnableSoundSessionTelemetry() then
		v16:removeSound(p5.SoundId, p5:GetDebugId(10))
	end
end
local function onResumed(p6) -- line: 115
	-- upvalues: GetFFlagEnableSoundSessionTelemetry (copy), UserGameSettings (copy), v16 (copy)
	if GetFFlagEnableSoundSessionTelemetry() then
		local MasterVolume = UserGameSettings.MasterVolume
		local v53 = not p6.SoundGroup and 1 or p6.SoundGroup.Volume
		local p6Volume = p6.Volume
		local RollOffGain = p6.RollOffGain

		if MasterVolume * v53 * p6Volume * RollOffGain > 0.01 then
			v16:addSound(p6.SoundId, p6:GetDebugId(10))
		end
	end
end
local function onLooped(p7, _: number) -- line: 121
	-- upvalues: GetFFlagEnableSoundSessionTelemetry (copy), v16 (copy)
	if GetFFlagEnableSoundSessionTelemetry() then
		v16:loopSound(p7.SoundId, p7:GetDebugId(10))
	end
end
local function unhookSoundEvents(p8) -- line: 127
	-- upvalues: t2 (copy), GetFFlagEnableSoundSessionTelemetry (copy), v16 (copy)
	local v59 = t2[p8]

	if v59 ~= nil then
		for _, v61 in v59 do
			v61:Disconnect()
		end
	end

	if GetFFlagEnableSoundSessionTelemetry() then
		v16:removeSound(p8.SoundId, p8:GetDebugId(10))
	end

	t2[p8] = nil
end
local function hookupSoundEvents(p9) -- line: 140
	-- upvalues: GetFFlagEnableSoundSessionTelemetry (copy), UserGameSettings (copy), v16 (copy), unhookSoundEvents (copy), t2 (copy)
	if p9.Playing and GetFFlagEnableSoundSessionTelemetry() then
		local MasterVolume = UserGameSettings.MasterVolume
		local v64 = not p9.SoundGroup and 1 or p9.SoundGroup.Volume
		local p9Volume = p9.Volume
		local RollOffGain = p9.RollOffGain

		if MasterVolume * v64 * p9Volume * RollOffGain > 0.01 then
			v16:addSound(p9.SoundId, p9:GetDebugId(10))
		end
	end

	t2[p9] = {
		p9.Played:Connect(function() -- line: 146
			-- upvalues: p9 (copy), GetFFlagEnableSoundSessionTelemetry (copy), UserGameSettings (copy), v16 (copy)
			if p9.TimeLength == 0 or not p9.IsLoaded then
				local connection = nil

				connection = p9.Loaded:Connect(function() -- line: 150
					-- upvalues: p9 (copy), GetFFlagEnableSoundSessionTelemetry (copy), UserGameSettings (copy), v16 (copy), connection (ref)
					local v87 = p9

					if GetFFlagEnableSoundSessionTelemetry() then
						local MasterVolume = UserGameSettings.MasterVolume
						local v89 = not v87.SoundGroup and 1 or v87.SoundGroup.Volume
						local Volume = v87.Volume
						local RollOffGain = v87.RollOffGain

						if MasterVolume * v89 * Volume * RollOffGain > 0.01 then
							v16:addSound(v87.SoundId, v87:GetDebugId(10))
						end
					end

					connection:Disconnect()
				end)

				return
			end

			local v69 = p9

			if GetFFlagEnableSoundSessionTelemetry() then
				local MasterVolume = UserGameSettings.MasterVolume
				local v71 = not v69.SoundGroup and 1 or v69.SoundGroup.Volume
				local Volume = v69.Volume
				local RollOffGain = v69.RollOffGain

				if MasterVolume * v71 * Volume * RollOffGain > 0.01 then
					v16:addSound(v69.SoundId, v69:GetDebugId(10))
				end
			end
		end),
		p9.Paused:Connect(function() -- line: 159
			-- upvalues: p9 (copy), GetFFlagEnableSoundSessionTelemetry (copy), v16 (copy)
			local v74 = p9

			if GetFFlagEnableSoundSessionTelemetry() then
				v16:removeSound(v74.SoundId, v74:GetDebugId(10))
			end
		end),
		p9.Stopped:Connect(function() -- line: 163
			-- upvalues: p9 (copy), GetFFlagEnableSoundSessionTelemetry (copy), v16 (copy)
			local v75 = p9

			if GetFFlagEnableSoundSessionTelemetry() then
				v16:removeSound(v75.SoundId, v75:GetDebugId(10))
			end
		end),
		p9.Ended:Connect(function() -- line: 167
			-- upvalues: p9 (copy), GetFFlagEnableSoundSessionTelemetry (copy), v16 (copy)
			local v76 = p9

			if GetFFlagEnableSoundSessionTelemetry() then
				v16:removeSound(v76.SoundId, v76:GetDebugId(10))
			end
		end),
		p9.Resumed:Connect(function() -- line: 171
			-- upvalues: p9 (copy), GetFFlagEnableSoundSessionTelemetry (copy), UserGameSettings (copy), v16 (copy)
			local v77 = p9

			if GetFFlagEnableSoundSessionTelemetry() then
				local MasterVolume = UserGameSettings.MasterVolume
				local v79 = not v77.SoundGroup and 1 or v77.SoundGroup.Volume
				local Volume = v77.Volume
				local RollOffGain = v77.RollOffGain

				if MasterVolume * v79 * Volume * RollOffGain > 0.01 then
					v16:addSound(v77.SoundId, v77:GetDebugId(10))
				end
			end
		end),
		p9.DidLoop:Connect(function(_, _) -- line: 175
			-- upvalues: p9 (copy), GetFFlagEnableSoundSessionTelemetry (copy), v16 (copy)
			local v84 = p9

			if GetFFlagEnableSoundSessionTelemetry() then
				v16:loopSound(v84.SoundId, v84:GetDebugId(10))
			end
		end),
		(p9.AncestryChanged:Connect(function(child, _) -- line: 179
			-- upvalues: unhookSoundEvents (copy), p9 (copy)
			if child:FindFirstAncestorOfClass("DataModel") == nil then
				unhookSoundEvents(p9)
			end
		end))
	}
end

if GetFFlagEnableSoundSessionTelemetry() then
	if game:GetEngineFeature("AudioInstanceAddedApiEnabled") then
		SoundService.AudioInstanceAdded:Connect(function(p13) -- line: 192
			-- upvalues: t2 (copy), hookupSoundEvents (copy)
			if p13:IsA("Sound") and not t2[p13] then
				hookupSoundEvents(p13)
			end
		end)
	end

	game.Close:Connect(function() -- line: 201
		-- upvalues: aggregateEndSessionData (copy)
		aggregateEndSessionData()
	end)
end
