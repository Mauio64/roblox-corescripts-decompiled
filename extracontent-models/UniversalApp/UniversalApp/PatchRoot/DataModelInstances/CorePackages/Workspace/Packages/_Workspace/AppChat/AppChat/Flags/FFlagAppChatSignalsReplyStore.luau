local AppChat = script:FindFirstAncestor("AppChat")
local FFlagAppChatSignalsMessageStore = require(AppChat.Flags.FFlagAppChatSignalsMessageStore)

return game:DefineFastFlag("AppChatSignalsReplyStore", false) and FFlagAppChatSignalsMessageStore
