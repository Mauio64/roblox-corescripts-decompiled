local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths
require(parent.ServiceContractsProto)
local Signals = require(parent.Signals)

require(SduiCoreSystem.SduiBuilderTypes)
local SduiClientBindingTypes = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local PropResultCategory = SduiClientBindingTypes.PropResultCategory
local SduiClientBindingBuilder = require(SduiCoreSystem.ClientBinding.SduiClientBindingBuilder)
local buildConfigForComponent = SduiClientBindingBuilder.buildConfigForComponent
local buildInputsForNestedComponent = require(SduiCoreSystem.ClientBinding.PropBuilder.buildInputsForNestedComponent)
local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local addSduiErrorContextFields = require(SduiCoreSystem.addSduiErrorContextFields)
local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)
require(SduiCoreSystem.SduiComponentType)
local function buildNestedComponentProp(p: string, data, p2, p3, data2, p4, flag: boolean?)
	local currentComponentType = data2.currentComponentType
	local currentParserName = data2.currentParserName

	if p == "literal" then
		local templateFromData = SduiPropUtils.resolveTemplateFromData(data, data2)
		local v

		if data.inline_component == nil then
			local computed = Signals.createComputed(function(p5)
				local v2 = {}
				local success, result = pcall(function()
					buildInputsForNestedComponent(p3, data.inputs, p2, p5, v2, data2)
				end)

				if success then
					return v2
				end

				local v3 = {
					message = `Failed to build inputs for nested component: {SduiParseHelpers.stringifyValue(result)}`,
					name = data2.debugName,
					componentType = currentComponentType,
					parserName = currentParserName
				}

				if FFlagSduiErrorPaths then
					addSduiErrorContextFields(v3, data2.errorContext)
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v3, data2.appPage)

				return v2
			end)
			local v2

			if FFlagSduiErrorPaths then
				v2 = data.roblox_component
			end

			v = buildConfigForComponent(templateFromData, computed, data2, p4, nil, nil, nil, v2)
		else
			v = buildConfigForComponent(templateFromData, p3, data2, p4, nil, p2)
		end

		if flag then
			return v, PropResultCategory.Literal
		end

		return v, PropResultCategory.NestedComponentConfig
	end

	if p == "conditional" then
		return
			SduiPropUtils.generateConditionalPropValue(data, p2, data2, p4, p3, buildNestedComponentProp, nil, not flag),
			PropResultCategory.PropSignal
	end

	error(`Could not build prop. Unknown propDefinitionType: {p}`)
end

return buildNestedComponentProp
