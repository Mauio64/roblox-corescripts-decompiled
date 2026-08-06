local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createCreatorCreditStore = require(script.Parent.createCreatorCreditStore)

require(script.Parent.types)

local function createDefaultStore() -- line: 11
	-- upvalues: createCreatorCreditStore (copy)
	return createCreatorCreditStore()
end

return Signals.createComputed(createDefaultStore)
