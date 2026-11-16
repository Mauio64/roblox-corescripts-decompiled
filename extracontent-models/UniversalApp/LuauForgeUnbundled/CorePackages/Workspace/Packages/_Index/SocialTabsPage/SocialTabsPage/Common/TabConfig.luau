local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/RobloxAppEnums").AppPage

local v5 = {
	id = appPage.SocialTabsFriends,
	tabLabelKey = "CommonUI.Features.Label.Friends",
	getScreen = function()
		return require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Components/TabContent/FriendsTabContent")
	end
}

local v6 = {
	id = appPage.SocialTabsMutuals,
	tabLabelKey = "Feature.Friends.Mutuals",
	getScreen = function()
		return require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Components/TabContent/MutualsTabContent")
	end
}

return {
	Friends = v5,
	Mutuals = v6,
	routeOrder = { v5, v6 }
}
