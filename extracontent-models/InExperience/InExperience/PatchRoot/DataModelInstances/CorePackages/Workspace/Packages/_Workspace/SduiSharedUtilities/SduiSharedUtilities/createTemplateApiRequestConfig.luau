local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")

require(SduiSharedUtilities.SduiApiRequestConfig)
local SduiIntegrationTypes = require(SduiSharedUtilities.SduiIntegrationTypes)
require(SduiSharedUtilities.SduiLoadTimer)
local SduiProtobufResponseHelpers = require(SduiSharedUtilities.SduiProtobufResponseHelpers)
local SduiTemplateApi = require(SduiSharedUtilities.SduiTemplateApi)

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
		parseTemplateEntriesFromResponse = function(p)
			return SduiTemplateApi.parseResponseForSurface(p, data.surfaceKey)
		end,
		parseLocalizedLiteralsFromResponse = SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse
	}
end

return createTemplateApiRequestConfig
