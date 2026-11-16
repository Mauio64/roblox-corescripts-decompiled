local HttpService = game:GetService("HttpService")
local Json = {}

function Json.enc(p)
	return HttpService:JSONEncode(p)
end

function Json.dec(json)
	return HttpService:JSONDecode(json)
end

return Json
