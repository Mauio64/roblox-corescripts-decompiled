local module = require("@luauforge/bundled/efm")
local Rodux = require("@game/CorePackages/Workspace/Packages/Rodux")

local fFlagAddFriendsDeprecateUnusedReducers = require("@luauforge/bundled/efo").FFlagAddFriendsDeprecateUnusedReducers

return function()
	local combineReducers = Rodux.combineReducers
	local v5 = {
		NetworkStatus = require("@luauforge/bundled/efp").installReducer(),
		Games = require("@luauforge/bundled/efv").installReducer(),
		Friends = require("@luauforge/bundled/efx").installReducer(),
		Users = 0,
		Analytics = 0,
		ShowContactImporterParams = 0,
		RequestsFromOriginSourceType = 0,
		ContactImporterWarning = 0,
		IsUserFollowing = 0
	}

	local v6 = if not fFlagAddFriendsDeprecateUnusedReducers then require("@luauforge/bundled/efz").installReducer() else nil
	v5.Users = v6

	v5.Analytics = require("@luauforge/bundled/efB").installReducer()

	local v7 = if not fFlagAddFriendsDeprecateUnusedReducers then module.ShowContactImporterParams else nil
	v5.ShowContactImporterParams = v7

	v5.RequestsFromOriginSourceType = require("@game/CorePackages/Packages/_Index/RoduxFriends/RoduxFriends/Reducers/Friends/requests/originSourceType")

	local v8 = if not fFlagAddFriendsDeprecateUnusedReducers then require("@luauforge/bundled/efI") else nil
	v5.ContactImporterWarning = v8

	v5.IsUserFollowing = require("@luauforge/bundled/efM")
	return combineReducers(v5)
end
