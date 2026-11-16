local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths
require(parent.Signals)

local SduiClientBindingTypes = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local PropResultCategory = SduiClientBindingTypes.PropResultCategory
local buildDefaultProp = require(SduiCoreSystem.ClientBinding.PropBuilder.buildDefaultProp)
require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.ClientBinding.SduiDataBindingContentType)
local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)
local SduiClientBindingParsers = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiClientBindingParsers)
local function buildStringProp(p: string, p2, p3, p4, p5, p6, callback)
	local v = callback or SduiClientBindingParsers.parseToString

	if p == "translation" then
		local resolveLocalizedLiteral = p5.resolveLocalizedLiteral
		local v2

		if FFlagSduiErrorPaths then
			v2 = p5.errorContext
		end

		local localizedLiteral = resolveLocalizedLiteral(p2, v2)

		if not localizedLiteral then
			return nil, PropResultCategory.Failed
		end

		if v then
			localizedLiteral = v(localizedLiteral)
		end

		return localizedLiteral, PropResultCategory.Literal
	else
		if p == "format" then
			return SduiPropUtils.generateFormatStringPropValue(p2, p3, p5, p4, v), PropResultCategory.PropSignal
		end

		local defaultProp, v2 = buildDefaultProp(p, p2, p3, p4, p5, p6, v, buildStringProp)

		return defaultProp, v2
	end
end

return buildStringProp
