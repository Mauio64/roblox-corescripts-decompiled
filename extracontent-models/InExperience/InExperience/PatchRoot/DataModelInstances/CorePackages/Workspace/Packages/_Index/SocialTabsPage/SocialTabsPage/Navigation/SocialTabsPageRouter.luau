local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local t1 = {}

for _, v4 in require(SocialTabsPage.Common.TabConfig).routeOrder do
	table.insert(t1, {
		[v4.id] = {
			getScreen = v4.getScreen
		}
	})
end

return t1
