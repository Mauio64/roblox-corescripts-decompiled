local AppChat = script:FindFirstAncestor("AppChat")
local FFlagAppChatEnableTrustedFriendEntryPoint = require(AppChat.Flags.FFlagAppChatEnableTrustedFriendEntryPoint)

return game:DefineFastFlag("AppChatTrustedFriendEntryPointAnalytics", false) and FFlagAppChatEnableTrustedFriendEntryPoint
