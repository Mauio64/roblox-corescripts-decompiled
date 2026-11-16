local parent = script:FindFirstAncestor("AppBlox").Parent

local React = require(parent.React)

return React.createContext({
	hasFullBleed = false,
	hasHeader = nil,
	hasActions = nil,
	setHasHeader = function() end,
	setHasActions = function() end,
	isFullscreen = false,
	headerBarHeight = 0,
	actionBarHeight = nil,
	setActionBarHeight = function() end,
	onCanvasPositionChanged = nil,
	contentTopOffset = nil,
	fullBleedOverlapOffset = 180,
	gradientTopBleedOffset = 80,
	gradientMidTransparency = nil,
	initialScrollY = 0,
	hasValidContainerSize = false,
	disableFocusNavEngineScroll = false,
	containerHeight = nil,
	headerOpacity = nil,
	stickyHeaderActive = false,
	onClose = nil,
	testId = nil,
	onCanvasSizeChanged = nil,
	isFullscreenOverlay = false,
	setFullscreenContent = nil,
	onExitFullscreenOverlay = nil,
	setOnExitFullscreenOverlay = nil
})
