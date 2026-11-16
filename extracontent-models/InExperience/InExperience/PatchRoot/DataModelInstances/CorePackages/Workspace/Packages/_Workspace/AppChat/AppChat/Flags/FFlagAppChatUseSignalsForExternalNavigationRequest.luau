local AppChat = script:FindFirstAncestor("AppChat")
local FFlagAppChatSignalsActionHandlers = require(AppChat.Flags.FFlagAppChatSignalsActionHandlers)

return game:DefineFastFlag("AppChatUseSignalsForExternalNavigationRequest", false) and FFlagAppChatSignalsActionHandlers
