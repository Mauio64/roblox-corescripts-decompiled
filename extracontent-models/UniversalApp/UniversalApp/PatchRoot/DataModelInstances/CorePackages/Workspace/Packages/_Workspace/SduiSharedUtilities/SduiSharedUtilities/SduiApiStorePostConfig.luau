local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local FFlagSduiClientTemplateCache = require(Parent.SharedFlags).FFlagSduiClientTemplateCache
local t1 = {
	Json = "Json",
	Proto = "Proto"
}
local t2 = {
	[t1.Json] = "application/json",
	[t1.Proto] = "application/x-protobuf"
}

return {
	SduiApiStorePostConfigContentType = t1,
	getBodyFromPostConfig = function(p1) -- line: 34
		-- upvalues: t1 (copy), HttpService (copy), FFlagSduiClientTemplateCache (copy)
		if p1.body then
			if p1.contentType == t1.Json then
				return HttpService:JSONEncode(p1.body)
			end

			if FFlagSduiClientTemplateCache and p1.contentType == t1.Proto then
				return buffer.tostring(p1.protoMessage.encode(p1.body))
			end
		end

		return nil
	end,
	getContentTypeHeaderFromPostConfig = function(p2) -- line: 49
		-- upvalues: t2 (copy)
		if p2.contentType then
			return t2[p2.contentType]
		end

		return nil
	end
}
