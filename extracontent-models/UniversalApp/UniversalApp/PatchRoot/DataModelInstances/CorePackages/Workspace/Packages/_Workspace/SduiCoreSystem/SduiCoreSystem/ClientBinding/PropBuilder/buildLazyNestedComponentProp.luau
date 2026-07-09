local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.Signals)
require(SduiCoreSystemParent.ServiceContractsProto)
require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)

local buildNestedComponentProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildNestedComponentProp)

local function buildLazyNestedComponentProp(s1: string, p1, p2, p3, p4, p5) -- line: 30
	-- upvalues: buildNestedComponentProp (copy)
	return buildNestedComponentProp(s1, p1, p2, p3, p4, p5, true)
end

return buildLazyNestedComponentProp
