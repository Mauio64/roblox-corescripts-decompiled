local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SharedFlags").FFlagSignalsNavP3Dispatch

local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/NavigationRodux").Thunks.NavigateDown

local RobloxAppNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/RobloxAppNavigation")
local navigationCommands = RobloxAppNavigation.NavigationCommands
local appNavigationRegistry = RobloxAppNavigation.AppNavigationRegistry

local createNavigationHandle = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/createNavigationHandle")
local routeIdentity = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/routeIdentity")

return function(p2, p3)
	return function(object)
		local v5 = not (p3 == nil) and p3.deduplicate == true
		local bypassNavigationLock = if p3 ~= nil then p3.bypassNavigationLock else nil

		local function matchesIdentity(p4): boolean
			if p4.routeName ~= p2.name then
				return false
			end

			local params = p4.params
			local v6 = if params ~= nil then params.detail else nil
			return tostring(v6) == tostring(p2.detail)
		end

		if v5 then
			local openRouteIdentity = routeIdentity.findOpenRouteIdentity(object, p2)

			if openRouteIdentity ~= nil then
				local v6

				if fFlagSignalsNavP3Dispatch then
					v6 = createNavigationHandle.new(appNavigationRegistry.get().getState, openRouteIdentity.key)
				else
					v6 = createNavigationHandle.fromRoduxStore(object, openRouteIdentity.key)
				end

				v6.deduplicated = true
				return v6
			end
		end

		local snapshotRouteKeys = routeIdentity.snapshotRouteKeys(object)
		local function matchesNewPush(data)
			local v6

			if data.routeName == p2.name then
				local params = data.params
				local v7 = if params ~= nil then params.detail else nil
				v6 = tostring(v7) == tostring(p2.detail)
			else
				v6 = false
			end

			return v6 and snapshotRouteKeys[data.key] == nil
		end

		if not fFlagSignalsNavP3Dispatch then
			object:dispatch(navigateDown(p2, bypassNavigationLock))

			return createNavigationHandle.fromRoduxStore(object, matchesNewPush)
		end

		navigationCommands.down(navigationCommands.fromLegacyPage(p2), bypassNavigationLock)

		if appNavigationRegistry.isRegistered() then
			return createNavigationHandle.new(appNavigationRegistry.get().getState, matchesNewPush)
		end

		return nil
	end
end
