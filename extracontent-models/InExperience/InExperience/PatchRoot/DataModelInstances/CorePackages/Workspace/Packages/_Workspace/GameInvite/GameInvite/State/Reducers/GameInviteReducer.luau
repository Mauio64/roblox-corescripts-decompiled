local parent = script:FindFirstAncestor("GameInvite").Parent
local parent2 = script.Parent
local UserLib = require(parent.UserLib)
local UserReducer = UserLib.Reducers.UserReducer
local Rodux = require(parent.Rodux)
local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForGameInvitesStatus = SharedFlags.FFlagUseSignalsForGameInvitesStatus
local SharedFlags2 = require(parent.SharedFlags)
local FFlagRemoveUnusedFriendCountRoduxSlice = SharedFlags2.FFlagRemoveUnusedFriendCountRoduxSlice
local LegacyFriendsRodux = require(parent.LegacyFriendsRodux)
local NotificationsCommon = require(parent.NotificationsCommon)
local ReducerDependencies = NotificationsCommon.ReducerDependencies

local FriendCount = LegacyFriendsRodux.Reducers.FriendCount

local Invites = require(parent2.Invites)

local RoduxNetworking = ReducerDependencies.RoduxNetworking
local ShareLinksRodux = ReducerDependencies.ShareLinksRodux
local networkStatus = RoduxNetworking.installReducer()
local shareLinks = ShareLinksRodux.installReducer()

local combineReducers = Rodux.combineReducers

if FFlagRemoveUnusedFriendCountRoduxSlice then
	FriendCount = nil
end

if FFlagUseSignalsForGameInvitesStatus then
	Invites = nil
end

return combineReducers({
	FriendCount = FriendCount,
	GameInvitesStatus = Invites,
	Users = UserReducer,
	ShareLinks = shareLinks,
	NetworkStatus = networkStatus
})
