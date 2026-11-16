local AppChat = script:FindFirstAncestor("AppChat")

local FFlagAppChatResolveShareLinkV2 = require(AppChat.Flags.FFlagAppChatResolveShareLinkV2)

return game:DefineFastFlag("AppChatMomentShareCard", false) and FFlagAppChatResolveShareLinkV2
