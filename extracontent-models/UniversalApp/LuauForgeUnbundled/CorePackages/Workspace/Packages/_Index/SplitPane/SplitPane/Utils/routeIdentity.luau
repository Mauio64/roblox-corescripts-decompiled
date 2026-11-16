local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SharedFlags").FFlagSignalsNavP3Dispatch

require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Navigation")
local appNavigationRegistry = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/RobloxAppNavigation").AppNavigationRegistry

local function readNavState(object)
	if fFlagSignalsNavP3Dispatch then
		if appNavigationRegistry.isRegistered() then
			return appNavigationRegistry.get().getState(false)
		end

		return nil
	else
		local navigation = object:getState().Navigation

		if navigation == nil then
			return nil
		end

		return navigation.roactNavigationState
	end
end

local function matchesIdentity(p2, p3): boolean
	if p2.routeName ~= p3.name then
		return false
	end

	local params = p2.params
	local v5 = if params ~= nil then params.detail else nil
	return tostring(v5) == tostring(p3.detail)
end

local function findOnFocusedPath(p2, callback)
	while p2 ~= nil do
		if callback(p2) then
			return p2
		end

		local routes = p2.routes

		if routes == nil then
			return nil
		end

		p2 = routes[p2.index]
	end

	return nil
end

return {
	findOnFocusedPath = findOnFocusedPath,
	findOpenRouteIdentity = function(object, p2)
		local v6

		if fFlagSignalsNavP3Dispatch then
			if appNavigationRegistry.isRegistered() then
				v6 = appNavigationRegistry.get().getState(false)
			end
		else
			local navigation = object:getState().Navigation

			if navigation ~= nil then
				v6 = navigation.roactNavigationState
			end
		end

		return findOnFocusedPath(v6, function(p3): boolean
			local v7 = p2

			if p3.routeName ~= v7.name then
				return false
			end

			local params = p3.params
			local v8 = if params ~= nil then params.detail else nil
			return tostring(v8) == tostring(v7.detail)
		end)
	end,
	snapshotRouteKeys = function(object)
		local set = {}
		local function visit(route)
			if route == nil then
				return
			end

			if route.key ~= nil then
				set[route.key] = true
			end

			if route.routes ~= nil then
				for k, route2 in route.routes do
					visit(route2)
				end
			end
		end

		local v5

		if fFlagSignalsNavP3Dispatch then
			if appNavigationRegistry.isRegistered() then
				v5 = appNavigationRegistry.get().getState(false)
			end
		else
			local navigation = object:getState().Navigation

			if navigation ~= nil then
				v5 = navigation.roactNavigationState
			end
		end

		if v5 == nil then
			return set
		end

		if v5.key ~= nil then
			set[v5.key] = true
		end

		if v5.routes ~= nil then
			for k, route in v5.routes do
				visit(route)
			end
		end

		return set
	end
}
