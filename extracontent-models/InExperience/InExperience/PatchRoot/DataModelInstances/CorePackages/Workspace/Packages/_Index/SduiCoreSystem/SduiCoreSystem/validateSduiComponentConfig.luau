local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiComponentType = require(SduiCoreSystem.SduiComponentType)
local SduiConfigTypes = require(SduiCoreSystem.SduiConfigTypes)
local SduiErrorType = require(SduiCoreSystem.SduiErrors).SduiErrorType
local UiComponentInterface = SduiConfigTypes.UiComponentInterface
local validateInterface = require(SduiCoreSystem.validateInterface)

local function validateSduiComponentConfig(p1, b1: boolean?) -- line: 19
	-- upvalues: SduiErrorType (copy), validateInterface (copy), UiComponentInterface (copy), SduiComponentType (copy)
	if p1 == nil then
		return false, {
			errorType = SduiErrorType.NilComponentConfig
		}
	end

	assert(p1, "componentConfig must exist")

	local v10, v11 = validateInterface(p1, UiComponentInterface, b1)

	if not v10 then
		return false, {
			errorType = SduiErrorType.InvalidComponentConfig,
			message = v11
		}
	end

	if SduiComponentType[p1.componentType] ~= nil then
		return true
	end

	return false, {
		errorType = SduiErrorType.ComponentTypeNotRecognized
	}
end

return validateSduiComponentConfig
