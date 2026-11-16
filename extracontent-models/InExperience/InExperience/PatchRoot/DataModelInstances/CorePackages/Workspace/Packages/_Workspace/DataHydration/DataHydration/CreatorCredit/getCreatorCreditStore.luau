local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createCreatorCreditStore = require(script.Parent.createCreatorCreditStore)
require(script.Parent.types)

local function createDefaultStore()
	return createCreatorCreditStore()
end

return Signals.createComputed(createDefaultStore)
