local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/types")

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
	local v5 = options or {}
	local routes = v5.routes or {}

	return {
		request = function(p2, callback)
			local respond = nil

			for k, route in routes do
				if string.find(p2.url, route.pattern, 1, true) then
					respond = route.respond
					break
				end
			end

			local v7 = respond or v5.fallback

			if v7 == nil then
				callback(true, {
					statusCode = 404,
					responseBody = HttpService:JSONEncode({
						message = "createMockNetwork: no route matched " .. p2.url,
						code = 5
					})
				})

				return noopCancel
			end

			local success, result = pcall(v7, p2)

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
