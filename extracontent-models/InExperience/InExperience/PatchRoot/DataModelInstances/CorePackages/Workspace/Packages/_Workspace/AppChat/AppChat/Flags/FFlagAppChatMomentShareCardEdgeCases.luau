local AppChat = script:FindFirstAncestor("AppChat")

local FFlagAppChatMomentShareCard = require(AppChat.Flags.FFlagAppChatMomentShareCard)

return game:DefineFastFlag("AppChatMomentShareCardEdgeCases", false) and FFlagAppChatMomentShareCard
