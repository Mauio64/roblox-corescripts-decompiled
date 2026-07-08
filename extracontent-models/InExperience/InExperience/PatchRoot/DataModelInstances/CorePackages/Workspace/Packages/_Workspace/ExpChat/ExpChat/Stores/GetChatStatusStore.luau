local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local createChatStatusStore = require(script.createChatStatusStore)

return Signals.createComputed(createChatStatusStore)
