local Parent = script:FindFirstAncestor("GameInvite").Parent
local scriptParent = script.Parent
local UserReducer = require(Parent.UserLib).Reducers.UserReducer
local Rodux = require(Parent.Rodux)
local LegacyFriendsRodux = require(Parent.LegacyFriendsRodux)
local ReducerDependencies = require(Parent.NotificationsCommon).ReducerDependencies
local FriendCount = LegacyFriendsRodux.Reducers.FriendCount
local Invites = require(scriptParent.Invites)
local RoduxNetworking = ReducerDependencies.RoduxNetworking
local ShareLinksRodux = ReducerDependencies.ShareLinksRodux
local v11 = RoduxNetworking.installReducer()
local v12 = ShareLinksRodux.installReducer()

return Rodux.combineReducers({
	FriendCount = FriendCount,
	GameInvitesStatus = Invites,
	Users = UserReducer,
	ShareLinks = v12,
	NetworkStatus = v11
})
