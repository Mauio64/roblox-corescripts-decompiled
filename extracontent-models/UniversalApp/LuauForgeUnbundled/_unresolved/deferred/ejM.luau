local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage

local fFlagFriendsActivityFeedEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFriendsActivityFeedEnabled

local v5 = {
	{
		id = appPage.CoHubAddConnections,
		textKey = "Feature.AddFriends.Heading.AddFriends",
		getScreen = function()
			return require("@luauforge/deferred/eeK")
		end
	},
	{
		id = appPage.CoHubMyConnections,
		textKey = "Feature.Friends.Heading.Friends",
		getScreen = function()
			return require("@luauforge/deferred/dYO")
		end
	}
}

if fFlagFriendsActivityFeedEnabled then
	table.insert(v5, require("@luauforge/deferred/ejN").getActivitiesTabConfig())
end

return v5
