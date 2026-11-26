local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Navigation")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/RoactNavigation")
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/NavigationRodux").Constants
local splitPaneSlot = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/AppSplitView").Enums.SplitPaneSlot
local fFlagAXFixSplitPaneHomeTryOnReset = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SharedFlags").FFlagAXFixSplitPaneHomeTryOnReset

local viewState = Navigation.ViewState
local tempRnSwitchNavigatorName = constants.TempRnSwitchNavigatorName

local function getUpdatedNavigation(p2)
	local v5 = if p2._dangerouslyGetParent then p2._dangerouslyGetParent() else nil
	local key = if p2.state ~= nil then p2.state.key else nil

	if v5 and key then
		return v5.getChildNavigation(key) or p2
	end

	return p2
end

local function resolveOptions(item)
	local descriptor = item.descriptor
	local state = descriptor.state

	if state == nil or state.routeName ~= tempRnSwitchNavigatorName or descriptor.navigation == nil then
		return descriptor.options
	end

	local v5 = descriptor.navigation
	local v6 = if v5._dangerouslyGetParent then v5._dangerouslyGetParent() else nil
	local key = if v5.state ~= nil then v5.state.key else nil

	v5 = v6 and key and v6.getChildNavigation(key) or v5

	return RoactNavigation.getActiveChildNavigationOptions(v5) or {}
end

local function computeSplitEligibility(list): boolean
	for i = #list, 1, -1 do
		local item = list[i]

		if item.viewState == viewState.Closing then
			if fFlagAXFixSplitPaneHomeTryOnReset then
				local options = resolveOptions(item)

				if
					options.splitPaneEligibility == nil
					and not (options.transparent or options.overlayEnabled)
				then
					return false
				end
			end
		else
			local options = resolveOptions(item)
			local splitPaneEligibility = options.splitPaneEligibility

			if splitPaneEligibility ~= nil or not (options.transparent or options.overlayEnabled) then
				if splitPaneEligibility == splitPaneSlot.Content then
					return true
				end

				if splitPaneEligibility == nil then
					return false
				end
			end
		end
	end

	return false
end

return computeSplitEligibility
