local AppChat = script:FindFirstAncestor("AppChat")

local FFlagAppChatResolveShareLinkV2 = require(AppChat.Flags.FFlagAppChatResolveShareLinkV2)

return game:DefineFastFlag("AppChatShareLinkV2Fallbacks", false) and FFlagAppChatResolveShareLinkV2
