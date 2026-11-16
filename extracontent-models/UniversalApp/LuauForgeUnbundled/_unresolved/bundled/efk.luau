return {
	installReducer = require("@luauforge/bundled/efl"),
	RODUX_KEY = require("@luauforge/bundled/efs"),
	AddFriendsSelector = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Common/getDeepValue"),
	Actions = { ContactImporterWarningSeen = require("@luauforge/bundled/efL") },
	contactImporterWarning = require("@luauforge/bundled/efI"),
	IsUserFollowing = require("@luauforge/bundled/efM"),
	RequestsFromOriginSourceType = require("@game/CorePackages/Packages/_Index/RoduxFriends/RoduxFriends/Reducers/Friends/requests/originSourceType"),
	RoduxAnalytics = require("@luauforge/bundled/efB"),
	RoduxFriends = require("@luauforge/bundled/efx"),
	RoduxGames = require("@luauforge/bundled/efv"),
	RoduxPresence = require("@luauforge/bundled/efO"),
	RoduxUsers = require("@luauforge/bundled/efz"),
	Networking = {
		FriendsNetworking = require("@luauforge/bundled/efG"),
		myRoduxNetworking = require("@luauforge/bundled/efp")
	}
}
