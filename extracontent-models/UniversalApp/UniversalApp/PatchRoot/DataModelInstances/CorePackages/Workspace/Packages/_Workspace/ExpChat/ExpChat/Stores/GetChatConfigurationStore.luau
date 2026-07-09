local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local createChatConfigurationStore = require(script.createChatConfigurationStore)

return Signals.createComputed(createChatConfigurationStore)
