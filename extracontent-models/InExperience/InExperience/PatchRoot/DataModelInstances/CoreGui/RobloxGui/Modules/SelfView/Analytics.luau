function debugPrint(_) -- line: 4
end

debugPrint("Self View Analytics 10-19-2022__1")

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local t1 = {}

t1.__index = t1
t1.INFO = "info"
t1.WARNING = "warning"
t1.ERROR = "error"

local s1 = "SelfView"

function t1.new(t2: {[any]: any}?) -- line: 76
	-- upvalues: RbxAnalyticsService (copy), t1 (copy)
	if not t2 then
		t2 = RbxAnalyticsService
	end

	assert(t2, "Analytics impl must not be nil.")

	return (setmetatable({
		_impl = t2
	}, t1))
end

local function stub() -- line: 91
end

function t1.stubService() -- line: 93
	-- upvalues: stub (copy)
	return {
		SetRBXEvent = stub,
		SetRBXEventStream = stub,
		SendEventDeferred = stub,
		ReportCounter = stub,
		ReportStats = stub,
		ReportInfluxSeries = stub,
		GetSessionId = stub
	}
end
function t1.setImpl(p2, p3) -- line: 105
	p2._impl = p3
end
function t1._report(p4, p5, p6, _, p8) -- line: 109
	-- upvalues: RunService (copy)
	local s2 = "client"

	if RunService:IsStudio() then
		s2 = "studio"
	end

	p4._impl:SendEventDeferred(s2, p5, p6, p8)
end
function t1.reportMicState(p9, p10) -- line: 119
	-- upvalues: Players (copy), s1 (ref)
	debugPrint("Self View: Analytics:reportMicState, newState: " .. tostring(p10) .. ",universeid: " .. tostring(game.GameId) .. ",pid: " .. tostring(game.PlaceId) .. ",uid: " .. tostring(Players.LocalPlayer.UserId) .. ",sessionid: " .. tostring(p9._impl:GetSessionId()))
	p9:_report(s1, "inExperienceMicState", tostring(p10), {
		state = p10,
		universeid = tostring(game.GameId),
		pid = tostring(game.PlaceId),
		uid = tostring(Players.LocalPlayer.UserId),
		sessionid = tostring(p9._impl:GetPlaySessionId())
	})
end
function t1.reportCamState(p11, p12) -- line: 130
	-- upvalues: Players (copy), s1 (ref)
	debugPrint("Self View: Analytics:reporCamState, newState: " .. tostring(p12) .. ",universeid: " .. tostring(game.GameId) .. ",pid: " .. tostring(game.PlaceId) .. ",uid: " .. tostring(Players.LocalPlayer.UserId) .. ",sessionid: " .. tostring(p11._impl:GetSessionId()))
	p11:_report(s1, "inExperienceCamState", tostring(p12), {
		state = p12,
		universeid = tostring(game.GameId),
		pid = tostring(game.PlaceId),
		uid = tostring(Players.LocalPlayer.UserId),
		sessionid = tostring(p11._impl:GetPlaySessionId())
	})
end
function t1.reportSelfViewEnabledInCoreGuiState(p13, p14) -- line: 141
	debugPrint("Self View: Analytics:reportSelfViewEnabledInCoreGuiState, newState: " .. tostring(p14) .. ",universeid: " .. tostring(game.GameId) .. ",pid: " .. tostring(game.PlaceId) .. ",sessionid: " .. tostring(p13._impl:GetSessionId()))
	p13:_report("SelfView", "enabledinCoreGuiState", tostring(p14), {
		state = p14,
		universeid = tostring(game.GameId),
		pid = tostring(game.PlaceId),
		sessionid = tostring(p13._impl:GetPlaySessionId())
	})
end
function t1.reportSelfViewSessionStarted(p15, p16, p17, p18, p19, p20, p21, p22, p23) -- line: 151
	-- upvalues: RbxAnalyticsService (copy)
	debugPrint("Self View: Analytics:reportSelfViewSessionStarted,universeid: " .. tostring(game.GameId) .. ",pid: " .. tostring(game.PlaceId) .. ",sessionid: " .. tostring(p15._impl:GetSessionId()) .. ",x: " .. tostring(p16) .. ",y: " .. tostring(p17) .. ",width: " .. tostring(p18) .. ",height: " .. tostring(p19) .. ",x_relative: " .. tostring(p20) .. ",y_relative: " .. tostring(p21) .. ",width_relative: " .. tostring(p22) .. ",height_relative: " .. tostring(p23))
	p15:_report("SelfView", "sessionStarted", "true", {
		universeid = tostring(game.GameId),
		pid = tostring(game.PlaceId),
		sessionid = tostring(p15._impl:GetPlaySessionId()),
		x = tostring(p16),
		y = tostring(p17),
		width = tostring(p18),
		height = tostring(p19),
		x_relative = tostring(p20),
		y_relative = tostring(p21),
		width_relative = tostring(p22),
		height_relative = tostring(p23)
	})
	RbxAnalyticsService:AddGlobalPointsField("feature/avatarChat/selfViewOn", 1)
end
function t1.reportSelfViewSessionStopped(p24) -- line: 170
	-- upvalues: RbxAnalyticsService (copy)
	debugPrint("Self View: Analytics:reportSelfViewSessionStopped,universeid: " .. tostring(game.GameId) .. ",pid: " .. tostring(game.PlaceId) .. ",sessionid: " .. tostring(p24._impl:GetSessionId()))
	p24:_report("SelfView", "sessionStopped", "true", {
		universeid = tostring(game.GameId),
		pid = tostring(game.PlaceId),
		sessionid = tostring(p24._impl:GetPlaySessionId())
	})
	RbxAnalyticsService:AddGlobalPointsField("feature/avatarChat/selfViewOn", 0)
end
function t1.reportUserAccountSettings(t3: {[any]: any}, b1: boolean, b2: boolean) -- line: 181
	debugPrint("Self View: Analytics:reportUserAccountSettings,universeid: " .. tostring(game.GameId) .. ",pid: " .. tostring(game.PlaceId) .. ",sessionid: " .. tostring(t3._impl:GetSessionId()) .. ",userAccount_videoEnabled: " .. tostring(b1) .. ",userAccount_audioEnabled: " .. tostring(b2))
	t3:_report("SelfView", "userAccountSettings", "true", {
		universeid = tostring(game.GameId),
		pid = tostring(game.PlaceId),
		sessionid = tostring(t3._impl:GetPlaySessionId()),
		videoenabled = tostring(b1),
		audioenabled = tostring(b2)
	})
end
function t1.reportExperienceSettings(t4: {[any]: any}, b3: boolean, b4: boolean, b5: boolean) -- line: 192
	debugPrint("Self View: Analytics:reportExperienceSettings,universeid: " .. tostring(game.GameId) .. ",pid: " .. tostring(game.PlaceId) .. ",sessionid: " .. tostring(t4._impl:GetSessionId()) .. ",experienceSettings_placeEnabled: " .. tostring(b3) .. ",experienceSettings_videoEnabled: " .. tostring(b4) .. ",experienceSettings_audioEnabled: " .. tostring(b5))
	t4:_report("SelfView", "experienceSettings", "true", {
		universeid = tostring(game.GameId),
		pid = tostring(game.PlaceId),
		sessionid = tostring(t4._impl:GetPlaySessionId()),
		placeenabled = tostring(b3),
		videoenabled = tostring(b4),
		audioenabled = tostring(b5)
	})
end
function t1.setLastCtx(_, p26) -- line: 204
	-- upvalues: s1 (ref)
	s1 = p26
end

return t1
