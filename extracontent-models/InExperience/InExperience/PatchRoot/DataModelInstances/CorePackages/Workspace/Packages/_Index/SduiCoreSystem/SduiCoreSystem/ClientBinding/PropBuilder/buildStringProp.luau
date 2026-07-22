local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.Signals)

local PropResultCategory = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes).PropResultCategory
local buildDefaultProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildDefaultProp)

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.ClientBinding.SduiDataBindingContentType)

local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)
local SduiClientBindingParsers = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiClientBindingParsers)
local FFlagSduiStringPropToString = require(SduiCoreSystemParent.SharedFlags).FFlagSduiStringPropToString

local function buildStringProp(s1: string, p1, p2, p3, p4, p5, p6: ((...any) -> ...any)?) -- line: 21
	-- upvalues: FFlagSduiStringPropToString (copy), SduiClientBindingParsers (copy), PropResultCategory (copy), SduiPropUtils (copy), buildDefaultProp (copy), buildStringProp (copy)
	local v16 = p6 or if not FFlagSduiStringPropToString then nil else SduiClientBindingParsers.parseToString

	if s1 == "translation" then
		local v17 = p4.resolveLocalizedLiteral(p1)

		if v17 then
			return if not v16 then v17 else v16(v17), PropResultCategory.Literal
		end

		return nil, PropResultCategory.Failed
	end

	if s1 == "format" then
		return SduiPropUtils.generateFormatStringPropValue(p1, p2, p4, p3, v16), PropResultCategory.PropSignal
	end

	local v18, v19 = buildDefaultProp(s1, p1, p2, p3, p4, p5, v16, buildStringProp)

	return v18, v19
end

return buildStringProp
