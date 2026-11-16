local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createChatStatusStore = require(script.createChatStatusStore)

return Signals.createComputed(createChatStatusStore)
