require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiApiRequestConfig")
local SduiIntegrationTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiLoadTimer")
local SduiProtobufResponseHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiProtobufResponseHelpers")
local SduiTemplateApi = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiTemplateApi")

local function createTemplateApiPrewarmRequestConfig(data)
	local request = SduiTemplateApi.createRequest({
		surfaceKeys = data.surfaceKeys,
		locale = data.locale,
		capabilities = data.capabilities
	})

	if request == nil then
		return nil
	end

	return {
		responseType = SduiIntegrationTypes.SduiResponseType.Protobuf,
		url = request.url,
		surfaceKey = "TemplatePrewarm",
		configKey = data.configKey or request.cacheKey,
		loadTimer = data.loadTimer,
		apiProto = request.responseProto,
		postConfig = request.postConfig,
		allowNoConfigsBuilt = true,
		parsePageEntriesFromResponse = function()
			return {}
		end,
		parseTemplateEntriesFromResponse = function(p2)
			SduiTemplateApi.storeResponse(p2, request)
			return {}, {}, {}
		end,
		parseLocalizedLiteralsFromResponse = SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse
	}
end

return createTemplateApiPrewarmRequestConfig
