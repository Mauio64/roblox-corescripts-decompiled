local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local createChatWindowStatusStore = require(script.createChatWindowStatusStore)

return Signals.createComputed(createChatWindowStatusStore)
