local StarterGui = game:GetService("StarterGui")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")

local Analytics = require(CorePackages.Workspace.Packages.Analytics)
local EventStream = Analytics.AnalyticsReporters.EventStream

local CoreGuiEnableAnalytics = {}
CoreGuiEnableAnalytics.__index = CoreGuiEnableAnalytics

function CoreGuiEnableAnalytics.new()
	local v = {}
	v.evenStream = EventStream.new(RbxAnalyticsService)
	v.playSessionStart = os.clock()

	function v.sendCoreGuiAnalytic(p, flag: boolean)
		local v2 = math.round((os.clock() - v.playSessionStart) * 1000)

		local v3 = {
			placeid = tostring(game.PlaceId),
			universeid = tostring(game.GameId),
			type = tostring(p.Name),
			enabled = tostring(flag),
			sessionid = RbxAnalyticsService:GetSessionId(),
			playSessionDurationMs = tostring(v2)
		}

		v.evenStream:sendEventDeferred("core_gui_type", "core_gui_type", v3)
	end

	v.signalConnection = StarterGui.CoreGuiChangedSignal:Connect(function(p, flag: boolean)
		v.sendCoreGuiAnalytic(p, flag)
	end)

	setmetatable(v, CoreGuiEnableAnalytics)
	return v
end

function CoreGuiEnableAnalytics.DisconnectSignal(p)
	p.signalConnection:Disconnect()
end

CoreGuiEnableAnalytics.new()

return CoreGuiEnableAnalytics
