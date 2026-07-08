local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.Signals)

local SduiClientBindingBuilder = require(SduiCoreSystem.ClientBinding.SduiClientBindingBuilder)
local PropResultCategory = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes).PropResultCategory

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.ClientBinding.SduiDataBindingContentType)

local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)

local function buildTableProp(s1: string, p1, p2, p3, p4, p5, p6: ((...any) -> ...any)?) -- line: 18
	-- upvalues: SduiPropUtils (copy), SduiClientBindingBuilder (copy), PropResultCategory (copy), buildTableProp (copy)
	if s1 == "literal" then
		return SduiPropUtils.generateTablePropSignalValue(p1, p2, p4, p5, p3, SduiClientBindingBuilder.buildPropTable, p6), PropResultCategory.PropSignal
	end

	if s1 == "binding_path" then
		local function evaluatePropTable(t1: {[any]: any}, p7) -- line: 40
			-- upvalues: SduiClientBindingBuilder (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy), SduiPropUtils (copy)
			local v17, v18, v19 = SduiClientBindingBuilder.buildPropTable(t1, p2, p3, p4, p5)

			return SduiPropUtils.resolveTablePropValue(p7, v17, v18, v19, p2, p4, p5, p3, SduiClientBindingBuilder.buildPropTable)
		end

		return SduiPropUtils.generateDynamicBindingPropValue(p1, p2, p4, p3, evaluatePropTable), PropResultCategory.PropSignal
	end

	if s1 == "conditional" then
		return SduiPropUtils.generateConditionalPropValue(p1, p2, p4, p5, p3, buildTableProp, p6), PropResultCategory.PropSignal
	end

	return nil, PropResultCategory.Failed
end

return buildTableProp
