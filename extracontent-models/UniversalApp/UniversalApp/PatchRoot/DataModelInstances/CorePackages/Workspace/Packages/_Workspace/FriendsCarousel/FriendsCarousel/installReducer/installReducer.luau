local FriendsCarousel = script:FindFirstAncestor("FriendsCarousel")
local dependencies = require(FriendsCarousel.dependencies)
local Rodux = dependencies.Rodux
local RoduxNetworking = dependencies.RoduxNetworking
local RoduxUserPermissions = dependencies.RoduxUserPermissions
local RoduxAnalytics = dependencies.RoduxAnalytics
local Users = require(script.Parent.Users)
local Friends = require(script.Parent.Friends)
local Presence = require(script.Parent.Presence)
local ShowContactImporterParams = dependencies.ShowContactImporterParams

return function() -- line: 15
	-- upvalues: Rodux (copy), Users (copy), Friends (copy), Presence (copy), RoduxUserPermissions (copy), RoduxNetworking (copy), ShowContactImporterParams (copy), RoduxAnalytics (copy)
	return Rodux.combineReducers({
		Users = Users,
		Friends = Friends,
		Presence = Presence,
		UserPermissions = RoduxUserPermissions.installReducer(),
		NetworkStatus = RoduxNetworking.installReducer(),
		ShowContactImporterParams = ShowContactImporterParams,
		Analytics = RoduxAnalytics.installReducer()
	})
end
