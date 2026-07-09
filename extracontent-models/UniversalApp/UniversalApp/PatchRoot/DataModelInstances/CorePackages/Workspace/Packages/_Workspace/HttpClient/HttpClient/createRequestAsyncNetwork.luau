local HttpService = game:GetService("HttpService")

require(script.Parent.types)

local function toLowerKeyedHeaders(p1) -- line: 8
	if typeof(p1) ~= "table" then
		return nil
	end

	local t1 = {}

	for v6, v7 in p1 do
		t1[tostring(v6):lower()] = tostring(v7)
	end

	return t1
end
local function createRequestAsyncNetwork() -- line: 19
	-- upvalues: HttpService (copy), toLowerKeyedHeaders (copy)
	return {
		request = function(p2, p3: ((...any) -> ...any)) -- line: 20
			-- upvalues: HttpService (copy), toLowerKeyedHeaders (copy)
			assert(p2.onMessage == nil, "createRequestAsyncNetwork does not support onMessage; use createRequestInternalNetwork")

			local u10 = false

			task.spawn(function() -- line: 31
				-- upvalues: HttpService (copy), p2 (copy), u10 (ref), p3 (copy), toLowerKeyedHeaders (copy)
				local ok, result = pcall(function() -- line: 32
					-- upvalues: HttpService (copy), p2 (copy)
					return HttpService:RequestAsync({
						Url = p2.url,
						Method = p2.method,
						Headers = p2.headers,
						Body = p2.body
					})
				end)

				if u10 then
					return
				end

				u10 = true

				if not ok then
					p3(false, (tostring(result)))

					return
				end

				p3(true, {
					statusCode = tonumber(result.StatusCode) or 0,
					responseBody = result.Body,
					headers = toLowerKeyedHeaders(result.Headers)
				})
			end)

			return function() -- line: 58
				-- upvalues: u10 (ref)
				u10 = true
			end
		end
	}
end

return createRequestAsyncNetwork
