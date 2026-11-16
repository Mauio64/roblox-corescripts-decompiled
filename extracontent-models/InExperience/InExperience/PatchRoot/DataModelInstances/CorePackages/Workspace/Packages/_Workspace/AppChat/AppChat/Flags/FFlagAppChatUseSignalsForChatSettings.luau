local AppChat = script:FindFirstAncestor("AppChat")
local FFlagAppChatSignalsActionHandlers = require(AppChat.Flags.FFlagAppChatSignalsActionHandlers)

return game:DefineFastFlag("AppChatUseSignalsForChatSettings", false) and FFlagAppChatSignalsActionHandlers
