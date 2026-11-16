local userReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/UserLib").Reducers.UserReducer
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Rodux")
local fFlagUseSignalsForGameInvitesStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SharedFlags").FFlagUseSignalsForGameInvitesStatus
local fFlagRemoveUnusedFriendCountRoduxSlice = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SharedFlags").FFlagRemoveUnusedFriendCountRoduxSlice
local LegacyFriendsRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/LegacyFriendsRodux")
local reducerDependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/NotificationsCommon").ReducerDependencies

local friendCount = LegacyFriendsRodux.Reducers.FriendCount

local Invites = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/State/Reducers/Invites")

local roduxNetworking = reducerDependencies.RoduxNetworking
local shareLinksRodux = reducerDependencies.ShareLinksRodux
local v5 = roduxNetworking.installReducer()
local v6 = shareLinksRodux.installReducer()

local combineReducers = Rodux.combineReducers

if fFlagRemoveUnusedFriendCountRoduxSlice then
	friendCount = nil
end

if fFlagUseSignalsForGameInvitesStatus then
	Invites = nil
end

return combineReducers({
	FriendCount = friendCount,
	GameInvitesStatus = Invites,
	Users = userReducer,
	ShareLinks = v6,
	NetworkStatus = v5
})
