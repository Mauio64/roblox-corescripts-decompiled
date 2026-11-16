local parent = script:FindFirstAncestor("AppChat").Parent

local Signals = require(parent.Signals)

local createConversationMessageStore = require(script.createConversationMessageStore)

return Signals.createComputed(createConversationMessageStore)
