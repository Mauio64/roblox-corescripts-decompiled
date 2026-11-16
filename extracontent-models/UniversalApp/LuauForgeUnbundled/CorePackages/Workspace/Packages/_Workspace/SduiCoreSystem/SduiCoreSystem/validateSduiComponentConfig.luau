local SduiComponentType = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")
local SduiConfigTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiConfigTypes")
local sduiErrorType = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors").SduiErrorType
local uiComponentInterface = SduiConfigTypes.UiComponentInterface
local validateInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/validateInterface")

local function validateSduiComponentConfig(p2, p3)
	if p2 == nil then
		return false, { errorType = sduiErrorType.NilComponentConfig }
	end

	assert(p2, "componentConfig must exist")
	local v5, v6 = validateInterface(p2, uiComponentInterface, p3)

	if not v5 then
		return false, { errorType = sduiErrorType.InvalidComponentConfig, message = v6 }
	end

	if SduiComponentType[p2.componentType] ~= nil then
		return true
	end

	return false, { errorType = sduiErrorType.ComponentTypeNotRecognized }
end

return validateSduiComponentConfig
