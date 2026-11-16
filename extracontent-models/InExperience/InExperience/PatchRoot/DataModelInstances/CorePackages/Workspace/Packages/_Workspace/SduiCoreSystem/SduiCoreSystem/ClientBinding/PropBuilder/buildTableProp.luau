local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
require(parent.Signals)

local SduiClientBindingBuilder = require(SduiCoreSystem.ClientBinding.SduiClientBindingBuilder)
local SduiClientBindingTypes = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local PropResultCategory = SduiClientBindingTypes.PropResultCategory
require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.ClientBinding.SduiDataBindingContentType)
local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)
local function buildTableProp(p: string, p2, p3, p4, p5, p6, callback)
	if p == "literal" then
		return
			SduiPropUtils.generateTablePropSignalValue(
				p2,
				p3,
				p5,
				p6,
				p4,
				SduiClientBindingBuilder.buildPropTable,
				callback
			),
			PropResultCategory.PropSignal
	elseif p == "binding_path" then
		local function evaluatePropTable(p7, p8)
			local propTable, v, v2 = SduiClientBindingBuilder.buildPropTable(p7, p3, p4, p5, p6)

			return SduiPropUtils.resolveTablePropValue(
				p8,
				propTable,
				v,
				v2,
				p3,
				p5,
				p6,
				p4,
				SduiClientBindingBuilder.buildPropTable
			)
		end

		return
			SduiPropUtils.generateDynamicBindingPropValue(p2, p3, p5, p4, evaluatePropTable),
			PropResultCategory.PropSignal
	elseif p == "conditional" then
		return
			SduiPropUtils.generateConditionalPropValue(p2, p3, p5, p6, p4, buildTableProp, callback),
			PropResultCategory.PropSignal
	end

	return nil, PropResultCategory.Failed
end

return buildTableProp
