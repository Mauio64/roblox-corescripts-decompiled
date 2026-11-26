local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiErrorPaths
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes")
local SduiClientBindingBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingBuilder")
local SduiLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiLogger")
local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local addSduiErrorContextFields = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/addSduiErrorContextFields")
local SduiParseHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiParseHelpers")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")

local buildConfigForComponent = SduiClientBindingBuilder.buildConfigForComponent

return {
	makeStub = function(p2, p3, p4, p5, p6, data, p7, p8)
		return (setmetatable({ isBlank = false }, {
			__index = function(p9, p10)
				setmetatable(p9, nil)
				local v12 = if fFlagSduiErrorPaths then p7 else nil
				local v13 = if fFlagSduiErrorPaths then p8 else nil
				local success, result = pcall(
					buildConfigForComponent,
					p2,
					p3,
					p4,
					p5,
					nil,
					p6,
					p9,
					v12,
					v13
				)

				if success then
					return p9[p10]
				end

				local v14 = {
					message = `Failed to materialize deferred list item: {module5.stringifyValue(result)}`,
					name = data.name,
					componentType = data.componentType,
					parserName = data.parserName
				}

				if fFlagSduiErrorPaths then
					addSduiErrorContextFields(v14, p9.errorContext or data.nodeContext)
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v14, data.appPage)

				return nil
			end
		}))
	end
}
