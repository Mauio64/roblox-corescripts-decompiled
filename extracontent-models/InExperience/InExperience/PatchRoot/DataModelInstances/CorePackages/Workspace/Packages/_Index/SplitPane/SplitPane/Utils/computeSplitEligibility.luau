local parent = script:FindFirstAncestor("SplitPane").Parent

local Navigation = require(parent.Navigation)
local RoactNavigation = require(parent.RoactNavigation)
local NavigationRodux = require(parent.NavigationRodux)
local Constants = NavigationRodux.Constants
local AppSplitView = require(parent.AppSplitView)
local SplitPaneSlot = AppSplitView.Enums.SplitPaneSlot
local SharedFlags = require(parent.SharedFlags)
local FFlagAXFixSplitPaneHomeTryOnReset = SharedFlags.FFlagAXFixSplitPaneHomeTryOnReset

local ViewState = Navigation.ViewState
local TempRnSwitchNavigatorName = Constants.TempRnSwitchNavigatorName

local function getUpdatedNavigation(p)
	local v

	if p._dangerouslyGetParent then
		v = p._dangerouslyGetParent()
	end

	local key

	if p.state ~= nil then
		key = p.state.key
	end

	if v and key then
		return v.getChildNavigation(key) or p
	end

	return p
end

local function resolveOptions(item)
	local descriptor = item.descriptor
	local state = descriptor.state

	if state == nil or state.routeName ~= TempRnSwitchNavigatorName or descriptor.navigation == nil then
		return descriptor.options
	end

	local v = descriptor.navigation
	local v2

	if v._dangerouslyGetParent then
		v2 = v._dangerouslyGetParent()
	end

	local key

	if v.state ~= nil then
		key = v.state.key
	end

	v = v2 and key and v2.getChildNavigation(key) or v

	return RoactNavigation.getActiveChildNavigationOptions(v) or {}
end

local function computeSplitEligibility(list): boolean
	for i = #list, 1, -1 do
		local item = list[i]

		if item.viewState == ViewState.Closing then
			if FFlagAXFixSplitPaneHomeTryOnReset then
				local options = resolveOptions(item)

				if options.splitPaneEligibility == nil and not (options.transparent or options.overlayEnabled) then
					return false
				end
			end
		else
			local options = resolveOptions(item)
			local splitPaneEligibility = options.splitPaneEligibility

			if splitPaneEligibility ~= nil or not (options.transparent or options.overlayEnabled) then
				if splitPaneEligibility == SplitPaneSlot.Content then
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
