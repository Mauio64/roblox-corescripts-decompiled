local HttpService = game:GetService("HttpService")

require(script.Parent.types)

local function noopCancel() end

local function normalizeResponse(result)
	if typeof(result) == "string" then
		return { statusCode = 200, responseBody = result }
	end

	if typeof(result) ~= "table" then
		return { statusCode = 200, responseBody = nil }
	end

	if result.statusCode == nil then
		return { statusCode = 200, responseBody = HttpService:JSONEncode(result) }
	end

	return result
end

local function createMockNetwork(options)
	local v = options or {}
	local routes = v.routes or {}

	return {
		request = function(p, callback)
			local respond = nil

			for _, route in routes do
				if string.find(p.url, route.pattern, 1, true) then
					respond = route.respond
					break
				end
			end

			local v2 = respond or v.fallback

			if v2 == nil then
				callback(true, {
					statusCode = 404,
					responseBody = HttpService:JSONEncode({
						message = "createMockNetwork: no route matched " .. p.url,
						code = 5
					})
				})

				return noopCancel
			end

			local success, result = pcall(v2, p)

			if success then
				callback(true, normalizeResponse(result))
			else
				callback(false, (tostring(result)))
			end

			return noopCancel
		end
	}
end

return createMockNetwork
