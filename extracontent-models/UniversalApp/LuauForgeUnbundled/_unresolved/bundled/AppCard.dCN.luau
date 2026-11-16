local React = require("@game/CorePackages/Workspace/Packages/React")
local sceneView = require("@game/CorePackages/Workspace/Packages/RoactNavigation").SceneView
local module2 = require("@luauforge/bundled/dCO")
local focusNavigableSurfaceWrapper = module2.FocusNavigableSurfaceWrapper

local module3 = require("@luauforge/bundled/dCC")
local useEarlyIsFocused = module3.useEarlyIsFocused
local getCurrentRouteKey = module3.getCurrentRouteKey
local getRouteKeyIsInNavigationState = module3.getRouteKeyIsInNavigationState

local reactProfiler = require("@luauforge/bundled/dCP").Profiling.ReactProfiler
local fFlagLuaAppEnablePageLoadTracker = require("@luauforge/bundled/dCz").FFlagLuaAppEnablePageLoadTracker
local componentTracker = require("@luauforge/bundled/dCQ").ComponentTracker

local fFlagEnableOnScreenAPIIntegration = require("@luauforge/bundled/dCz").FFlagEnableOnScreenAPIIntegration
local v5 = if fFlagEnableOnScreenAPIIntegration then require("@luauforge/bundled/dDi") else nil
local onScreenCardProvider = if fFlagEnableOnScreenAPIIntegration then v5.OnScreenCardProvider else nil

local context = React.createContext({})

local function getIsSelectionFocusable(p2, data)
	local currentRouteKey = getCurrentRouteKey(p2)

	if data.options.hasSubNavigation and currentRouteKey ~= nil then
		return (getRouteKeyIsInNavigationState(currentRouteKey, data.state))
	end

	return currentRouteKey == data.key
end

local function AppCard(props)
	local descriptor = props.descriptor
	local navigation = descriptor.navigation
	local isActive = useEarlyIsFocused() and props.isActive
	local currentRouteKey = getCurrentRouteKey(navigation)
	local v6

	if descriptor.options.hasSubNavigation and currentRouteKey ~= nil then
		v6 = getRouteKeyIsInNavigationState(currentRouteKey, descriptor.state)
	else
		v6 = currentRouteKey == descriptor.key
	end

	local routeName = navigation.state.routeName or "UnknownRoute"

	local createElement = React.createElement

	local createElement2 = React.createElement
	local provider = context.Provider
	local v10 = { value = props.descriptor }

	local createElement3 = React.createElement

	local v13 = {
		isFocusable = isActive and v6,
		surfaceIdentifier = module2.FocusNavigableSurfaceIdentifierEnum.RouterView,
		shouldRestoreFocus = isActive and v6,
		frameProps = {
			SelectionGroup = props.descriptor.options.hasSelectionGroup,
			Visible = props.isVisible,
			ZIndex = props.ZIndex,
			Interactable = true
		}
	}
	local v14

	if fFlagLuaAppEnablePageLoadTracker then
		v14 = {
			ComponentTracker = React.createElement(
				componentTracker,
				{ componentName = `Page-{routeName}`, isActive = props.isActive },
				{
					SceneView = React.createElement(sceneView, {
						navigation = navigation,
						component = descriptor.getComponent(),
						screenProps = props.screenProps
					})
				}
			)
		}
	else
		v14 = {
			SceneView = React.createElement(sceneView, {
				navigation = navigation,
				component = descriptor.getComponent(),
				screenProps = props.screenProps
			})
		}
	end

	local element = createElement(reactProfiler, { id = routeName }, {
		DescriptorContext = createElement2(provider, v10, {
			FocusRoot = createElement3(focusNavigableSurfaceWrapper, v13, v14)
		})
	})

	if fFlagEnableOnScreenAPIIntegration and props.onScreenContextValue ~= nil then
		element = React.createElement(
			onScreenCardProvider,
			{ value = props.onScreenContextValue },
			element
		)
	end

	return element
end

return AppCard
