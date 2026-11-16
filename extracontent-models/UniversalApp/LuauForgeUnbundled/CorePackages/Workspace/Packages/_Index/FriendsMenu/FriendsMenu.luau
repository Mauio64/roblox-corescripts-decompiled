local FFlagUpdateInvitesToUsePaginatedFriends = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Flags/FFlagUpdateInvitesToUsePaginatedFriends")

local v5 = {
	FriendsListContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/FriendsListContext"),
	FriendsMenuContextWrapper = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/FriendsMenuContextWrapper"),
	FriendsMenuFriendsList = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Components/FriendsMenuFriendsList"),
	FriendsMenuSearch = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Components/FriendsMenuSearch"),
	FriendsMenuShareGameInviteLink = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Components/FriendsMenuShareGameInviteLink"),
	InviteFriendContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/InviteFriendContext"),
	InviteCallbackContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/InviteCallbackContext"),
	FriendsListContextProvider = 0,
	InviteStatus = 0,
	FriendMenuType = 0,
	SelectedUsersContext = 0,
	SelectedUsersScroller = 0
}

local v6 = if FFlagUpdateInvitesToUsePaginatedFriends then require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/FriendsListContextProvider2") else require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/FriendsListContextProvider")
v5.FriendsListContextProvider = v6

v5.InviteStatus = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Constants").InviteStatus
v5.FriendMenuType = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Enums/FriendMenuType")
v5.SelectedUsersContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/SelectedUsersContext")
v5.SelectedUsersScroller = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Components/SelectedUsersScroller")
return v5
