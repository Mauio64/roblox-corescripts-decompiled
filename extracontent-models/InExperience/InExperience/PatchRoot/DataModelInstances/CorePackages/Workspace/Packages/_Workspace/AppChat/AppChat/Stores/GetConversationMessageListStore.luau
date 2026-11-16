local parent = script:FindFirstAncestor("AppChat").Parent

local Signals = require(parent.Signals)

local createConversationMessageListStore = require(script.createConversationMessageListStore)

return Signals.createComputed(createConversationMessageListStore)
