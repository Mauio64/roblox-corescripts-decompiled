local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local AppPage = require(SocialTabsPageParent.RobloxAppEnums).AppPage
local t1 = {
	tabLabelKey = "CommonUI.Features.Label.Friends",
	id = AppPage.SocialTabsFriends,
	getScreen = function() -- line: 10
		-- upvalues: SocialTabsPage (copy)
		return require(SocialTabsPage.Components.TabContent.FriendsTabContent)
	end
}
local t2 = {
	tabLabelKey = "Feature.Friends.Mutuals",
	id = AppPage.SocialTabsMutuals,
	getScreen = function() -- line: 18
		-- upvalues: SocialTabsPage (copy)
		return require(SocialTabsPage.Components.TabContent.MutualsTabContent)
	end
}

return {
	Friends = t1,
	Mutuals = t2,
	routeOrder = {
		t1,
		t2
	}
}
