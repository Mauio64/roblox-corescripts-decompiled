local StarterGui = game:GetService("StarterGui")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")

local Analytics = require(CorePackages.Workspace.Packages.Analytics)
local EventStream = Analytics.AnalyticsReporters.EventStream

local CoreGuiFinalStateAnalytics = {}
CoreGuiFinalStateAnalytics.__index = CoreGuiFinalStateAnalytics

function CoreGuiFinalStateAnalytics.new()
	local v = {
		evenStream = EventStream.new(RbxAnalyticsService)
	}
	setmetatable(v, CoreGuiFinalStateAnalytics)
	return v
end

function CoreGuiFinalStateAnalytics.sendCoreGuiFinalAnalytic(p)
	local coreGuiEnabledsByName = {
		placeid = tostring(game.PlaceId),
		universeid = tostring(game.GameId),
		sessionid = RbxAnalyticsService:GetSessionId()
	}

	for _, v in Enum.CoreGuiType:GetEnumItems() do
		coreGuiEnabledsByName[v.Name] = tostring(StarterGui:GetCoreGuiEnabled(v))
	end

	local resetButtonCallback = ""
	pcall(function()
		resetButtonCallback = tostring(StarterGui:GetCore("ResetButtonCallback"))
	end)
	coreGuiEnabledsByName.ResetButtonCallback = resetButtonCallback
	p.evenStream:sendEventDeferred("core_gui_final_state", "core_gui_final_state", coreGuiEnabledsByName)
end

return CoreGuiFinalStateAnalytics
