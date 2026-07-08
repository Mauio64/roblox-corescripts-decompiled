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
local FFlagSduiLocalizedLiterals = require(SduiCoreSystemParent.SharedFlags).FFlagSduiLocalizedLiterals

local function buildStringProp(s1: string, p1, p2, p3, p4, p5, p6: ((...any) -> ...any)?) -- line: 22
	-- upvalues: FFlagSduiStringPropToString (copy), SduiClientBindingParsers (copy), FFlagSduiLocalizedLiterals (copy), PropResultCategory (copy), SduiPropUtils (copy), buildDefaultProp (copy), buildStringProp (copy)
	local v17 = p6 or if not FFlagSduiStringPropToString then nil else SduiClientBindingParsers.parseToString

	if FFlagSduiLocalizedLiterals and s1 == "translation" then
		local v18 = p4.resolveLocalizedLiteral(p1)

		if v18 then
			return if not v17 then v18 else v17(v18), PropResultCategory.Literal
		end

		return nil, PropResultCategory.Failed
	end

	if s1 == "format" then
		return SduiPropUtils.generateFormatStringPropValue(p1, p2, p4, p3, v17), PropResultCategory.PropSignal
	end

	local v19, v20 = buildDefaultProp(s1, p1, p2, p3, p4, p5, v17, buildStringProp)

	return v19, v20
end

return buildStringProp
