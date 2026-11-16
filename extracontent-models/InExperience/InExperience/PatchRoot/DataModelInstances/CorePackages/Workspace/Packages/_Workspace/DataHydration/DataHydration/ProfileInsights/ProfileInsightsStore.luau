local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createProfileInsightsStore = require(script.Parent.createProfileInsightsStore)

local computed = Signals.createComputed(function()
	return createProfileInsightsStore()
end)

return {
	get = function()
		return computed(false)
	end
}
