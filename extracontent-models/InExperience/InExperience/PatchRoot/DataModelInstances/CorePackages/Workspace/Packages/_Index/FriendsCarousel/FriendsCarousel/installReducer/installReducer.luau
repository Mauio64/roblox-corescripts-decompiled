local FriendsCarousel = script:FindFirstAncestor("FriendsCarousel")
local FriendsCarouselParent = FriendsCarousel.Parent
local dependencies = require(FriendsCarousel.dependencies)
local Rodux = dependencies.Rodux
local RoduxNetworking = dependencies.RoduxNetworking
local RoduxUserPermissions = dependencies.RoduxUserPermissions
local RoduxAnalytics = dependencies.RoduxAnalytics
local Users = require(script.Parent.Users)
local Friends = require(script.Parent.Friends)
local Presence = require(script.Parent.Presence)
local ShowContactImporterParams = dependencies.ShowContactImporterParams
local FFlagFriendsCarouselDeprecateUnusedReducers = require(FriendsCarouselParent.SharedFlags).FFlagFriendsCarouselDeprecateUnusedReducers

return function() -- line: 19
	-- upvalues: Rodux (copy), FFlagFriendsCarouselDeprecateUnusedReducers (copy), Users (copy), Friends (copy), Presence (copy), RoduxUserPermissions (copy), RoduxNetworking (copy), ShowContactImporterParams (copy), RoduxAnalytics (copy)
	return Rodux.combineReducers({
		Users = if not FFlagFriendsCarouselDeprecateUnusedReducers then Users else nil,
		Friends = Friends,
		Presence = if not FFlagFriendsCarouselDeprecateUnusedReducers then Presence else nil,
		UserPermissions = if not FFlagFriendsCarouselDeprecateUnusedReducers then RoduxUserPermissions.installReducer() else nil,
		NetworkStatus = RoduxNetworking.installReducer(),
		ShowContactImporterParams = if not FFlagFriendsCarouselDeprecateUnusedReducers then ShowContactImporterParams else nil,
		Analytics = if not FFlagFriendsCarouselDeprecateUnusedReducers then RoduxAnalytics.installReducer() else nil
	})
end
