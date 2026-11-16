local parent = script:FindFirstAncestor("SplitPane").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown

local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local NavigationCommands = RobloxAppNavigation.NavigationCommands
local AppNavigationRegistry = RobloxAppNavigation.AppNavigationRegistry

local createNavigationHandle = require(script.Parent.Parent.Utils.createNavigationHandle)
local routeIdentity = require(script.Parent.Parent.Utils.routeIdentity)

return function(p, p2)
	return function(object)
		local v

		if p2 == nil then
			v = false
		else
			v = p2.deduplicate == true
		end

		local bypassNavigationLock

		if p2 ~= nil then
			bypassNavigationLock = p2.bypassNavigationLock
		end

		local function matchesIdentity(p3): boolean -- 1 equivalent call inferred from this helper
			if p3.routeName ~= p.name then
				return false
			end

			local params = p3.params
			local v2

			if params ~= nil then
				v2 = params.detail
			end

			return tostring(v2) == tostring(p.detail)
		end

		if v then
			local openRouteIdentity = routeIdentity.findOpenRouteIdentity(object, p)

			if openRouteIdentity ~= nil then
				local selected

				if FFlagSignalsNavP3Dispatch then
					selected = createNavigationHandle.new(AppNavigationRegistry.get().getState, openRouteIdentity.key)
				else
					selected = createNavigationHandle.fromRoduxStore(object, openRouteIdentity.key)
				end

				selected.deduplicated = true
				return selected
			end
		end

		local snapshotRouteKeys = routeIdentity.snapshotRouteKeys(object)
		local function matchesNewPush(p3)
			return matchesIdentity(p3) and snapshotRouteKeys[p3.key] == nil -- inferred equivalent call
		end

		if not FFlagSignalsNavP3Dispatch then
			object:dispatch(NavigateDown(p, bypassNavigationLock))

			return createNavigationHandle.fromRoduxStore(object, matchesNewPush)
		end

		NavigationCommands.down(NavigationCommands.fromLegacyPage(p), bypassNavigationLock)

		if AppNavigationRegistry.isRegistered() then
			return createNavigationHandle.new(AppNavigationRegistry.get().getState, matchesNewPush)
		end

		return nil
	end
end
