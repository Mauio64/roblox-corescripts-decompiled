local HttpService = game:GetService("HttpService")

local v5 = { Json = "Json", Proto = "Proto" }

local v6 = { [v5.Json] = "application/json", [v5.Proto] = "application/x-protobuf" }

return {
	SduiApiStorePostConfigContentType = v5,
	getBodyFromPostConfig = function(data)
		if not data.body then
			return nil
		end

		if data.contentType == v5.Json then
			return HttpService:JSONEncode(data.body)
		end

		if data.contentType == v5.Proto then
			return buffer.tostring(data.protoMessage.encode(data.body))
		end

		return nil
	end,
	getContentTypeHeaderFromPostConfig = function(p2)
		if p2.contentType then
			return v6[p2.contentType]
		end

		return nil
	end
}
