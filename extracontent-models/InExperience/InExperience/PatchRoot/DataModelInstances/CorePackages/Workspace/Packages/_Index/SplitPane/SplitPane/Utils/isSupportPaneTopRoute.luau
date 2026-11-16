local SplitPaneStore = require(script.Parent.Parent.Stores.SplitPaneStore)

local function isSupportPaneTopRoute(p: string, p2)
	local supportPaneTopRouteMatcher = SplitPaneStore.getStore().getSupportPaneTopRouteMatcher(false)
	return supportPaneTopRouteMatcher ~= nil and supportPaneTopRouteMatcher(p, p2)
end

return isSupportPaneTopRoute
