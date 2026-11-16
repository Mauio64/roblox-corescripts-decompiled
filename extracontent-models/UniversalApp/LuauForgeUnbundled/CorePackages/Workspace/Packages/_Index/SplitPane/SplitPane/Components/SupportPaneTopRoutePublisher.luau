local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/React")

local SplitPaneStore = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/SplitPaneStore")
local routeIdentityMatches = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/routeIdentityMatches")

local function SupportPaneTopRoutePublisher(p2): nil
	local routeState = p2.routeState
	React.useEffect(function()
		if routeState == nil then
			return
		end

		local store = SplitPaneStore.getStore()
		local function fn(p3, p4)
			return routeIdentityMatches(routeState, p3, p4)
		end

		local key = routeState.key
		store.setSupportPaneTopRouteMatcher(fn)
		store.setSupportPaneTopRouteKey(key)
		return function()
			if store.getSupportPaneTopRouteMatcher(false) == fn then
				store.setSupportPaneTopRouteMatcher(nil)
			end

			if store.getSupportPaneTopRouteKey(false) == key then
				store.setSupportPaneTopRouteKey(nil)
			end
		end
	end, { routeState })
	return nil
end

return SupportPaneTopRoutePublisher
