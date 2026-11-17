local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local React = require(parent.React)

local ElevationLayer = require(Foundation.Enums.ElevationLayer)
local InternalDrawer = require(Foundation.Components.InternalDrawer)
local InternalDrawerBackdrop = require(Foundation.Enums.InternalDrawerBackdrop)
local InternalDrawerLayout = require(Foundation.Enums.InternalDrawerLayout)
local InternalDrawerShadow = require(Foundation.Enums.InternalDrawerShadow)
local InternalDrawerSide = require(Foundation.Enums.InternalDrawerSide)
require(Foundation.Components.InternalDrawer.Types)
require(Foundation.Enums.OnCloseCallbackReason)
local SwipeBehavior = require(Foundation.Enums.SwipeBehavior)
local useElevation = require(Foundation.Providers.Elevation.useElevation)
local useHardwareInsets = require(Foundation.Components.Sheet.useHardwareInsets)
local useOverlay = require(Foundation.Providers.Overlay.useOverlay)
local useScaledValue = require(Foundation.Utility.useScaledValue)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = {}
local v2 = {}

local v3 = { testId = "--foundation-navigation-drawer", width = 320 }

local function NavigationDrawer(p, ref)
	local v4 = withDefaults(p, v3)
	local elevation = useElevation(ElevationLayer.Drawer, { stackAboveOwner = false })
	local v5 = useHardwareInsets((useOverlay()))
	local width = useScaledValue(v4.width)
	local v6 = v4.swipe == SwipeBehavior.Open or v4.swipe == SwipeBehavior.OpenAndDismiss
	local v7 = v4.swipe == SwipeBehavior.Dismiss or v4.swipe == SwipeBehavior.OpenAndDismiss

	local createElement = React.createElement
	local v8 = {
		elevation = elevation,
		isOpen = v4.isOpen,
		onRequestClose = v4.onClose,
		onOpenComplete = v4.onOpenComplete,
		onCloseComplete = v4.onCloseComplete,
		side = InternalDrawerSide.Start,
		width = width,
		outerBleed = v5.left,
		backdrop = InternalDrawerBackdrop.Dismissible,
		layout = InternalDrawerLayout.FullBleed,
		shadow = InternalDrawerShadow.Overlay300,
		backgroundColor = "bg-surface-100",
		header = v4.header,
		footer = v4.footer,
		swipeToDismiss = 0,
		swipeToOpen = 0,
		onRequestOpen = 0,
		testId = 0,
		ref = 0
	}
	local swipeToDismiss

	if v7 then
		swipeToDismiss = v
	end

	v8.swipeToDismiss = swipeToDismiss
	local swipeToOpen

	if v6 then
		swipeToOpen = v2
	end

	v8.swipeToOpen = swipeToOpen
	v8.onRequestOpen = v4.onOpen
	v8.testId = v4.testId
	v8.ref = ref
	return createElement(InternalDrawer, v8, v4.children)
end

return React.memo(React.forwardRef(NavigationDrawer))
