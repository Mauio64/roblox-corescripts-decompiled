local Parent = script:FindFirstAncestor("SplitPane").Parent
local Navigation = require(Parent.Navigation)
local RoactNavigation = require(Parent.RoactNavigation)
local Constants = require(Parent.NavigationRodux).Constants
local SplitPaneSlot = require(Parent.AppSplitView).Enums.SplitPaneSlot
local ViewState = Navigation.ViewState
local TempRnSwitchNavigatorName = Constants.TempRnSwitchNavigatorName

local function getUpdatedNavigation(p1) -- line: 15
	local v12 = if not p1._dangerouslyGetParent then nil else p1._dangerouslyGetParent()
	local v13 = if p1.state == nil then nil else p1.state.key

	if v12 and v13 then
		return v12.getChildNavigation(v13) or p1
	end

	return p1
end
local function resolveOptions(t1: {[any]: any}) -- line: 24
	-- upvalues: TempRnSwitchNavigatorName (copy), RoactNavigation (copy)
	local descriptor = t1.descriptor
	local state = descriptor.state

	if state ~= nil and (state.routeName == TempRnSwitchNavigatorName and descriptor.navigation ~= nil) then
		local navigation = descriptor.navigation
		local v18 = if not navigation._dangerouslyGetParent then nil else navigation._dangerouslyGetParent()
		local v19 = if navigation.state == nil then nil else navigation.state.key
		local v20 = if not v18 or not v19 then navigation else v18.getChildNavigation(v19) or navigation

		return RoactNavigation.getActiveChildNavigationOptions(v20) or {}
	end

	return descriptor.options
end
local function computeSplitEligibility(t2: {[any]: any}) -- line: 34
	-- upvalues: ViewState (copy), resolveOptions (copy), SplitPaneSlot (copy)
	for i = #t2, 1, -1 do
		local v23 = t2[i]

		if v23.viewState == ViewState.Closing then
			continue
		end

		local v24 = resolveOptions(v23)
		local splitPaneEligibility = v24.splitPaneEligibility

		if splitPaneEligibility ~= nil or not v24.transparent and not v24.overlayEnabled then
			if splitPaneEligibility == SplitPaneSlot.Content then
				return true
			end

			if splitPaneEligibility ~= nil then
				continue
			end

			return false
		end
	end

	return false
end

return computeSplitEligibility
