require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
local propResultCategory = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes").PropResultCategory
local SduiPropUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiPropUtils")
local function buildDefaultProp(p2, p3, p4, p5, p6, p7, p8, p9)
	if p2 == "literal" then
		return SduiPropUtils.generateStaticPropValue(p3, p8), propResultCategory.Literal
	elseif p2 == "token" then
		return SduiPropUtils.generateTokenBindingPropValue(p3, p6, p8), propResultCategory.PropSignal
	elseif p2 == "binding_path" then
		return SduiPropUtils.generateDynamicBindingPropValue(p3, p4, p6, p5, p8), propResultCategory.PropSignal
	end

	if p2 ~= "conditional" then
		return nil, propResultCategory.Failed
	end

	return
		SduiPropUtils.generateConditionalPropValue(p3, p4, p6, p7, p5, p9 or buildDefaultProp, p8),
		propResultCategory.PropSignal
end

return buildDefaultProp
