local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiErrorPaths
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/ServiceContractsProto")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
local propResultCategory = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes").PropResultCategory
local buildConfigForComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingBuilder").buildConfigForComponent
local buildInputsForNestedComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/buildInputsForNestedComponent")
local SduiPropUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiPropUtils")
local SduiLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiLogger")
local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local addSduiErrorContextFields = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/addSduiErrorContextFields")
local SduiParseHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiParseHelpers")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")
local function buildNestedComponentProp(p2, data, p3, p4, data2, p5, p6)
	local currentComponentType = data2.currentComponentType
	local currentParserName = data2.currentParserName

	if p2 == "literal" then
		local templateFromData = SduiPropUtils.resolveTemplateFromData(data, data2)
		local v5

		if data.inline_component == nil then
			local computed = Signals.createComputed(function(p7)
				local v6 = {}
				local success, result = pcall(function()
					buildInputsForNestedComponent(p4, data.inputs, p3, p7, v6, data2)
				end)

				if success then
					return v6
				end

				local v7 = {
					message = `Failed to build inputs for nested component: {module7.stringifyValue(result)}`,
					name = data2.debugName,
					componentType = currentComponentType,
					parserName = currentParserName
				}

				if fFlagSduiErrorPaths then
					addSduiErrorContextFields(v7, data2.errorContext)
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v7, data2.appPage)

				return v6
			end)

			local v10 = if fFlagSduiErrorPaths then data.roblox_component else nil
			v5 = buildConfigForComponent(templateFromData, computed, data2, p5, nil, nil, nil, v10)
		else
			v5 = buildConfigForComponent(templateFromData, p4, data2, p5, nil, p3)
		end

		if p6 then
			return v5, propResultCategory.Literal
		end

		return v5, propResultCategory.NestedComponentConfig
	end

	if p2 == "conditional" then
		return
			SduiPropUtils.generateConditionalPropValue(
				data,
				p3,
				data2,
				p5,
				p4,
				buildNestedComponentProp,
				nil,
				not p6
			),
			propResultCategory.PropSignal
	end

	error(`Could not build prop. Unknown propDefinitionType: {p2}`)
end

return buildNestedComponentProp
