local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createPresetChatStore = require(script.createPresetChatStore)

return Signals.createComputed(createPresetChatStore)
