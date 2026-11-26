local AppSplitView = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/AppSplitView")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Navigation")
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/NavigationRodux").Constants

require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Hooks/useSplitLayoutStatus")

local getCurrentNavigationState = Navigation.getCurrentNavigationState

local supportPaneMode = AppSplitView.Enums.SupportPaneMode
local tempRnSwitchNavigatorName = constants.TempRnSwitchNavigatorName

local v5 = { isOnScreen = false }

local function onScreenRouteKeyForScreen(p2)
	local descriptor = p2.descriptor
	local state = descriptor.state

	if state == nil or state.routeName ~= tempRnSwitchNavigatorName then
		return descriptor.key
	end

	local currentNavigationState = getCurrentNavigationState(state)

	if currentNavigationState == nil or currentNavigationState.key == nil then
		return descriptor.key
	end

	return currentNavigationState.key
end

local function getOnScreenContextValue(data, p2, p3)
	local v6 = false
	local contentTopCandidate = nil
	local v7 = nil
	local supportPaneMode2

	if data ~= nil then
		supportPaneMode2 = data.supportPaneMode

		if data.isRootAppStack and data.isSplitEnabled then
			contentTopCandidate = data.contentTopCandidate or data.splitPrimaryIndex

			if data.isRouteActiveOnPane then
				v7 = data.paneIndices[#data.paneIndices]
			end

			v6 = contentTopCandidate ~= nil or v7 ~= nil
		end
	end

	if not v6 then
		return nil
	end

	local v8 = p2 == v7 or p2 == contentTopCandidate and supportPaneMode2 ~= supportPaneMode.Expanded

	if not v8 then
		return v5
	end

	local descriptor = p3.descriptor
	local state = descriptor.state
	local key

	if state == nil or state.routeName ~= tempRnSwitchNavigatorName then
		key = descriptor.key
	else
		local currentNavigationState = getCurrentNavigationState(state)

		if currentNavigationState == nil or currentNavigationState.key == nil then
			key = descriptor.key
		else
			key = currentNavigationState.key
		end
	end

	return { isOnScreen = true, currentRouteKey = key }
end

return getOnScreenContextValue
