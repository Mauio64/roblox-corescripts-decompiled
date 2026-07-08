local Parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(Parent.Signals)
local createConversationStore = require(script.createConversationStore)

return Signals.createComputed(createConversationStore)
