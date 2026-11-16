local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local default = LoggingProtocol.default

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local FaceAnimatorService = game:GetService("FaceAnimatorService")

local GetFIntFacialAnimationStreamingHeartbeatStatsIntervalSec = require(RobloxGui.Modules.Flags.GetFIntFacialAnimationStreamingHeartbeatStatsIntervalSec)

local engineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")

local AvatarChatHeartbeatStats = require(script.Parent.RobloxTelemetryConfigs.AvatarChatHeartbeatStats)

local flag = false

local v = { None = 0, AudioOnly = 1, VideoOnly = 2, AudioVideo = 3 }

local trackingMode = v.None
local v2 = {}
local v3 = nil

local v4 = {}

local _ = {
	VideoAnimationEnabled = "videoAnimationEnabled",
	AudioAnimationEnabled = "audioAnimationEnabled"
}

local function updateTrackingTimes() -- 2 equivalent calls inferred from this helper
	local now = os.clock()

	if v3 then
		local v5 = now - v3
		v2[trackingMode] += v5
	end

	v3 = now
end

local function reportHeartbeat()
	local v5 = {
		pid = tostring(game.PlaceId),
		sessionid = RbxAnalyticsService:GetSessionId(),
		userid = tostring(Players.LocalPlayer.UserId),
		universeid = tostring(game.GameId)
	}

	if engineFeature then
		v5.playSessionId = RbxAnalyticsService:GetPlaySessionId()
	end

	v5.trackingMode = trackingMode
	updateTrackingTimes() -- inferred equivalent call

	for k, v6 in v2 do
		v5[tostring(k)] = v6
		v2[k] = 0
	end

	default:logRobloxTelemetryEvent(AvatarChatHeartbeatStats, nil, v5)
end

local function startHeartbeat() -- 1 equivalent call inferred from this helper
	local fIntFacialAnimationStreamingHeartbeatStatsIntervalSec = GetFIntFacialAnimationStreamingHeartbeatStatsIntervalSec()

	if fIntFacialAnimationStreamingHeartbeatStatsIntervalSec > 0 and not flag then
		flag = true
		task.spawn(function()
			while flag do
				reportHeartbeat()
				task.wait(fIntFacialAnimationStreamingHeartbeatStatsIntervalSec)
			end

			flag = false
		end)
	end
end

local function updateTrackingMode() -- 1 equivalent call inferred from this helper
	updateTrackingTimes() -- inferred equivalent call

	if FaceAnimatorService.VideoAnimationEnabled and FaceAnimatorService.AudioAnimationEnabled then
		trackingMode = v.AudioVideo
	elseif FaceAnimatorService.VideoAnimationEnabled then
		trackingMode = v.VideoOnly
	elseif FaceAnimatorService.AudioAnimationEnabled then
		trackingMode = v.AudioOnly
	else
		trackingMode = v.None
	end
end

local FacialAnimationStreamingHeartbeatStats = {}

function FacialAnimationStreamingHeartbeatStats.Initialize()
	if GetFIntFacialAnimationStreamingHeartbeatStatsIntervalSec() <= 0 then
		return
	end

	for _, v5 in v do
		v2[v5] = 0
	end

	v4.videoAnimationEnabled = FaceAnimatorService:GetPropertyChangedSignal("VideoAnimationEnabled"):Connect(function()
		local now = os.clock()

		if v3 then
			local v5 = now - v3
			v2[trackingMode] += v5
		end

		v3 = now

		if FaceAnimatorService.VideoAnimationEnabled and FaceAnimatorService.AudioAnimationEnabled then
			trackingMode = v.AudioVideo
		elseif FaceAnimatorService.VideoAnimationEnabled then
			trackingMode = v.VideoOnly
		elseif FaceAnimatorService.AudioAnimationEnabled then
			trackingMode = v.AudioOnly
		else
			trackingMode = v.None
		end
	end)

	v4.audioAnimationEnabled = FaceAnimatorService:GetPropertyChangedSignal("AudioAnimationEnabled"):Connect(function()
		local now = os.clock()

		if v3 then
			local v5 = now - v3
			v2[trackingMode] += v5
		end

		v3 = now

		if FaceAnimatorService.VideoAnimationEnabled and FaceAnimatorService.AudioAnimationEnabled then
			trackingMode = v.AudioVideo
		elseif FaceAnimatorService.VideoAnimationEnabled then
			trackingMode = v.VideoOnly
		elseif FaceAnimatorService.AudioAnimationEnabled then
			trackingMode = v.AudioOnly
		else
			trackingMode = v.None
		end
	end)
	updateTrackingMode() -- inferred equivalent call
	startHeartbeat() -- inferred equivalent call
end

function FacialAnimationStreamingHeartbeatStats.Cleanup()
	if GetFIntFacialAnimationStreamingHeartbeatStatsIntervalSec() <= 0 then
		return
	end

	for _, connection in pairs(v4) do
		if connection then
			connection:Disconnect()
		end
	end

	table.clear(v4)

	flag = false
end

return FacialAnimationStreamingHeartbeatStats
