local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
require(parent.Signals)
require(parent.ServiceContractsProto)

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local buildNestedComponentProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildNestedComponentProp)

local function buildLazyNestedComponentProp(p: string, p2, p3, p4, p5, p6)
	return buildNestedComponentProp(p, p2, p3, p4, p5, p6, true)
end

return buildLazyNestedComponentProp
