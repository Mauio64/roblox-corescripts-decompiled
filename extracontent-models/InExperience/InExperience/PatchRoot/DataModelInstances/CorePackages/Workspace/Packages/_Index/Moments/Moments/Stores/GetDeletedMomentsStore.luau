local parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(parent.Signals)
local createDeletedMomentsStore = require(script.createDeletedMomentsStore)

return Signals.createComputed(function()
	return createDeletedMomentsStore()
end)
