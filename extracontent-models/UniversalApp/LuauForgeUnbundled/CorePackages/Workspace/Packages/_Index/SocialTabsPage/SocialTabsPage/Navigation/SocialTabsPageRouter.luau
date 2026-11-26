local result = {}

for k, v5 in require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Common/TabConfig").routeOrder do
	local v6 = {
		[v5.id] = { getScreen = v5.getScreen }
	}
	table.insert(result, v6)
end

return result
