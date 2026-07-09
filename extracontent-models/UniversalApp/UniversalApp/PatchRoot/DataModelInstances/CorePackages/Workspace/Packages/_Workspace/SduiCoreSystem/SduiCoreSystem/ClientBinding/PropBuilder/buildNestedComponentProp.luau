local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.ServiceContractsProto)

local Signals = require(SduiCoreSystemParent.Signals)

require(SduiCoreSystem.SduiBuilderTypes)

local PropResultCategory = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes).PropResultCategory
local buildConfigForComponent = require(SduiCoreSystem.ClientBinding.SduiClientBindingBuilder).buildConfigForComponent
local buildInputsForNestedComponent = require(SduiCoreSystem.ClientBinding.PropBuilder.buildInputsForNestedComponent)
local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)

require(SduiCoreSystem.SduiComponentType)

local FFlagSduiLocalizedLiterals = require(SduiCoreSystemParent.SharedFlags).FFlagSduiLocalizedLiterals
local FFlagSduiImprovedErrorDimensions = require(SduiCoreSystemParent.SharedFlags).FFlagSduiImprovedErrorDimensions
local FFlagSduiInlineNestedComponentSchema = require(SduiCoreSystemParent.SharedFlags).FFlagSduiInlineNestedComponentSchema
local FFlagSduiLazyNestedComponentProp = require(SduiCoreSystemParent.SharedFlags).FFlagSduiLazyNestedComponentProp

local function buildNestedComponentProp(s1: string, p1, p2, p3, p4, p5, b1: boolean?) -- line: 51
	-- upvalues: FFlagSduiImprovedErrorDimensions (copy), FFlagSduiInlineNestedComponentSchema (copy), SduiPropUtils (copy), buildConfigForComponent (copy), Signals (copy), buildInputsForNestedComponent (copy), FFlagSduiLocalizedLiterals (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy), FFlagSduiLazyNestedComponentProp (copy), PropResultCategory (copy), buildNestedComponentProp (copy)
	local currentComponentType = nil
	local currentParserName = nil

	if FFlagSduiImprovedErrorDimensions then
		currentComponentType = p4.currentComponentType
		currentParserName = p4.currentParserName
	end

	if s1 == "literal" then
		local v25

		if FFlagSduiInlineNestedComponentSchema then
			v25 = SduiPropUtils.resolveTemplateFromData(p1, p4)
		else
			if p1.roblox_component == nil then
				error("Missing templateData.roblox_component")
			end

			v25 = p4.getTemplateForRobloxComponent(p1.roblox_component)

			if v25 == nil then
				error(`Could not find template for roblox_component { p1.roblox_component }`)
			end
		end

		local v26

		if FFlagSduiInlineNestedComponentSchema and p1.inline_component ~= nil then
			v26 = buildConfigForComponent(v25, p3, p4, p5, nil, p2)
		else
			local v27 = Signals.createComputed(function(p6) -- line: 91
				-- upvalues: buildInputsForNestedComponent (copy), p3 (copy), p1 (copy), p2 (copy), FFlagSduiLocalizedLiterals (copy), p4 (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref)
				local t1 = {}
				local ok, result = pcall(function() -- line: 93
					-- upvalues: buildInputsForNestedComponent (copy), p3 (copy), p1 (copy), p2 (copy), p6 (copy), t1 (copy), FFlagSduiLocalizedLiterals (copy), p4 (copy)
					buildInputsForNestedComponent(p3, p1.inputs, p2, p6, t1, if not FFlagSduiLocalizedLiterals then nil else p4)
				end)

				if not ok then
					SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
						message = `Failed to build inputs for nested component: { SduiParseHelpers.stringifyValue(result) }`,
						name = p4.debugName,
						componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
						parserName = if not FFlagSduiImprovedErrorDimensions then nil else currentParserName
					}, p4.appPage)
				end

				return t1
			end)

			v26 = buildConfigForComponent(v25, v27, p4, p5)
		end

		return v26, if not FFlagSduiLazyNestedComponentProp or not b1 then PropResultCategory.NestedComponentConfig else PropResultCategory.Literal
	end

	if s1 == "conditional" then
		return SduiPropUtils.generateConditionalPropValue(p1, p2, p4, p5, p3, buildNestedComponentProp, nil, not FFlagSduiLazyNestedComponentProp or not b1), PropResultCategory.PropSignal
	end

	error(`Could not build prop. Unknown propDefinitionType: { s1 }`)
end

return buildNestedComponentProp
