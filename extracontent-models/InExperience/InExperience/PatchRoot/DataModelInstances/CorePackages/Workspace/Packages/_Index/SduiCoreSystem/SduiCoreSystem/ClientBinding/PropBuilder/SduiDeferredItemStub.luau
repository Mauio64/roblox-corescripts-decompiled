local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.Signals)
require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)

local SduiClientBindingBuilder = require(SduiCoreSystem.ClientBinding.SduiClientBindingBuilder)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)

require(SduiCoreSystem.SduiComponentType)

local buildConfigForComponent = SduiClientBindingBuilder.buildConfigForComponent

return {
	makeStub = function(p1, p2, p3, p4, p5, t1: {[any]: any}) -- line: 44
		-- upvalues: buildConfigForComponent (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy)
		return (setmetatable({
			isBlank = false
		}, {
			__index = function(p6, s1: string) -- line: 60
				-- upvalues: buildConfigForComponent (copy), p1 (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy), t1 (copy)
				setmetatable(p6, nil)

				local ok, result = pcall(buildConfigForComponent, p1, p2, p3, p4, nil, p5, p6)

				if not ok then
					SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
						message = `Failed to materialize deferred list item: { SduiParseHelpers.stringifyValue(result) }`,
						name = t1.name,
						componentType = t1.componentType,
						parserName = t1.parserName
					}, t1.appPage)

					return nil
				end

				return p6[s1]
			end
		}))
	end
}
