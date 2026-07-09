local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local createMessagesStore = require(script.createMessagesStore)

return Signals.createComputed(createMessagesStore)
