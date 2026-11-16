local parent = script:FindFirstAncestor("SplitPane").Parent

local React = require(parent.React)

local SplitPaneStore = require(script.Parent.Parent.Stores.SplitPaneStore)
local routeIdentityMatches = require(script.Parent.Parent.Utils.routeIdentityMatches)

local function SupportPaneTopRoutePublisher(p): nil
	local routeState = p.routeState
	React.useEffect(function()
		if routeState == nil then
			return
		end

		local store = SplitPaneStore.getStore()
		local function fn(p2: string, p3)
			return routeIdentityMatches(routeState, p2, p3)
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
