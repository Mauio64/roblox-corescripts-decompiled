local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createChatWindowStatusStore = require(script.createChatWindowStatusStore)

return Signals.createComputed(createChatWindowStatusStore)
