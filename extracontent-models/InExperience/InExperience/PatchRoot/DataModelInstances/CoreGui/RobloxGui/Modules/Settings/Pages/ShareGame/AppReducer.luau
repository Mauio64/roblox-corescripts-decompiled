local CorePackages = game:GetService("CorePackages")

local CoreGui = game:GetService("CoreGui")
local ShareGame = CoreGui.RobloxGui.Modules.Settings.Pages.ShareGame
local NotificationsCommon = require(CorePackages.Workspace.Packages.NotificationsCommon)
local ReducerDependencies = NotificationsCommon.ReducerDependencies

local PlaceInfoRodux = require(CorePackages.Workspace.Packages.PlaceInfoRodux)
local PlaceInfosReducer = PlaceInfoRodux.Reducers.PlaceInfosReducer
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local UserReducer = UserLib.Reducers.UserReducer
local LegacyFriendsRodux = require(CorePackages.Workspace.Packages.LegacyFriendsRodux)
local Friends = LegacyFriendsRodux.Reducers.Friends
local LegacyFriendsRodux2 = require(CorePackages.Workspace.Packages.LegacyFriendsRodux)
local FriendCount = LegacyFriendsRodux2.Reducers.FriendCount

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagRemoveUnusedFriendCountRoduxSlice = SharedFlags.FFlagRemoveUnusedFriendCountRoduxSlice

local ConversationsSearch = require(ShareGame.Reducers.ConversationsSearch)
local DeviceInfo = require(ShareGame.Reducers.DeviceInfo)
local Invites = require(ShareGame.Reducers.Invites)
local GameInfo = require(ShareGame.Reducers.GameInfo)
local Page = require(ShareGame.Reducers.Page)
local Toasts = require(ShareGame.Reducers.Toasts)

local ShareLinksRodux = ReducerDependencies.ShareLinksRodux
local v = ReducerDependencies.RoduxNetworking.installReducer()
local v2 = ShareLinksRodux.installReducer()

return function(options, p)
	local v3 = options or {}

	local v4 = {
		ConversationsSearch = ConversationsSearch(v3.ConversationsSearch, p),
		DeviceInfo = DeviceInfo(v3.DeviceInfo, p),
		Invites = Invites(v3.Invites, p),
		Page = Page(v3.Page, p),
		PlaceInfos = PlaceInfosReducer(v3.PlaceInfos, p),
		Toasts = Toasts(v3.Toasts, p),
		Users = UserReducer(v3.Users, p),
		Friends = Friends(v3.Friends, p),
		FriendCount = 0,
		ShareLinks = 0,
		GameInfo = 0,
		NetworkStatus = 0
	}
	local friendCount

	if not FFlagRemoveUnusedFriendCountRoduxSlice then
		friendCount = FriendCount(v3.FriendCount, p)
	end

	v4.FriendCount = friendCount
	v4.ShareLinks = v2(v3.ShareLinks, p)
	v4.GameInfo = GameInfo(v3.GameInfo, p)
	v4.NetworkStatus = v(v3.NetworkStatus, p)
	return v4
end
