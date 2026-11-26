local SplitPaneStore = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/SplitPaneStore")

local function isSupportPaneTopRoute(p2, p3)
	local supportPaneTopRouteMatcher = SplitPaneStore.getStore().getSupportPaneTopRouteMatcher(false)
	return supportPaneTopRouteMatcher ~= nil and supportPaneTopRouteMatcher(p2, p3)
end

return isSupportPaneTopRoute
