local Parent = script:FindFirstAncestor("GameInvite").Parent
local scriptParent = script.Parent
local UserReducer = require(Parent.UserLib).Reducers.UserReducer
local Rodux = require(Parent.Rodux)
local FFlagUseSignalsForGameInvitesStatus = require(Parent.SharedFlags).FFlagUseSignalsForGameInvitesStatus
local LegacyFriendsRodux = require(Parent.LegacyFriendsRodux)
local ReducerDependencies = require(Parent.NotificationsCommon).ReducerDependencies
local FriendCount = LegacyFriendsRodux.Reducers.FriendCount
local Invites = require(scriptParent.Invites)
local RoduxNetworking = ReducerDependencies.RoduxNetworking
local ShareLinksRodux = ReducerDependencies.ShareLinksRodux
local v12 = RoduxNetworking.installReducer()
local v13 = ShareLinksRodux.installReducer()

return Rodux.combineReducers({
	FriendCount = FriendCount,
	GameInvitesStatus = if not FFlagUseSignalsForGameInvitesStatus then Invites else nil,
	Users = UserReducer,
	ShareLinks = v13,
	NetworkStatus = v12
})
