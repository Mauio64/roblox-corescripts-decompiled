local parent = script:FindFirstAncestor("ExpChat").Parent
local SharedFlags = require(parent.SharedFlags)

return game:DefineFastFlag("ExpChatGenericChatFocusRC1", false) and SharedFlags.FFlagFriendsChatConversationListFocusNav
