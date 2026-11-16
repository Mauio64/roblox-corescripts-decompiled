local parent = script:FindFirstAncestor("DictationCore").Parent
local Signals = require(parent.Signals)
local createMicStore = require(script.createMicStore)

return Signals.createComputed(function()
	return createMicStore()
end)
