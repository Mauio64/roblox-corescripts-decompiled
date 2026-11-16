local HttpService = game:GetService("HttpService")
local Json = {}

function Json.stringify(p, ...)
	if select("#", ...) > 0 then
		warn("JSON.stringify doesn't currently support more than 1 argument. All additional arguments will be ignored.")
	end

	return HttpService:JSONEncode(p)
end

function Json.parse(json: string, ...)
	if select("#", ...) > 0 then
		warn("JSON.parse doesn't currently support more than 1 argument. All additional arguments will be ignored.")
	end

	return HttpService:JSONDecode(json)
end

return Json
