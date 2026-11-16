local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")

require(SduiSharedUtilities.SduiApiRequestConfig)
local SduiIntegrationTypes = require(SduiSharedUtilities.SduiIntegrationTypes)
require(SduiSharedUtilities.SduiLoadTimer)
local SduiProtobufResponseHelpers = require(SduiSharedUtilities.SduiProtobufResponseHelpers)
local SduiTemplateApi = require(SduiSharedUtilities.SduiTemplateApi)

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
		parseTemplateEntriesFromResponse = function(p)
			SduiTemplateApi.storeResponse(p, request)
			return {}, {}, {}
		end,
		parseLocalizedLiteralsFromResponse = SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse
	}
end

return createTemplateApiPrewarmRequestConfig
