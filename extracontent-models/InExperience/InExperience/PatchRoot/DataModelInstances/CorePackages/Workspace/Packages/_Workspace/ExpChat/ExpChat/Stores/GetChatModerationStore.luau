local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createChatModerationStore = require(script.createChatModerationStore)

return Signals.createComputed(createChatModerationStore)
