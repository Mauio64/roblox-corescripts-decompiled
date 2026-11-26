local Rodux = require("@game/CorePackages/Workspace/Packages/Rodux")

return function()
	return Rodux.combineReducers({
		NetworkStatus = require("@luauforge/bundled/eje").installReducer(),
		Games = require("@luauforge/bundled/ejk").installReducer(),
		Friends = require("@luauforge/bundled/ejm").installReducer(),
		Analytics = require("@luauforge/bundled/ejo").installReducer(),
		RequestsFromOriginSourceType = require("@game/CorePackages/Packages/_Index/RoduxFriends/RoduxFriends/Reducers/Friends/requests/originSourceType"),
		IsUserFollowing = require("@luauforge/bundled/ejv")
	})
end
