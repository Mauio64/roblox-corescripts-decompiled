local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

local parent = SduiCoreSystem.Parent
require(parent.Signals)

require(SduiCoreSystem.SduiBuilderTypes)
local SduiClientBindingTypes = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local PropResultCategory = SduiClientBindingTypes.PropResultCategory
local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)
local function buildDefaultProp(p: string, p2, p3, p4, p5, p6, callback, p7)
	if p == "literal" then
		return SduiPropUtils.generateStaticPropValue(p2, callback), PropResultCategory.Literal
	elseif p == "token" then
		return SduiPropUtils.generateTokenBindingPropValue(p2, p5, callback), PropResultCategory.PropSignal
	elseif p == "binding_path" then
		return SduiPropUtils.generateDynamicBindingPropValue(p2, p3, p5, p4, callback), PropResultCategory.PropSignal
	end

	if p ~= "conditional" then
		return nil, PropResultCategory.Failed
	end

	return
		SduiPropUtils.generateConditionalPropValue(p2, p3, p5, p6, p4, p7 or buildDefaultProp, callback),
		PropResultCategory.PropSignal
end

return buildDefaultProp
