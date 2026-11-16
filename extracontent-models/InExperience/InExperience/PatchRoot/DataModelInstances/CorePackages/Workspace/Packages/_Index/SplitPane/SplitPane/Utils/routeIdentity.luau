local parent = script:FindFirstAncestor("SplitPane").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

require(parent.Navigation)
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local AppNavigationRegistry = RobloxAppNavigation.AppNavigationRegistry

local function readNavState(object) -- 2 equivalent calls inferred from this helper
	if FFlagSignalsNavP3Dispatch then
		if AppNavigationRegistry.isRegistered() then
			return AppNavigationRegistry.get().getState(false)
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

local function matchesIdentity(p, p2): boolean -- 1 equivalent call inferred from this helper
	if p.routeName ~= p2.name then
		return false
	end

	local params = p.params
	local v

	if params ~= nil then
		v = params.detail
	end

	return tostring(v) == tostring(p2.detail)
end

local function findOnFocusedPath(p, fn)
	while p ~= nil do
		if fn(p) then
			return p
		end

		local routes = p.routes

		if routes == nil then
			return nil
		end

		p = routes[p.index]
	end

	return nil
end

local RouteIdentity = {}
RouteIdentity.findOnFocusedPath = findOnFocusedPath

function RouteIdentity.findOpenRouteIdentity(object, p)
	return findOnFocusedPath(readNavState(object), function(p2) -- inferred equivalent call
		return matchesIdentity(p2, p) -- inferred equivalent call
	end)
end

function RouteIdentity.snapshotRouteKeys(object)
	local set = {}
	local function visit(route)
		if route == nil then
			return
		end

		if route.key ~= nil then
			set[route.key] = true
		end

		if route.routes ~= nil then
			for _, route2 in route.routes do
				visit(route2)
			end
		end
	end

	local navState = readNavState(object) -- inferred equivalent call

	if navState == nil then
		return set
	end

	if navState.key ~= nil then
		set[navState.key] = true
	end

	if navState.routes ~= nil then
		for _, route in navState.routes do
			visit(route)
		end
	end

	return set
end

return RouteIdentity
