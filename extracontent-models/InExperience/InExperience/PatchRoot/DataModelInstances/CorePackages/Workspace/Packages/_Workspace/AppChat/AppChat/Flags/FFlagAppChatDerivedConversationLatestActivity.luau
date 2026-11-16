local AppChat = script:FindFirstAncestor("AppChat")
local FFlagAppChatSignalsMessageStore = require(AppChat.Flags.FFlagAppChatSignalsMessageStore)

return game:DefineFastFlag("AppChatDerivedConversationLatestActivity", false) and FFlagAppChatSignalsMessageStore
