local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")

local sduiReportGamePlayIntent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/sduiReportGamePlayIntent")
local hoverTileCoordinator = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/GameTile").HoverTileCoordinator
local fFlagSduiResetHoverOnExperienceLaunch = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiResetHoverOnExperienceLaunch
local fFlagLuaAppDemoModePlayButtonTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagLuaAppDemoModePlayButtonTelemetry

local function useSduiReportExperienceLaunched(p2, p3, p4, p5, p6, p7, p8)
	local v5 = {
		p2.dependencies.eventIngest,
		p3,
		p4,
		p5,
		p6,
		p7,
		p8,
		p2.dependencies.sessionService,
		p2
	}
	return React.useCallback(function(actionType)
		if fFlagSduiResetHoverOnExperienceLaunch then
			hoverTileCoordinator.default:reset()
		end

		local v7 = {
			sduiContext = p2,
			analyticsContext = p3,
			universeId = p4,
			placeId = p5,
			rootPlaceId = p6,
			appliedFilters = p7,
			launchData = p8,
			actionType = nil
		}

		if not fFlagLuaAppDemoModePlayButtonTelemetry then
			actionType = nil
		end

		v7.actionType = actionType
		sduiReportGamePlayIntent(v7)
	end, v5)
end

return useSduiReportExperienceLaunched
