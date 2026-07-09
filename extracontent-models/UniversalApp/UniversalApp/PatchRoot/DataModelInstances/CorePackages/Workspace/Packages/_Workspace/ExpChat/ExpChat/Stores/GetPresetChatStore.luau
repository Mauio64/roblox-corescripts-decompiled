local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local createPresetChatStore = require(script.createPresetChatStore)

return Signals.createComputed(createPresetChatStore)
