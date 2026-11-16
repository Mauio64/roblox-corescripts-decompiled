local parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(parent.React)

require(parent.SduiCoreSystem)

local sduiReportGamePlayIntent = require(script.Parent.sduiReportGamePlayIntent)
local GameTile = require(parent.GameTile)
local HoverTileCoordinator = GameTile.HoverTileCoordinator
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiResetHoverOnExperienceLaunch = SharedFlags.FFlagSduiResetHoverOnExperienceLaunch
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppDemoModePlayButtonTelemetry = SharedFlags2.FFlagLuaAppDemoModePlayButtonTelemetry

local function useSduiReportExperienceLaunched(sduiContext, analyticsContext, universeId: string, placeId: string?, rootPlaceId: string?, appliedFilters, launchData: string?)
	local v = {
		sduiContext.dependencies.eventIngest,
		analyticsContext,
		universeId,
		placeId,
		rootPlaceId,
		appliedFilters,
		launchData,
		sduiContext.dependencies.sessionService,
		sduiContext
	}
	return React.useCallback(function(actionType: string?)
		if FFlagSduiResetHoverOnExperienceLaunch then
			HoverTileCoordinator.default:reset()
		end

		local v2 = {
			sduiContext = sduiContext,
			analyticsContext = analyticsContext,
			universeId = universeId,
			placeId = placeId,
			rootPlaceId = rootPlaceId,
			appliedFilters = appliedFilters,
			launchData = launchData,
			actionType = nil
		}

		if not FFlagLuaAppDemoModePlayButtonTelemetry then
			actionType = nil
		end

		v2.actionType = actionType
		sduiReportGamePlayIntent(v2)
	end, v)
end

return useSduiReportExperienceLaunched
