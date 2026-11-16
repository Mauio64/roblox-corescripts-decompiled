local parent = script:FindFirstAncestor("ExpChat").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatDictationStateStore = SharedFlags.FFlagExpChatDictationStateStore

return game:DefineFastFlag("ExpChatDictationStopOnRateLimit", false) and FFlagExpChatDictationStateStore
