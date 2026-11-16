function debugPrint(_) end

debugPrint("Self View Analytics 10-19-2022__1")

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Analytics = {}
Analytics.__index = Analytics

Analytics.INFO = "info"
Analytics.WARNING = "warning"
Analytics.ERROR = "error"

local v = "SelfView"

function Analytics.new(impl)
	impl = impl or RbxAnalyticsService
	assert(impl, "Analytics impl must not be nil.")

	return (setmetatable({ _impl = impl }, Analytics))
end

local function stub() end

function Analytics.stubService()
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

function Analytics:setImpl(impl)
	self._impl = impl
end

function Analytics:_report(p, p2, _, p3)
	local v2 = RunService:IsStudio() and "studio" or "client"

	self._impl:SendEventDeferred(v2, p, p2, p3)
end

function Analytics:reportMicState(state)
	debugPrint("Self View: Analytics:reportMicState, newState: " .. tostring(state) .. ",universeid: " .. tostring(game.GameId) .. ",pid: " .. tostring(game.PlaceId) .. ",uid: " .. tostring(Players.LocalPlayer.UserId) .. ",sessionid: " .. tostring(self._impl:GetSessionId()))
	self:_report(v, "inExperienceMicState", tostring(state), {
		state = state,
		universeid = tostring(game.GameId),
		pid = tostring(game.PlaceId),
		uid = tostring(Players.LocalPlayer.UserId),
		sessionid = tostring(self._impl:GetPlaySessionId())
	})
end

function Analytics:reportCamState(state)
	debugPrint("Self View: Analytics:reporCamState, newState: " .. tostring(state) .. ",universeid: " .. tostring(game.GameId) .. ",pid: " .. tostring(game.PlaceId) .. ",uid: " .. tostring(Players.LocalPlayer.UserId) .. ",sessionid: " .. tostring(self._impl:GetSessionId()))
	self:_report(v, "inExperienceCamState", tostring(state), {
		state = state,
		universeid = tostring(game.GameId),
		pid = tostring(game.PlaceId),
		uid = tostring(Players.LocalPlayer.UserId),
		sessionid = tostring(self._impl:GetPlaySessionId())
	})
end

function Analytics:reportSelfViewEnabledInCoreGuiState(state)
	debugPrint("Self View: Analytics:reportSelfViewEnabledInCoreGuiState, newState: " .. tostring(state) .. ",universeid: " .. tostring(game.GameId) .. ",pid: " .. tostring(game.PlaceId) .. ",sessionid: " .. tostring(self._impl:GetSessionId()))
	self:_report("SelfView", "enabledinCoreGuiState", tostring(state), {
		state = state,
		universeid = tostring(game.GameId),
		pid = tostring(game.PlaceId),
		sessionid = tostring(self._impl:GetPlaySessionId())
	})
end

function Analytics:reportSelfViewSessionStarted(p, p2, p3, p4, p5, p6, p7, p8)
	debugPrint("Self View: Analytics:reportSelfViewSessionStarted,universeid: " .. tostring(game.GameId) .. ",pid: " .. tostring(game.PlaceId) .. ",sessionid: " .. tostring(self._impl:GetSessionId()) .. ",x: " .. tostring(p) .. ",y: " .. tostring(p2) .. ",width: " .. tostring(p3) .. ",height: " .. tostring(p4) .. ",x_relative: " .. tostring(p5) .. ",y_relative: " .. tostring(p6) .. ",width_relative: " .. tostring(p7) .. ",height_relative: " .. tostring(p8))
	self:_report("SelfView", "sessionStarted", "true", {
		universeid = tostring(game.GameId),
		pid = tostring(game.PlaceId),
		sessionid = tostring(self._impl:GetPlaySessionId()),
		x = tostring(p),
		y = tostring(p2),
		width = tostring(p3),
		height = tostring(p4),
		x_relative = tostring(p5),
		y_relative = tostring(p6),
		width_relative = tostring(p7),
		height_relative = tostring(p8)
	})

	RbxAnalyticsService:AddGlobalPointsField("feature/avatarChat/selfViewOn", 1)
end

function Analytics:reportSelfViewSessionStopped()
	debugPrint("Self View: Analytics:reportSelfViewSessionStopped,universeid: " .. tostring(game.GameId) .. ",pid: " .. tostring(game.PlaceId) .. ",sessionid: " .. tostring(self._impl:GetSessionId()))
	self:_report("SelfView", "sessionStopped", "true", {
		universeid = tostring(game.GameId),
		pid = tostring(game.PlaceId),
		sessionid = tostring(self._impl:GetPlaySessionId())
	})

	RbxAnalyticsService:AddGlobalPointsField("feature/avatarChat/selfViewOn", 0)
end

function Analytics:reportUserAccountSettings(flag: boolean, flag2: boolean)
	debugPrint("Self View: Analytics:reportUserAccountSettings,universeid: " .. tostring(game.GameId) .. ",pid: " .. tostring(game.PlaceId) .. ",sessionid: " .. tostring(self._impl:GetSessionId()) .. ",userAccount_videoEnabled: " .. tostring(flag) .. ",userAccount_audioEnabled: " .. tostring(flag2))
	self:_report("SelfView", "userAccountSettings", "true", {
		universeid = tostring(game.GameId),
		pid = tostring(game.PlaceId),
		sessionid = tostring(self._impl:GetPlaySessionId()),
		videoenabled = tostring(flag),
		audioenabled = tostring(flag2)
	})
end

function Analytics:reportExperienceSettings(flag: boolean, flag2: boolean, flag3: boolean)
	debugPrint("Self View: Analytics:reportExperienceSettings,universeid: " .. tostring(game.GameId) .. ",pid: " .. tostring(game.PlaceId) .. ",sessionid: " .. tostring(self._impl:GetSessionId()) .. ",experienceSettings_placeEnabled: " .. tostring(flag) .. ",experienceSettings_videoEnabled: " .. tostring(flag2) .. ",experienceSettings_audioEnabled: " .. tostring(flag3))
	self:_report("SelfView", "experienceSettings", "true", {
		universeid = tostring(game.GameId),
		pid = tostring(game.PlaceId),
		sessionid = tostring(self._impl:GetPlaySessionId()),
		placeenabled = tostring(flag),
		videoenabled = tostring(flag2),
		audioenabled = tostring(flag3)
	})
end

function Analytics.setLastCtx(_, p)
	v = p
end

return Analytics
