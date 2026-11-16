local parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(parent.Signals)
local createMomentsPreferencesStore = require(script.createMomentsPreferencesStore)

return Signals.createComputed(function(_)
	return createMomentsPreferencesStore()
end)
