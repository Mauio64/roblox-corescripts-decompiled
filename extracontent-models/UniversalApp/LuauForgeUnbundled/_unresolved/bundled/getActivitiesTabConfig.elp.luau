local appPage = require("@luauforge/bundled/elq").AppPage

local function getActivitiesTabConfig()
	return {
		id = appPage.FriendsActivityFeed,
		textKey = "Feature.Friends.Heading.Activities",
		getScreen = function()
			return require("@luauforge/deferred/ejQ")
		end
	}
end

return getActivitiesTabConfig
