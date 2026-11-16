local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

local SduiComponentType = require(SduiCoreSystem.SduiComponentType)
local SduiConfigTypes = require(SduiCoreSystem.SduiConfigTypes)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiErrorType = SduiErrors.SduiErrorType
local UiComponentInterface = SduiConfigTypes.UiComponentInterface
local validateInterface = require(SduiCoreSystem.validateInterface)

local function validateSduiComponentConfig(p, flag: boolean?)
	if p == nil then
		return false, { errorType = SduiErrorType.NilComponentConfig }
	end

	assert(p, "componentConfig must exist")
	local v, message = validateInterface(p, UiComponentInterface, flag)

	if not v then
		return false, { errorType = SduiErrorType.InvalidComponentConfig, message = message }
	end

	if SduiComponentType[p.componentType] ~= nil then
		return true
	end

	return false, { errorType = SduiErrorType.ComponentTypeNotRecognized }
end

return validateSduiComponentConfig
