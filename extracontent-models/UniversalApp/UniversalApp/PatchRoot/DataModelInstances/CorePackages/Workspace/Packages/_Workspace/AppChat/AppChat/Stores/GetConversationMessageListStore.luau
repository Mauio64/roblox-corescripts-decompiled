local Parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(Parent.Signals)
local createConversationMessageListStore = require(script.createConversationMessageListStore)

return Signals.createComputed(createConversationMessageListStore)
