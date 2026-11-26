local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage

local fFlagFriendsActivityFeedEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFriendsActivityFeedEnabled

local v5 = {
	{
		id = appPage.CoHubAddConnections,
		textKey = "Feature.AddFriends.Heading.AddFriends",
		getScreen = function()
			return require("@luauforge/deferred/eih")
		end
	},
	{
		id = appPage.CoHubMyConnections,
		textKey = "Feature.Friends.Heading.Friends",
		getScreen = function()
			return require("@luauforge/deferred/ecl")
		end
	}
}

if fFlagFriendsActivityFeedEnabled then
	table.insert(v5, require("@luauforge/deferred/enj").getActivitiesTabConfig())
end

return v5
