local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiErrorPaths
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")

local propResultCategory = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes").PropResultCategory
local buildDefaultProp = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/buildDefaultProp")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiDataBindingContentType")
local SduiPropUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiPropUtils")
local SduiClientBindingParsers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiClientBindingParsers")
local function buildStringProp(p2, p3, p4, p5, p6, p7, p8)
	local v5 = p8 or SduiClientBindingParsers.parseToString

	if p2 == "translation" then
		local resolveLocalizedLiteral = p6.resolveLocalizedLiteral

		local v6 = if fFlagSduiErrorPaths then p6.errorContext else nil
		local localizedLiteral = resolveLocalizedLiteral(p3, v6)

		if not localizedLiteral then
			return nil, propResultCategory.Failed
		end

		if v5 then
			localizedLiteral = v5(localizedLiteral)
		end

		return localizedLiteral, propResultCategory.Literal
	else
		if p2 == "format" then
			return SduiPropUtils.generateFormatStringPropValue(p3, p4, p6, p5, v5), propResultCategory.PropSignal
		end

		local v6, v7 = buildDefaultProp(p2, p3, p4, p5, p6, p7, v5, buildStringProp)

		return v6, v7
	end
end

return buildStringProp
