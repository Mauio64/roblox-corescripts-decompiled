require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiApiRequestConfig")
local SduiIntegrationTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiLoadTimer")
local SduiProtobufResponseHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiProtobufResponseHelpers")
local SduiTemplateApi = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiTemplateApi")

local function createTemplateApiRequestConfig(data)
	local request = SduiTemplateApi.createRequest({
		surfaceKeys = { data.surfaceKey },
		locale = data.locale,
		capabilities = data.capabilities
	})

	if request == nil then
		return nil
	end

	return {
		responseType = SduiIntegrationTypes.SduiResponseType.Protobuf,
		url = request.url,
		surfaceKey = data.surfaceKey,
		configKey = data.configKey or `template-api-page:{data.surfaceKey}:{request.cacheKey}`,
		loadTimer = data.loadTimer,
		apiProto = request.responseProto,
		allowNoConfigsBuilt = data.allowNoConfigsBuilt,
		onSuccess = data.onSuccess,
		enableTemplateCache = true,
		postConfig = request.postConfig,
		parsePageEntriesFromResponse = function()
			return data.pageEntries
		end,
		parseTemplateEntriesFromResponse = function(p2)
			return SduiTemplateApi.parseResponseForSurface(p2, data.surfaceKey)
		end,
		parseLocalizedLiteralsFromResponse = SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse
	}
end

return createTemplateApiRequestConfig
