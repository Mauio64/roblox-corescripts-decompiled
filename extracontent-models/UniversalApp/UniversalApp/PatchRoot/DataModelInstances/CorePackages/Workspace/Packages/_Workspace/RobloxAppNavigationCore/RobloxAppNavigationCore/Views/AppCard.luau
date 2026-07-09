local Parent = script:FindFirstAncestor("RobloxAppNavigationCore").Parent
local React = require(Parent.React)
local SceneView = require(Parent.RoactNavigation).SceneView
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local Navigation = require(Parent.Navigation)
local useEarlyIsFocused = Navigation.useEarlyIsFocused
local getCurrentRouteKey = Navigation.getCurrentRouteKey
local getRouteKeyIsInNavigationState = Navigation.getRouteKeyIsInNavigationState
local ReactProfiler = require(Parent.RoactUtils).Profiling.ReactProfiler
local FFlagLuaAppEnablePageLoadTracker = require(Parent.SharedFlags).FFlagLuaAppEnablePageLoadTracker
local FFlagAXMigrateAXToGlobalAutofocus = require(Parent.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local ComponentTracker = require(Parent.PageLoadTracker).ComponentTracker
local FFlagLuaAppsDefaultSelection = require(Parent.SharedFlags).FFlagLuaAppsDefaultSelection
local v15 = React.createContext({})

local function getIsSelectionFocusable(p1, p2) -- line: 37
	-- upvalues: getCurrentRouteKey (copy), getRouteKeyIsInNavigationState (copy)
	local v20 = getCurrentRouteKey(p1)

	if p2.options.hasSubNavigation and v20 ~= nil then
		return (getRouteKeyIsInNavigationState(v20, p2.state))
	end

	return v20 == p2.key
end
local function AppCard(t1: {[any]: any}) -- line: 45
	-- upvalues: useEarlyIsFocused (copy), getCurrentRouteKey (copy), getRouteKeyIsInNavigationState (copy), FFlagLuaAppsDefaultSelection (copy), React (copy), ReactProfiler (copy), v15 (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigationUtils (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FFlagLuaAppEnablePageLoadTracker (copy), ComponentTracker (copy), SceneView (copy)
	local descriptor = t1.descriptor
	local navigation = descriptor.navigation
	local v24 = useEarlyIsFocused() and t1.isActive
	local v25 = getCurrentRouteKey(navigation)
	local v26 = if not descriptor.options.hasSubNavigation or v25 == nil then v25 == descriptor.key else getRouteKeyIsInNavigationState(v25, descriptor.state)
	local v27 = navigation.state.routeName or "UnknownRoute"
	local v28 = nil

	if FFlagLuaAppsDefaultSelection then
		v28 = v24 and v26
	end

	return React.createElement(ReactProfiler, {
		id = v27
	}, {
		DescriptorContext = React.createElement(v15.Provider, {
			value = t1.descriptor
		}, {
			FocusRoot = React.createElement(FocusNavigableSurfaceWrapper, {
				isFocusable = v24 and v26,
				surfaceIdentifier = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum.RouterView,
				shouldRestoreFocus = not FFlagLuaAppsDefaultSelection or v28,
				frameProps = {
					Interactable = true,
					SelectionGroup = if not FFlagAXMigrateAXToGlobalAutofocus then nil else t1.descriptor.options.hasSelectionGroup,
					Visible = t1.isVisible,
					ZIndex = t1.ZIndex
				}
			}, if not FFlagLuaAppEnablePageLoadTracker then {
				SceneView = React.createElement(SceneView, {
					navigation = navigation,
					component = descriptor.getComponent(),
					screenProps = t1.screenProps
				})
			} else {
				ComponentTracker = React.createElement(ComponentTracker, {
					componentName = `Page-{ v27 }`,
					isActive = t1.isActive
				}, {
					SceneView = React.createElement(SceneView, {
						navigation = navigation,
						component = descriptor.getComponent(),
						screenProps = t1.screenProps
					})
				})
			})
		})
	})
end

return AppCard
