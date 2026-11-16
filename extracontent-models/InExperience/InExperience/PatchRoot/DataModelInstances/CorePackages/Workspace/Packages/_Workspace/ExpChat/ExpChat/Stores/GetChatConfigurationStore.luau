local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createChatConfigurationStore = require(script.createChatConfigurationStore)

return Signals.createComputed(createChatConfigurationStore)
