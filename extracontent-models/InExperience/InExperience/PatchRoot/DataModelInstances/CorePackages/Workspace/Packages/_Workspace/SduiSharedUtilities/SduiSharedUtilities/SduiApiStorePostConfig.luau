local HttpService = game:GetService("HttpService")

local sduiApiStorePostConfigContentType = { Json = "Json", Proto = "Proto" }

local v = {
	[sduiApiStorePostConfigContentType.Json] = "application/json",
	[sduiApiStorePostConfigContentType.Proto] = "application/x-protobuf"
}
local SduiApiStorePostConfig = {}
SduiApiStorePostConfig.SduiApiStorePostConfigContentType = sduiApiStorePostConfigContentType

function SduiApiStorePostConfig.getBodyFromPostConfig(data)
	if not data.body then
		return nil
	end

	if data.contentType == sduiApiStorePostConfigContentType.Json then
		return HttpService:JSONEncode(data.body)
	end

	if data.contentType == sduiApiStorePostConfigContentType.Proto then
		return buffer.tostring(data.protoMessage.encode(data.body))
	end

	return nil
end

function SduiApiStorePostConfig.getContentTypeHeaderFromPostConfig(p)
	if p.contentType then
		return v[p.contentType]
	end

	return nil
end

return SduiApiStorePostConfig
