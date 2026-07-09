local TenFootUiShell = script:FindFirstAncestor("TenFootUiShell")
local TenFootUiShellParent = TenFootUiShell.Parent
local ReactNavigationExtend = TenFootUiShell.ReactNavigationExtend
local React = require(TenFootUiShellParent.React)
local SceneManagement = require(TenFootUiShellParent.SceneManagement)
local SurfaceGuiWithAdornee = SceneManagement.SurfaceGuiWithAdornee
local useCameraFacingGeometry = SceneManagement.useCameraFacingGeometry
local Constants = require(ReactNavigationExtend.Views.Constants)
local ScreenKind = require(TenFootUiShellParent.TenFootUiCommon).TenFootUiRNTypes.ScreenKind
local SceneViewWithFocusRoot = require(script.Parent.SceneViewWithFocusRoot)
local TenFootUiOverflowScreen = require(TenFootUiShell.Components.TenFootUiOverflowScreen)
local Navigation = require(TenFootUiShellParent.Navigation)
local getCurrentRouteKey = Navigation.getCurrentRouteKey
local getRouteKeyIsInNavigationState = Navigation.getRouteKeyIsInNavigationState
local getActiveChildNavigationOptionsRecursively = Navigation.getActiveChildNavigationOptionsRecursively
local useEarlyIsFocused = Navigation.useEarlyIsFocused
local LuauPolyfill = require(TenFootUiShellParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local CompositionStyleSheet = require(TenFootUiShellParent.AppComposition).CompositionStyleSheet

local function getAdorneeSizeFromScreenSize(vector2: Vector2) -- line: 40
	-- upvalues: Constants (copy)
	return (Vector3.new(vector2.X, vector2.Y, Constants.ADORNEE_DEPTH))
end
local function getCanvasSize(p1) -- line: 44
	-- upvalues: ScreenKind (copy), Constants (copy)
	if (p1.options.screenKind or ScreenKind.Default) == ScreenKind.FullScreen then
		return Constants.FULLSCREEN_CANVAS_SIZE
	end

	return Constants.DEFAULT_CANVAS_SIZE
end
local function combineTransparencies(t1: {[any]: any}) -- line: 53
	-- upvalues: Array (copy)
	return 1 - Array.reduce(t1, function(n1: number, n2: number?) -- line: 55
		return n1 * (1 - (n2 or 0))
	end, 1)
end
local function useCombinedTransparency(...) -- line: 60
	-- upvalues: React (copy), combineTransparencies (copy)
	local t2 = { ... }

	return React.useMemo(function() -- line: 62
		-- upvalues: React (copy), t2 (copy), combineTransparencies (copy)
		return React.joinBindings(t2):map(combineTransparencies)
	end, t2)
end
local function getIsSelectionFocusable(p2, p3) -- line: 67
	-- upvalues: getCurrentRouteKey (copy), getRouteKeyIsInNavigationState (copy)
	local v34 = getCurrentRouteKey(p2)

	if p3.options.hasSubNavigation and v34 ~= nil then
		return (getRouteKeyIsInNavigationState(v34, p3.state))
	end

	return v34 == p3.key
end
local function getScreenKind(p4, p5) -- line: 75
	-- upvalues: getActiveChildNavigationOptionsRecursively (copy), ScreenKind (copy)
	return ((if not p5.options.hasSubNavigation then nil else getActiveChildNavigationOptionsRecursively(p4).screenKind)) or (p5.options.screenKind or ScreenKind.Default)
end
local function TenFootUiBaseViewCard(t3: {[any]: any}) -- line: 85
	-- upvalues: useCameraFacingGeometry (copy), Constants (copy), useEarlyIsFocused (copy), getCurrentRouteKey (copy), getRouteKeyIsInNavigationState (copy), getActiveChildNavigationOptionsRecursively (copy), ScreenKind (copy), useCombinedTransparency (copy), React (copy), Object (copy), TenFootUiOverflowScreen (copy), SceneViewWithFocusRoot (copy), CompositionStyleSheet (copy), SurfaceGuiWithAdornee (copy), getAdorneeSizeFromScreenSize (copy)
	local descriptor = t3.descriptor
	local screenProps = t3.screenProps
	local navigation = t3.navigation
	local v41 = useCameraFacingGeometry(Constants.DEFAULT_SCREEN_DISTANCE_TO_CAMERA)
	local v42 = useEarlyIsFocused() and t3.isActiveCard
	local v43 = getCurrentRouteKey(navigation)
	local v44 = if not descriptor.options.hasSubNavigation or v43 == nil then v43 == descriptor.key else getRouteKeyIsInNavigationState(v43, descriptor.state)
	local v45 = ((if not descriptor.options.hasSubNavigation then nil else getActiveChildNavigationOptionsRecursively(navigation).screenKind)) or (descriptor.options.screenKind or ScreenKind.Default)
	local v46 = t3.isVisible and (screenProps.isVisible == nil or screenProps.isVisible)
	local v47 = useCombinedTransparency(t3.groupTransparency, screenProps.groupTransparency)
	local v48 = React.useMemo(function() -- line: 98
		-- upvalues: Object (copy), screenProps (copy), v46 (copy), v47 (copy)
		return Object.assign({}, screenProps, {
			isVisible = v46,
			groupTransparency = v47
		})
	end, {
		screenProps,
		v46,
		v47
	})
	local v49 = React.createElement(TenFootUiOverflowScreen, {
		screenKind = v45,
		groupTransparency = v47
	}, {
		SceneView = React.createElement(SceneViewWithFocusRoot, {
			component = descriptor.getComponent(),
			navigation = descriptor.navigation,
			screenProps = v48,
			isFocusable = v42 and v44,
			shouldRestoreFocus = descriptor.options.enableFocusRestoration
		})
	})
	local v50 = React.createElement(React.Fragment, nil, {
		CompositionStyleSheet = React.createElement(CompositionStyleSheet),
		Content = v49
	})

	return React.createElement(SurfaceGuiWithAdornee, {
		name = descriptor.key,
		adorneeSize = v41.viewportFillDimensions:map(getAdorneeSizeFromScreenSize),
		adorneeCFrame = t3.adorneeCFrame,
		adorneeParent = screenProps.worldContainer,
		canvasSize = if (descriptor.options.screenKind or ScreenKind.Default) ~= ScreenKind.FullScreen then Constants.DEFAULT_CANVAS_SIZE else Constants.FULLSCREEN_CANVAS_SIZE,
		isVisible = v46,
		surfaceGuiParent = screenProps.surfaceGuiContainer
	}, v50)
end

return TenFootUiBaseViewCard
