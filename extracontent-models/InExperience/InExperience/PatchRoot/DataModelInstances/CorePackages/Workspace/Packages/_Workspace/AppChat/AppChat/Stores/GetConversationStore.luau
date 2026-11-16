local parent = script:FindFirstAncestor("AppChat").Parent

local Signals = require(parent.Signals)

local createConversationStore = require(script.createConversationStore)

return Signals.createComputed(createConversationStore)
