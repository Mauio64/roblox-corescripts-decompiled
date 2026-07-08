local CorePackages = game:GetService("CorePackages")
local ShareGame = game:GetService("CoreGui").RobloxGui.Modules.Settings.Pages.ShareGame
local ReducerDependencies = require(CorePackages.Workspace.Packages.NotificationsCommon).ReducerDependencies
local PlaceInfosReducer = require(CorePackages.Workspace.Packages.PlaceInfoRodux).Reducers.PlaceInfosReducer
local UserReducer = require(CorePackages.Workspace.Packages.UserLib).Reducers.UserReducer
local Friends = require(CorePackages.Workspace.Packages.LegacyFriendsRodux).Reducers.Friends
local FriendCount = require(CorePackages.Workspace.Packages.LegacyFriendsRodux).Reducers.FriendCount
local ConversationsSearch = require(ShareGame.Reducers.ConversationsSearch)
local DeviceInfo = require(ShareGame.Reducers.DeviceInfo)
local Invites = require(ShareGame.Reducers.Invites)
local GameInfo = require(ShareGame.Reducers.GameInfo)
local Page = require(ShareGame.Reducers.Page)
local Toasts = require(ShareGame.Reducers.Toasts)
local ShareLinksRodux = ReducerDependencies.ShareLinksRodux
local v15 = ReducerDependencies.RoduxNetworking.installReducer()
local v16 = ShareLinksRodux.installReducer()

return function(p1, p2) -- line: 25
	-- upvalues: ConversationsSearch (copy), DeviceInfo (copy), Invites (copy), Page (copy), PlaceInfosReducer (copy), Toasts (copy), UserReducer (copy), Friends (copy), FriendCount (copy), v16 (copy), GameInfo (copy), v15 (copy)
	local v19 = p1 or {}

	return {
		ConversationsSearch = ConversationsSearch(v19.ConversationsSearch, p2),
		DeviceInfo = DeviceInfo(v19.DeviceInfo, p2),
		Invites = Invites(v19.Invites, p2),
		Page = Page(v19.Page, p2),
		PlaceInfos = PlaceInfosReducer(v19.PlaceInfos, p2),
		Toasts = Toasts(v19.Toasts, p2),
		Users = UserReducer(v19.Users, p2),
		Friends = Friends(v19.Friends, p2),
		FriendCount = FriendCount(v19.FriendCount, p2),
		ShareLinks = v16(v19.ShareLinks, p2),
		GameInfo = GameInfo(v19.GameInfo, p2),
		NetworkStatus = v15(v19.NetworkStatus, p2)
	}
end
