local appPage = require("@luauforge/bundled/eoM").AppPage

local function getActivitiesTabConfig()
	return {
		id = appPage.FriendsActivityFeed,
		textKey = "Feature.Friends.Heading.Activities",
		getScreen = function()
			return require("@luauforge/deferred/enm")
		end
	}
end

return getActivitiesTabConfig
