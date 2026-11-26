require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Types")
local RecipientSource = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/RecipientSource")
local createChatInboxRecipientList = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Sources/createChatInboxRecipientList")
local createOneToOneFriendsRecipientList = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Sources/createOneToOneFriendsRecipientList")

return {
	[RecipientSource.RecipientSource.ChatInbox] = createChatInboxRecipientList,
	[RecipientSource.RecipientSource.OneToOneFriends] = createOneToOneFriendsRecipientList
}
