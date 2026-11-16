local parent = script:FindFirstAncestor("SplitPane").Parent
local Display = require(parent.Display)
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore
local SplitPaneTelemetry = require(script.Parent.SplitPaneTelemetry)

local function getTelemetrySnapshot(p, p2)
	local displayStore = Display.GetDisplayStore(p2)
	local viewportSize = displayStore.getViewportSize(p2)
	local platformScale = displayStore.getPlatformScale(p2)
	local designSpaceViewportWidth = displayStore.getDesignSpaceViewportWidth(p2)
	local currentScreenOrientation = p.getCurrentScreenOrientation(p2)
	local isLandscape = currentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft
		or currentScreenOrientation == Enum.ScreenOrientation.LandscapeRight
	local viewportSize2

	if not (viewportSize == Vector2.new(1, 1) or currentScreenOrientation == nil) then
		viewportSize2 = Vector2.new(math.round(designSpaceViewportWidth), (math.round(viewportSize.Y / platformScale)))
	end

	local view

	if p.getIsSplitPaneCollapsedOrNotActive(p2) then
		view = SplitPaneTelemetry.View.Hidden
	else
		view = SplitPaneTelemetry.View.Shown
	end

	return {
		viewportSize = viewportSize2,
		isLandscape = isLandscape,
		view = view,
		userId = localUserIdStore.getCurrentUserId(p2)
	}
end

return getTelemetrySnapshot
