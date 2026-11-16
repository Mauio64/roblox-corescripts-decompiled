local parent = script:FindFirstAncestor("SplitPane").Parent

local AppSplitView = require(parent.AppSplitView)
local Navigation = require(parent.Navigation)
local NavigationRodux = require(parent.NavigationRodux)
local Constants = NavigationRodux.Constants

require(script.Parent.Parent.Hooks.useSplitLayoutStatus)

local getCurrentNavigationState = Navigation.getCurrentNavigationState

local SupportPaneMode = AppSplitView.Enums.SupportPaneMode
local TempRnSwitchNavigatorName = Constants.TempRnSwitchNavigatorName

local v = { isOnScreen = false }

local function onScreenRouteKeyForScreen(p) -- 1 equivalent call inferred from this helper
	local descriptor = p.descriptor
	local state = descriptor.state

	if state == nil or state.routeName ~= TempRnSwitchNavigatorName then
		return descriptor.key
	end

	local currentNavigationState = getCurrentNavigationState(state)

	if currentNavigationState == nil or currentNavigationState.key == nil then
		return descriptor.key
	end

	return currentNavigationState.key
end

local function getOnScreenContextValue(data, p: number, p2)
	local v2 = false
	local contentTopCandidate = nil
	local v3 = nil
	local supportPaneMode

	if data ~= nil then
		supportPaneMode = data.supportPaneMode

		if data.isRootAppStack and data.isSplitEnabled then
			contentTopCandidate = data.contentTopCandidate or data.splitPrimaryIndex

			if data.isRouteActiveOnPane then
				v3 = data.paneIndices[#data.paneIndices]
			end

			v2 = contentTopCandidate ~= nil or v3 ~= nil
		end
	end

	if not v2 then
		return nil
	end

	local v4

	if p == v3 then
		v4 = true
	elseif p == contentTopCandidate then
		v4 = supportPaneMode ~= SupportPaneMode.Expanded
	else
		v4 = false
	end

	if not v4 then
		return v
	end

	return { isOnScreen = true, currentRouteKey = onScreenRouteKeyForScreen(p2) } -- inferred equivalent call
end

return getOnScreenContextValue
