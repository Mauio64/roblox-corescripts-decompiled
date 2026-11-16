local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createDictationModeSettingStore = require(script.createDictationModeSettingStore)

return Signals.createComputed(function()
	return createDictationModeSettingStore()
end)
