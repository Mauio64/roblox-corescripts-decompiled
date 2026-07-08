local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local createChatModerationStore = require(script.createChatModerationStore)

return Signals.createComputed(createChatModerationStore)
