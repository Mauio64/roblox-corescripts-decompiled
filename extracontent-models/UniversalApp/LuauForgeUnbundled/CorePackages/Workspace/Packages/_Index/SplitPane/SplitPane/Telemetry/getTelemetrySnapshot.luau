local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Display")
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/LocalUserIdStore").LocalUserIdStore
local SplitPaneTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Telemetry/SplitPaneTelemetry")

local function getTelemetrySnapshot(p2, p3)
	local displayStore = Display.GetDisplayStore(p3)
	local viewportSize = displayStore.getViewportSize(p3)
	local platformScale = displayStore.getPlatformScale(p3)
	local designSpaceViewportWidth = displayStore.getDesignSpaceViewportWidth(p3)
	local currentScreenOrientation = p2.getCurrentScreenOrientation(p3)
	local v5 = currentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft
		or currentScreenOrientation == Enum.ScreenOrientation.LandscapeRight

	local telemetrySnapshot = {
		viewportSize = if viewportSize ~= Vector2.new(1, 1) and currentScreenOrientation ~= nil then Vector2.new(
			math.round(designSpaceViewportWidth),
			(math.round(viewportSize.Y / platformScale))
		) else nil,
		isLandscape = v5,
		view = 0,
		userId = 0
	}

	local v7 = if p2.getIsSplitPaneCollapsedOrNotActive(p3) then SplitPaneTelemetry.View.Hidden else SplitPaneTelemetry.View.Shown
	telemetrySnapshot.view = v7

	telemetrySnapshot.userId = localUserIdStore.getCurrentUserId(p3)
	return telemetrySnapshot
end

return getTelemetrySnapshot
