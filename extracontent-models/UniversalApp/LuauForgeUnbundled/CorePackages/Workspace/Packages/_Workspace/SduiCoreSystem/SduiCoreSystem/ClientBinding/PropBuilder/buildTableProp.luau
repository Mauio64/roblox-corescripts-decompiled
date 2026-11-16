require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")

local SduiClientBindingBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingBuilder")
local propResultCategory = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes").PropResultCategory
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiDataBindingContentType")
local SduiPropUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiPropUtils")
local function buildTableProp(p2, p3, p4, p5, p6, p7, p8)
	if p2 == "literal" then
		return
			SduiPropUtils.generateTablePropSignalValue(p3, p4, p6, p7, p5, SduiClientBindingBuilder.buildPropTable, p8),
			propResultCategory.PropSignal
	elseif p2 == "binding_path" then
		local function evaluatePropTable(p9, p10)
			local propTable, v5, v6 = SduiClientBindingBuilder.buildPropTable(p9, p4, p5, p6, p7)

			return SduiPropUtils.resolveTablePropValue(
				p10,
				propTable,
				v5,
				v6,
				p4,
				p6,
				p7,
				p5,
				SduiClientBindingBuilder.buildPropTable
			)
		end

		return
			SduiPropUtils.generateDynamicBindingPropValue(p3, p4, p6, p5, evaluatePropTable),
			propResultCategory.PropSignal
	elseif p2 == "conditional" then
		return
			SduiPropUtils.generateConditionalPropValue(p3, p4, p6, p7, p5, buildTableProp, p8),
			propResultCategory.PropSignal
	end

	return nil, propResultCategory.Failed
end

return buildTableProp
