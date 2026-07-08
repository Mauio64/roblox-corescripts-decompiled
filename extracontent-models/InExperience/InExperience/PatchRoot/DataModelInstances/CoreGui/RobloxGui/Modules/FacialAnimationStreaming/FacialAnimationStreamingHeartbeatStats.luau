local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local FaceAnimatorService = game:GetService("FaceAnimatorService")
local GetFIntFacialAnimationStreamingHeartbeatStatsIntervalSec = require(RobloxGui.Modules.Flags.GetFIntFacialAnimationStreamingHeartbeatStatsIntervalSec)
local EngineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local AvatarChatHeartbeatStats = require(script.Parent.RobloxTelemetryConfigs.AvatarChatHeartbeatStats)
local t1 = {}
local u12 = false
local t2 = {
	None = 0,
	AudioOnly = 1,
	VideoOnly = 2,
	AudioVideo = 3
}
local None = t2.None
local t3 = {}
local u16 = nil
local t4 = {}
local _ = {
	VideoAnimationEnabled = "videoAnimationEnabled",
	AudioAnimationEnabled = "audioAnimationEnabled"
}

local function updateTrackingTimes() -- line: 41
	-- upvalues: u16 (ref), t3 (copy), None (ref)
	local elapsed = os.clock()

	if u16 then
		local v24 = elapsed - u16
		local v25 = t3
		local v26 = None

		v25[v26] = v25[v26] + v24
	end

	u16 = elapsed
end
local function reportHeartbeat() -- line: 52
	-- upvalues: RbxAnalyticsService (copy), Players (copy), EngineFeature (copy), None (ref), u16 (ref), t3 (copy), default (copy), AvatarChatHeartbeatStats (copy)
	local t5 = {
		pid = tostring(game.PlaceId),
		sessionid = RbxAnalyticsService:GetSessionId(),
		userid = tostring(Players.LocalPlayer.UserId),
		universeid = tostring(game.GameId)
	}

	if EngineFeature then
		t5.playSessionId = RbxAnalyticsService:GetPlaySessionId()
	end

	t5.trackingMode = None

	local elapsed = os.clock()

	if u16 then
		local v29 = elapsed - u16
		local v30 = t3
		local v31 = None

		v30[v31] = v30[v31] + v29
	end

	u16 = elapsed

	for v32, v33 in t3 do
		t5[tostring(v32)] = v33
		t3[v32] = 0
	end

	default:logRobloxTelemetryEvent(AvatarChatHeartbeatStats, nil, t5)
end
local function startHeartbeat() -- line: 76
	-- upvalues: GetFIntFacialAnimationStreamingHeartbeatStatsIntervalSec (copy), u12 (ref), reportHeartbeat (copy)
	local v34 = GetFIntFacialAnimationStreamingHeartbeatStatsIntervalSec()

	if v34 > 0 and not u12 then
		u12 = true
		task.spawn(function() -- line: 80
			-- upvalues: u12 (ref), reportHeartbeat (copy), v34 (copy)
			while u12 do
				reportHeartbeat()
				task.wait(v34)
			end

			u12 = false
		end)
	end
end
local function updateTrackingMode() -- line: 90
	-- upvalues: u16 (ref), t3 (copy), None (ref), FaceAnimatorService (copy), t2 (copy)
	local elapsed = os.clock()

	if u16 then
		local v36 = elapsed - u16
		local v37 = t3
		local v38 = None

		v37[v38] = v37[v38] + v36
	end

	u16 = elapsed

	if FaceAnimatorService.VideoAnimationEnabled and FaceAnimatorService.AudioAnimationEnabled then
		None = t2.AudioVideo

		return
	end

	if FaceAnimatorService.VideoAnimationEnabled then
		None = t2.VideoOnly

		return
	end

	if FaceAnimatorService.AudioAnimationEnabled then
		None = t2.AudioOnly

		return
	end

	None = t2.None
end

function t1.Initialize() -- line: 104
	-- upvalues: GetFIntFacialAnimationStreamingHeartbeatStatsIntervalSec (copy), t2 (copy), t3 (copy), t4 (copy), FaceAnimatorService (copy), u16 (ref), None (ref), u12 (ref), reportHeartbeat (copy)
	if GetFIntFacialAnimationStreamingHeartbeatStatsIntervalSec() <= 0 then
		return
	end

	for _, v40 in t2 do
		t3[v40] = 0
	end

	t4.videoAnimationEnabled = FaceAnimatorService:GetPropertyChangedSignal("VideoAnimationEnabled"):Connect(function() -- line: 113
		-- upvalues: u16 (ref), t3 (copy), None (ref), FaceAnimatorService (copy), t2 (copy)
		local elapsed = os.clock()

		if u16 then
			local v49 = elapsed - u16
			local v50 = t3
			local v51 = None

			v50[v51] = v50[v51] + v49
		end

		u16 = elapsed

		if FaceAnimatorService.VideoAnimationEnabled and FaceAnimatorService.AudioAnimationEnabled then
			None = t2.AudioVideo

			return
		end

		if FaceAnimatorService.VideoAnimationEnabled then
			None = t2.VideoOnly

			return
		end

		if FaceAnimatorService.AudioAnimationEnabled then
			None = t2.AudioOnly

			return
		end

		None = t2.None
	end)
	t4.audioAnimationEnabled = FaceAnimatorService:GetPropertyChangedSignal("AudioAnimationEnabled"):Connect(function() -- line: 117
		-- upvalues: u16 (ref), t3 (copy), None (ref), FaceAnimatorService (copy), t2 (copy)
		local elapsed = os.clock()

		if u16 then
			local v53 = elapsed - u16
			local v54 = t3
			local v55 = None

			v54[v55] = v54[v55] + v53
		end

		u16 = elapsed

		if FaceAnimatorService.VideoAnimationEnabled and FaceAnimatorService.AudioAnimationEnabled then
			None = t2.AudioVideo

			return
		end

		if FaceAnimatorService.VideoAnimationEnabled then
			None = t2.VideoOnly

			return
		end

		if FaceAnimatorService.AudioAnimationEnabled then
			None = t2.AudioOnly

			return
		end

		None = t2.None
	end)

	local elapsed = os.clock()

	if u16 then
		local v42 = elapsed - u16
		local v43 = t3
		local v44 = None

		v43[v44] = v43[v44] + v42
	end

	u16 = elapsed

	if FaceAnimatorService.VideoAnimationEnabled and FaceAnimatorService.AudioAnimationEnabled then
		None = t2.AudioVideo
	elseif FaceAnimatorService.VideoAnimationEnabled then
		None = t2.VideoOnly
	elseif FaceAnimatorService.AudioAnimationEnabled then
		None = t2.AudioOnly
	else
		None = t2.None
	end

	local v45 = GetFIntFacialAnimationStreamingHeartbeatStatsIntervalSec()

	if v45 > 0 and not u12 then
		u12 = true
		task.spawn(function() -- line: 80
			-- upvalues: u12 (ref), reportHeartbeat (copy), v45 (copy)
			while u12 do
				reportHeartbeat()
				task.wait(v45)
			end

			u12 = false
		end)
	end
end
function t1.Cleanup() -- line: 125
	-- upvalues: GetFIntFacialAnimationStreamingHeartbeatStatsIntervalSec (copy), t4 (copy), u12 (ref)
	if GetFIntFacialAnimationStreamingHeartbeatStatsIntervalSec() <= 0 then
		return
	end

	for _, v in pairs(t4) do
		if v then
			v:Disconnect()
		end
	end

	table.clear(t4)
	u12 = false
end

return t1
