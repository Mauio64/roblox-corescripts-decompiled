local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local Rodux = dependencies.Rodux
local RoduxNetworking = dependencies.RoduxNetworking
local RoduxUserPermissions = dependencies.RoduxUserPermissions
local RoduxAnalytics = dependencies.RoduxAnalytics

return function() -- line: 9
	-- upvalues: Rodux (copy), RoduxUserPermissions (copy), RoduxNetworking (copy), RoduxAnalytics (copy)
	return Rodux.combineReducers({
		DeletedUsers = require(script.DeletedUsers),
		VerifiedUsers = require(script.VerifiedUsers),
		InactiveFriends = require(script.InactiveFriends),
		Users = require(script.Users),
		Friends = require(script.Friends)(),
		Presence = require(script.Presence),
		UserPermissions = RoduxUserPermissions.installReducer(),
		NetworkStatus = RoduxNetworking.installReducer(),
		Analytics = RoduxAnalytics.installReducer()
	})
end
