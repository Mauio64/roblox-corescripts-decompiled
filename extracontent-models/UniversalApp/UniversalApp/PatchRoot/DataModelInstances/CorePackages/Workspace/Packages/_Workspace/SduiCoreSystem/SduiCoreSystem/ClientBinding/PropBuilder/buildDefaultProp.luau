local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.Signals)
require(SduiCoreSystem.SduiBuilderTypes)

local PropResultCategory = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes).PropResultCategory
local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)

local function buildDefaultProp(s1: string, p1, p2, p3, p4, p5, p6: ((...any) -> ...any)?, p7) -- line: 37
	-- upvalues: SduiPropUtils (copy), PropResultCategory (copy), buildDefaultProp (copy)
	if s1 == "literal" then
		return SduiPropUtils.generateStaticPropValue(p1, p6), PropResultCategory.Literal
	end

	if s1 == "token" then
		return SduiPropUtils.generateTokenBindingPropValue(p1, p4, p6), PropResultCategory.PropSignal
	end

	if s1 == "binding_path" then
		return SduiPropUtils.generateDynamicBindingPropValue(p1, p2, p4, p3, p6), PropResultCategory.PropSignal
	end

	if s1 == "conditional" then
		local v14 = p7 or buildDefaultProp

		return SduiPropUtils.generateConditionalPropValue(p1, p2, p4, p5, p3, v14, p6), PropResultCategory.PropSignal
	end

	return nil, PropResultCategory.Failed
end

return buildDefaultProp
