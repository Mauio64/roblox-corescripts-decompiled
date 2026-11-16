local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createChatLayoutStore = require(script.createChatLayoutStore)

return Signals.createComputed(createChatLayoutStore)
