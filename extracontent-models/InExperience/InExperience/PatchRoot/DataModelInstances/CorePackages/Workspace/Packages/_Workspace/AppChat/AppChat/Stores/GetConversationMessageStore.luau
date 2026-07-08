local Parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(Parent.Signals)
local createConversationMessageStore = require(script.createConversationMessageStore)

return Signals.createComputed(createConversationMessageStore)
