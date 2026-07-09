local TenFootUiShell = script:FindFirstAncestor("TenFootUiShell")
local TenFootUiShellParent = TenFootUiShell.Parent

require(TenFootUiShellParent.TenFootUiCommon)

local React = require(TenFootUiShellParent.React)
local RoactNavigation = require(TenFootUiShellParent.RoactNavigation)
local ReactFocusNavigation = require(TenFootUiShellParent.ReactFocusNavigation)
local FocusNavigationUtils = require(TenFootUiShellParent.FocusNavigationUtils)
local useFocusNavigableSurfaceRegistryConnection = FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useRootFocusNavigationBindings = require(TenFootUiShell.Hooks.useRootFocusNavigationBindings)
local SceneView = RoactNavigation.SceneView

require(TenFootUiShellParent.Navigation)

local FFlagFix10ftGlobalNavSelection = require(TenFootUiShellParent.SharedFlags).FFlagFix10ftGlobalNavSelection

local function SceneViewWithFocusRoot(t1: {[any]: any}) -- line: 26
	-- upvalues: React (copy), useRootFocusNavigationBindings (copy), ReactFocusNavigation (copy), useFocusNavigableSurfaceRegistryConnection (copy), FocusNavigableSurfaceIdentifierEnum (copy), FFlagFix10ftGlobalNavSelection (copy), SceneView (copy)
	local v14, v15 = React.useState(nil)
	local v16 = useRootFocusNavigationBindings(v15)
	local v17 = t1.shouldRestoreFocus == nil or t1.shouldRestoreFocus
	local v18 = ReactFocusNavigation.useMostRecentFocusBehavior(v16)
	local isFocusable = t1.isFocusable

	useFocusNavigableSurfaceRegistryConnection(v14, FocusNavigableSurfaceIdentifierEnum.RouterView, isFocusable)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.fromScale(1, 1),
		SelectionGroup = not not FFlagFix10ftGlobalNavSelection or nil,
		SelectionBehaviorLeft = if not FFlagFix10ftGlobalNavSelection then nil else Enum.SelectionBehavior.Stop,
		SelectionBehaviorRight = if not FFlagFix10ftGlobalNavSelection then nil else Enum.SelectionBehavior.Stop,
		ref = if not v17 then v16 else v18
	}, React.createElement(SceneView, {
		navigation = t1.navigation,
		component = t1.component,
		screenProps = t1.screenProps
	}))
end

return SceneViewWithFocusRoot
