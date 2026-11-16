local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/RoactNavigation")

local AppNavigationRegistry = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/AppNavigationRegistry")

local trackStart = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/TimeToInteractiveTracker").TimeToInteractiveTracker.trackStart

local function isNavigationLocked(p2)
	return not p2 and AppNavigationRegistry.get().getIsNavigating(false)
end

return {
	back = function(p2)
		if not p2 and AppNavigationRegistry.get().getIsNavigating(false) then
			return
		end

		AppNavigationRegistry.get().dispatch(RoactNavigation.Actions.back())
	end,
	down = function(p2, p3)
		if not p3 and AppNavigationRegistry.get().getIsNavigating(false) then
			return
		end

		if trackStart then
			trackStart("NavigateTo_" .. p2.routeName, true)
		end

		AppNavigationRegistry.get().dispatch(RoactNavigation.StackActions.push(p2))
	end,
	to = function(p2, p3)
		if not p3 and AppNavigationRegistry.get().getIsNavigating(false) then
			return
		end

		if trackStart then
			trackStart("NavigateTo_" .. p2.routeName, true)
		end

		AppNavigationRegistry.get().dispatch(RoactNavigation.Actions.navigate(p2))
	end,
	sideways = function(p2, p3)
		if not p3 and AppNavigationRegistry.get().getIsNavigating(false) then
			return
		end

		if trackStart then
			trackStart("NavigateTo_" .. p2.routeName, true)
		end

		AppNavigationRegistry.get().dispatch(RoactNavigation.Actions.navigate(p2))
	end,
	fromWebView = function(p2, p3)
		if not p3 and AppNavigationRegistry.get().getIsNavigating(false) then
			return
		end

		if trackStart then
			trackStart("NavigateTo_" .. p2.routeName, true)
		end

		AppNavigationRegistry.get().dispatch(RoactNavigation.StackActions.replace(p2))
	end,
	resetStack = function(list, p2, p3)
		if not p3 and AppNavigationRegistry.get().getIsNavigating(false) then
			return
		end

		local v5 = {}
		local wrapAction = if p2 then p2.wrapAction else nil

		for k, item in list do
			local v6 = RoactNavigation.Actions.navigate(item)

			v6 = wrapAction and wrapAction(v6, item) or v6

			table.insert(v5, v6)
		end

		local v6 = trackStart and list[#list]

		if v6 then
			trackStart("NavigateTo_" .. v6.routeName, true)
		end

		AppNavigationRegistry.get().dispatch(RoactNavigation.StackActions.reset({
			index = #v5,
			actions = v5
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
