local Parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(Parent.Signals)
local createMomentsPreferencesStore = require(script.createMomentsPreferencesStore)

return Signals.createComputed(function(_) -- line: 14
	-- upvalues: createMomentsPreferencesStore (copy)
	return createMomentsPreferencesStore()
end)
