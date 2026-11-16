local script2 = script
local FFlagUpdateInvitesToUsePaginatedFriends = require(script2.Flags.FFlagUpdateInvitesToUsePaginatedFriends)

local FriendsMenu = {
	["jest.config"] = nil,
	["jest.config"] = script["jest.config"],
	FriendsListContext = require(script.Context.FriendsListContext),
	FriendsMenuContextWrapper = require(script.Context.FriendsMenuContextWrapper),
	FriendsMenuFriendsList = require(script.Components.FriendsMenuFriendsList),
	FriendsMenuSearch = require(script.Components.FriendsMenuSearch),
	FriendsMenuShareGameInviteLink = require(script.Components.FriendsMenuShareGameInviteLink),
	InviteFriendContext = require(script.Context.InviteFriendContext),
	InviteCallbackContext = require(script.Context.InviteCallbackContext)
}
local friendsListContextProvider

if FFlagUpdateInvitesToUsePaginatedFriends then
	friendsListContextProvider = require(script.Context.FriendsListContextProvider2)
else
	friendsListContextProvider = require(script.Context.FriendsListContextProvider)
end

FriendsMenu.FriendsListContextProvider = friendsListContextProvider

local Constants = require(script.Constants)
FriendsMenu.InviteStatus = Constants.InviteStatus
FriendsMenu.FriendMenuType = require(script.Enums.FriendMenuType)
FriendsMenu.SelectedUsersContext = require(script.Context.SelectedUsersContext)
FriendsMenu.SelectedUsersScroller = require(script.Components.SelectedUsersScroller)
return FriendsMenu
