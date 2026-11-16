local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local parent = SocialTabsPage.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local friends = {
	id = AppPage.SocialTabsFriends,
	tabLabelKey = "CommonUI.Features.Label.Friends",
	getScreen = function()
		return require(SocialTabsPage.Components.TabContent.FriendsTabContent)
	end
}

local mutuals = {
	id = AppPage.SocialTabsMutuals,
	tabLabelKey = "Feature.Friends.Mutuals",
	getScreen = function()
		return require(SocialTabsPage.Components.TabContent.MutualsTabContent)
	end
}

return {
	Friends = friends,
	Mutuals = mutuals,
	routeOrder = { friends, mutuals }
}
