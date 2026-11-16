local CorePackages = game:GetService("CorePackages")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local SoundService = game:GetService("SoundService")

local CoreGui = game:GetService("CoreGui")
local modules = CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules")
local GetFFlagEnableSoundSessionTelemetry = require(modules.Flags.GetFFlagEnableSoundSessionTelemetry)
local GetFIntSoundSessionTelemetryThrottle = require(modules.Flags.GetFIntSoundSessionTelemetryThrottle)
local engineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")

local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)

local default = LoggingProtocol.default

local AggregatedData = require(modules.AggregatedData)
local PlayingSounds = require(modules.PlayingSounds)

local v = {
	eventName = "SoundSessionPlayback",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = GetFIntSoundSessionTelemetryThrottle(),
	lastUpdated = { 23, 13, 6 },
	description = " Aggregated session-end event of all music playback data ",
	links = "https://roblox.atlassian.net/wiki/spaces/MUS/pages/2065826132/Scaled+Analytics+Tech+Spec"
}

local v2 = {}

local v3 = AggregatedData.new()
local v4 = PlayingSounds.new(v3)

local function logSessionEvent()
	local v5 = {}
	local loopcounts = {}
	local playtimes = {}

	for k, v6 in pairs(v3) do
		table.insert(v5, k)
		table.insert(loopcounts, v6.loopcount)
		table.insert(playtimes, v6.playtime)
	end

	local v6 = {
		asset_ids = table.concat(v5, ","),
		loop_counts = table.concat(loopcounts, ","),
		playback_seconds = table.concat(playtimes, ","),
		placeid = tostring(game.PlaceId),
		sessionid = RbxAnalyticsService:GetSessionId(),
		universeid = tostring(game.GameId)
	}

	if engineFeature then
		v6.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	default:logRobloxTelemetryEvent(v, nil, v6)
end

local function aggregateEndSessionData()
	for k, sound in pairs(v4.sounds) do
		for k2, _ in pairs(sound.instances) do
			v4:removeSound(k, k2)
		end
	end

	logSessionEvent()
end

local function isAudible(object): boolean -- 2 equivalent calls inferred from this helper
	local masterVolume = UserGameSettings.MasterVolume
	local v5 = not object.SoundGroup and 1 or object.SoundGroup.Volume
	local volume = object.Volume

	local rollOffGain = object.RollOffGain

	return masterVolume * v5 * volume * rollOffGain > 0.01
end

local function onPlayed(instance) -- 3 equivalent calls inferred from this helper
	if GetFFlagEnableSoundSessionTelemetry() and isAudible(instance) then -- inferred equivalent call
		v4:addSound(instance.SoundId, instance:GetDebugId(10))
	end
end

local function onPaused(instance) -- 1 equivalent call inferred from this helper
	if GetFFlagEnableSoundSessionTelemetry() then
		v4:removeSound(instance.SoundId, instance:GetDebugId(10))
	end
end

local function onStopped(instance) -- 1 equivalent call inferred from this helper
	if GetFFlagEnableSoundSessionTelemetry() then
		v4:removeSound(instance.SoundId, instance:GetDebugId(10))
	end
end

local function onEnded(instance) -- 1 equivalent call inferred from this helper
	if GetFFlagEnableSoundSessionTelemetry() then
		v4:removeSound(instance.SoundId, instance:GetDebugId(10))
	end
end

local function onResumed(instance) -- 1 equivalent call inferred from this helper
	if GetFFlagEnableSoundSessionTelemetry() and isAudible(instance) then -- inferred equivalent call
		v4:addSound(instance.SoundId, instance:GetDebugId(10))
	end
end

local function onLooped(instance, _: number) -- 1 equivalent call inferred from this helper
	if GetFFlagEnableSoundSessionTelemetry() then
		v4:loopSound(instance.SoundId, instance:GetDebugId(10))
	end
end

local function unhookSoundEvents(instance)
	local v5 = v2[instance]

	if v5 ~= nil then
		for _, connection in v5 do
			connection:Disconnect()
		end
	end

	if GetFFlagEnableSoundSessionTelemetry() then
		v4:removeSound(instance.SoundId, instance:GetDebugId(10))
	end

	v2[instance] = nil
end

local function hookupSoundEvents(sound)
	if sound.Playing then
		onPlayed(sound) -- inferred equivalent call
	end

	v2[sound] = {
		sound.Played:Connect(function()
			if sound.TimeLength == 0 or not sound.IsLoaded then
				local loadedConnection = nil
				loadedConnection = sound.Loaded:Connect(function()
					onPlayed(sound) -- inferred equivalent call
					loadedConnection:Disconnect()
				end)
			else
				onPlayed(sound) -- inferred equivalent call
			end
		end),
		sound.Paused:Connect(function()
			onPaused(sound) -- inferred equivalent call
		end),
		sound.Stopped:Connect(function()
			onStopped(sound) -- inferred equivalent call
		end),
		sound.Ended:Connect(function()
			onEnded(sound) -- inferred equivalent call
		end),
		sound.Resumed:Connect(function()
			onResumed(sound) -- inferred equivalent call
		end),
		sound.DidLoop:Connect(function(_, _)
			onLooped(sound) -- inferred equivalent call
		end),
		(sound.AncestryChanged:Connect(function(instance, _)
			if instance:FindFirstAncestorOfClass("DataModel") == nil then
				unhookSoundEvents(sound)
			end
		end))
	}
end

if GetFFlagEnableSoundSessionTelemetry() then
	if game:GetEngineFeature("AudioInstanceAddedApiEnabled") then
		SoundService.AudioInstanceAdded:Connect(function(sound)
			if sound:IsA("Sound") and not v2[sound] then
				hookupSoundEvents(sound)
			end
		end)
	end

	game.Close:Connect(function()
		aggregateEndSessionData()
	end)
end
