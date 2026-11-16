local HttpResponse = {}
HttpResponse.__index = HttpResponse
function HttpResponse.__tostring(items)
	local v = {}

	for k, item in pairs(items) do
		table.insert(v, string.format("%s = %s", tostring(k), (tostring(item))))
	end

	table.sort(v)

	return "<HttpResponse: " .. table.concat(v, ", ") .. ">"
end

function HttpResponse.success(responseCode, responseBody)
	return (setmetatable({ responseCode = responseCode, responseBody = responseBody }, HttpResponse))
end

function HttpResponse.error(httpError)
	return (setmetatable({ HttpError = httpError }, HttpResponse))
end

return HttpResponse
