local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")

local TabConfig = require(SocialTabsPage.Common.TabConfig)

local SocialTabsPageRouter = {}

for _, v in TabConfig.routeOrder do
	local v2 = {
		[v.id] = { getScreen = v.getScreen }
	}
	table.insert(SocialTabsPageRouter, v2)
end

return SocialTabsPageRouter
