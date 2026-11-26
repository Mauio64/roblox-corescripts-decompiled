local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/RoactNavigation")

local AppNavigationRegistry = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/AppNavigationRegistry")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/SharedFlags")
local fFlagSignalsNavPendingLock = SharedFlags.FFlagSignalsNavPendingLock
local fFlagSignalsNavHomeFlowBegin = SharedFlags.FFlagSignalsNavHomeFlowBegin

local homePageLoadTracker = if fFlagSignalsNavHomeFlowBegin then require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/HomePageLoadTracker").HomePageLoadTracker else nil

local home = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/RobloxAppEnums").AppPage.Home

local trackStart = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/TimeToInteractiveTracker").TimeToInteractiveTracker.trackStart

local function isNavigationLocked(p2)
	if fFlagSignalsNavPendingLock then
		return not p2 and AppNavigationRegistry.isNavigationLocked(false)
	end

	return not p2 and AppNavigationRegistry.get().getIsNavigating(false)
end

local function beginHomeVisitIfHome(p2)
	if p2 and p2.routeName == home then
		homePageLoadTracker.beginVisit()
	end
end

return {
	back = function(p2)
		local v5

		if fFlagSignalsNavPendingLock then
			v5 = not p2 and AppNavigationRegistry.isNavigationLocked(false)
		else
			v5 = not p2 and AppNavigationRegistry.get().getIsNavigating(false)
		end

		if v5 then
			return
		end

		AppNavigationRegistry.get().dispatch(RoactNavigation.Actions.back())
	end,
	down = function(p2, p3)
		local v5

		if fFlagSignalsNavPendingLock then
			v5 = not p3 and AppNavigationRegistry.isNavigationLocked(false)
		else
			v5 = not p3 and AppNavigationRegistry.get().getIsNavigating(false)
		end

		if v5 then
			return
		end

		if trackStart then
			trackStart("NavigateTo_" .. p2.routeName, true)
		end

		if fFlagSignalsNavHomeFlowBegin and p2 and p2.routeName == home then
			homePageLoadTracker.beginVisit()
		end

		AppNavigationRegistry.get().dispatch(RoactNavigation.StackActions.push(p2))
	end,
	to = function(p2, p3)
		local v5

		if fFlagSignalsNavPendingLock then
			v5 = not p3 and AppNavigationRegistry.isNavigationLocked(false)
		else
			v5 = not p3 and AppNavigationRegistry.get().getIsNavigating(false)
		end

		if v5 then
			return
		end

		if trackStart then
			trackStart("NavigateTo_" .. p2.routeName, true)
		end

		if fFlagSignalsNavHomeFlowBegin and p2 and p2.routeName == home then
			homePageLoadTracker.beginVisit()
		end

		AppNavigationRegistry.get().dispatch(RoactNavigation.Actions.navigate(p2))
	end,
	sideways = function(p2, p3)
		local v5

		if fFlagSignalsNavPendingLock then
			v5 = not p3 and AppNavigationRegistry.isNavigationLocked(false)
		else
			v5 = not p3 and AppNavigationRegistry.get().getIsNavigating(false)
		end

		if v5 then
			return
		end

		if trackStart then
			trackStart("NavigateTo_" .. p2.routeName, true)
		end

		if fFlagSignalsNavHomeFlowBegin and p2 and p2.routeName == home then
			homePageLoadTracker.beginVisit()
		end

		AppNavigationRegistry.get().dispatch(RoactNavigation.Actions.navigate(p2))
	end,
	fromWebView = function(p2, p3)
		local v5

		if fFlagSignalsNavPendingLock then
			v5 = not p3 and AppNavigationRegistry.isNavigationLocked(false)
		else
			v5 = not p3 and AppNavigationRegistry.get().getIsNavigating(false)
		end

		if v5 then
			return
		end

		if trackStart then
			trackStart("NavigateTo_" .. p2.routeName, true)
		end

		if fFlagSignalsNavHomeFlowBegin and p2 and p2.routeName == home then
			homePageLoadTracker.beginVisit()
		end

		AppNavigationRegistry.get().dispatch(RoactNavigation.StackActions.replace(p2))
	end,
	resetStack = function(list, p2, p3)
		local v5

		if fFlagSignalsNavPendingLock then
			v5 = not p3 and AppNavigationRegistry.isNavigationLocked(false)
		else
			v5 = not p3 and AppNavigationRegistry.get().getIsNavigating(false)
		end

		if v5 then
			return
		end

		local v6 = {}
		local wrapAction = if p2 then p2.wrapAction else nil

		for k, item in list do
			local v7 = RoactNavigation.Actions.navigate(item)

			v7 = wrapAction and wrapAction(v7, item) or v7

			table.insert(v6, v7)
		end

		local v7 = trackStart and list[#list]

		if v7 then
			trackStart("NavigateTo_" .. v7.routeName, true)
		end

		if fFlagSignalsNavHomeFlowBegin then
			local item = list[#list]

			if item and item.routeName == home then
				homePageLoadTracker.beginVisit()
			end
		end

		AppNavigationRegistry.get().dispatch(RoactNavigation.StackActions.reset({
			index = #v6,
			actions = v6
		}))
	end,
	fromLegacyPage = function(p2)
		local v5 = nil

		for k, v6 in p2 do
			if not (k ~= "name" and k ~= "rnKey" and k ~= "key") then
				continue
			end

			v5 = v5 == nil and {} or v5

			v5[k] = v6
		end

		return {
			routeName = p2.name,
			params = v5,
			key = p2.rnKey or p2.key
		}
	end
}
