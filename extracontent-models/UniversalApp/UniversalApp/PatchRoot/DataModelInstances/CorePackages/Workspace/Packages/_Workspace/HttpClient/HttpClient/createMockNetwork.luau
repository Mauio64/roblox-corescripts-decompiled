local HttpService = game:GetService("HttpService")

require(script.Parent.types)

local function noopCancel() -- line: 12
end
local function normalizeResponse(p1) -- line: 14
	-- upvalues: HttpService (copy)
	if typeof(p1) == "string" then
		return {
			statusCode = 200,
			responseBody = p1
		}
	end

	if typeof(p1) ~= "table" then
		return {
			statusCode = 200,
			responseBody = nil
		}
	end

	if p1.statusCode == nil then
		return {
			statusCode = 200,
			responseBody = HttpService:JSONEncode(p1)
		}
	end

	return p1
end
local function createMockNetwork(p2) -- line: 27
	-- upvalues: HttpService (copy), noopCancel (copy), normalizeResponse (copy)
	local v7 = p2 or {}
	local v8 = v7.routes or {}

	return {
		request = function(p3, p4: ((...any) -> ...any)) -- line: 31
			-- upvalues: v8 (copy), v7 (copy), HttpService (copy), noopCancel (copy), normalizeResponse (copy)
			local respond = nil

			for _, v13 in v8 do
				if string.find(p3.url, v13.pattern, 1, true) then
					respond = v13.respond

					break
				end
			end

			local v14 = respond or v7.fallback

			if v14 == nil then
				p4(true, {
					statusCode = 404,
					responseBody = HttpService:JSONEncode({
						code = 5,
						message = "createMockNetwork: no route matched " .. p3.url
					})
				})

				return noopCancel
			end

			local ok, result = pcall(v14, p3)

			if not ok then
				p4(false, (tostring(result)))
			else
				p4(true, (normalizeResponse(result)))
			end

			return noopCancel
		end
	}
end

return createMockNetwork
