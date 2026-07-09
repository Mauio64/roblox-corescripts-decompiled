local CorePackages = game:GetService("CorePackages")
local Signals = require(CorePackages.Packages.Signals)
local createHeadShapeInventoryStore = require(script.createHeadShapeInventoryStore)

return (Signals.createComputed(function(_) -- line: 8
	-- upvalues: createHeadShapeInventoryStore (copy)
	return createHeadShapeInventoryStore()
end))
