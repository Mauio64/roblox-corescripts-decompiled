local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths
require(parent.Signals)

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local SduiClientBindingBuilder = require(SduiCoreSystem.ClientBinding.SduiClientBindingBuilder)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local addSduiErrorContextFields = require(SduiCoreSystem.addSduiErrorContextFields)
local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)
require(SduiCoreSystem.SduiComponentType)

local buildConfigForComponent = SduiClientBindingBuilder.buildConfigForComponent

return {
	makeStub = function(p, p2, p3, p4, p5, data, p6: string?, p7: string?)
		return (setmetatable({ isBlank = false }, {
			__index = function(p8, p9: string)
				setmetatable(p8, nil)
				local v

				if FFlagSduiErrorPaths then
					v = p6
				end

				local v2

				if FFlagSduiErrorPaths then
					v2 = p7
				end

				local success, result = pcall(buildConfigForComponent, p, p2, p3, p4, nil, p5, p8, v, v2)

				if success then
					return p8[p9]
				end

				local v3 = {
					message = `Failed to materialize deferred list item: {SduiParseHelpers.stringifyValue(result)}`,
					name = data.name,
					componentType = data.componentType,
					parserName = data.parserName
				}

				if FFlagSduiErrorPaths then
					addSduiErrorContextFields(v3, p8.errorContext or data.nodeContext)
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v3, data.appPage)

				return nil
			end
		}))
	end
}
