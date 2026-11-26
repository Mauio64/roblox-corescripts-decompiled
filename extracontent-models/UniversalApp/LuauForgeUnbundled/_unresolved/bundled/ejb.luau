return {
	installReducer = require("@luauforge/bundled/ejc"),
	RODUX_KEY = require("@luauforge/bundled/ejh"),
	AddFriendsSelector = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Common/getDeepValue"),
	Actions = { ContactImporterWarningSeen = require("@luauforge/bundled/ejy") },
	contactImporterWarning = require("@luauforge/bundled/ejz"),
	IsUserFollowing = require("@luauforge/bundled/ejv"),
	RequestsFromOriginSourceType = require("@game/CorePackages/Packages/_Index/RoduxFriends/RoduxFriends/Reducers/Friends/requests/originSourceType"),
	RoduxAnalytics = require("@luauforge/bundled/ejo"),
	RoduxFriends = require("@luauforge/bundled/ejm"),
	RoduxGames = require("@luauforge/bundled/ejk"),
	RoduxPresence = require("@luauforge/bundled/ejC"),
	RoduxUsers = require("@luauforge/bundled/ejD"),
	Networking = {
		FriendsNetworking = require("@luauforge/bundled/ejt"),
		myRoduxNetworking = require("@luauforge/bundled/eje")
	}
}
