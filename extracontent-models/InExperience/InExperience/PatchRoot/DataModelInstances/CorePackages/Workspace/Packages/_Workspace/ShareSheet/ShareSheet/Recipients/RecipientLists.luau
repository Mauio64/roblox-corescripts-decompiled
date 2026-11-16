local ShareSheet = script:FindFirstAncestor("ShareSheet")

require(ShareSheet.Types)
local RecipientSource = require(script.Parent.RecipientSource)
local createChatInboxRecipientList = require(ShareSheet.Recipients.Sources.createChatInboxRecipientList)
local createOneToOneFriendsRecipientList = require(ShareSheet.Recipients.Sources.createOneToOneFriendsRecipientList)

return {
	[RecipientSource.RecipientSource.ChatInbox] = createChatInboxRecipientList,
	[RecipientSource.RecipientSource.OneToOneFriends] = createOneToOneFriendsRecipientList
}
