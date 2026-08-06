local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local Rodux = dependencies.Rodux
local RoduxNetworking = dependencies.RoduxNetworking
local FFlagFriendsLandingDeprecateUnusedMapToUsers = require(FriendsLanding.Flags.FFlagFriendsLandingDeprecateUnusedMapToUsers)

return function() -- line: 10
	-- upvalues: Rodux (copy), FFlagFriendsLandingDeprecateUnusedMapToUsers (copy), dependencies (copy), RoduxNetworking (copy)
	return Rodux.combineReducers({
		DeletedUsers = if not FFlagFriendsLandingDeprecateUnusedMapToUsers then require(script.DeletedUsers) else nil,
		VerifiedUsers = if not FFlagFriendsLandingDeprecateUnusedMapToUsers then require(script.VerifiedUsers) else nil,
		InactiveFriends = if not FFlagFriendsLandingDeprecateUnusedMapToUsers then require(script.InactiveFriends) else nil,
		Users = if not FFlagFriendsLandingDeprecateUnusedMapToUsers then require(script.Users) else nil,
		Friends = require(script.Friends)(),
		Presence = if not FFlagFriendsLandingDeprecateUnusedMapToUsers then require(script.Presence) else nil,
		UserPermissions = if not FFlagFriendsLandingDeprecateUnusedMapToUsers then dependencies.RoduxUserPermissions.installReducer() else nil,
		NetworkStatus = RoduxNetworking.installReducer(),
		Analytics = if not FFlagFriendsLandingDeprecateUnusedMapToUsers then dependencies.RoduxAnalytics.installReducer() else nil
	})
end
