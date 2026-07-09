local FriendsActivityFeed = script:FindFirstAncestor("FriendsActivityFeed")
local FriendsActivityFeedParent = FriendsActivityFeed.Parent
local AppPage = require(FriendsActivityFeedParent.RobloxAppEnums).AppPage

local function getActivitiesTabConfig() -- line: 13
	-- upvalues: AppPage (copy), FriendsActivityFeed (copy)
	return {
		textKey = "Feature.Friends.Heading.Activities",
		id = AppPage.FriendsActivityFeed,
		getScreen = function() -- line: 17
			-- upvalues: FriendsActivityFeed (copy)
			return require(FriendsActivityFeed.Components.FriendsActivityFeed)
		end
	}
end

return getActivitiesTabConfig
