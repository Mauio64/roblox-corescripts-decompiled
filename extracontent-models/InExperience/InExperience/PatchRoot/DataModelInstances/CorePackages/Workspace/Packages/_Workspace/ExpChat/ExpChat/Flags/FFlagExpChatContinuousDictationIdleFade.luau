local parent = script:FindFirstAncestor("ExpChat").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatContinuousListeningChatIconDot = SharedFlags.FFlagExpChatContinuousListeningChatIconDot

return game:DefineFastFlag("ExpChatContinuousDictationIdleFade", false) and FFlagExpChatContinuousListeningChatIconDot
