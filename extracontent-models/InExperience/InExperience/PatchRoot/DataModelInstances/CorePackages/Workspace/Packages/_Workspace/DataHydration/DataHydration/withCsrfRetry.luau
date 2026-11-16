local parent = script:FindFirstAncestor("DataHydration").Parent

require(parent.HttpClient)

local function getCsrfToken(p)
	local headers = p.headers

	if headers == nil then
		return nil
	end

	for k, header in headers do
		if string.lower((tostring(k))) == "x-csrf-token" then
			return header
		end
	end

	return nil
end

local function mergeHeaders(headers, items) -- 1 equivalent call inferred from this helper
	local result = {}

	if headers then
		for k, item in headers do
			result[k] = item
		end
	end

	for k, item in items do
		result[k] = item
	end

	return result
end

local function withCsrfRetry(p)
	return {
		request = function(data, callback)
			local flag = false
			local v = nil

			v = p.request(data, function(p2, p3)
				if flag then
					return
				end

				if not p2 or typeof(p3) ~= "table" then
					callback(p2, p3)
					return
				end

				if p3.statusCode ~= 403 then
					callback(true, p3)
					return
				end

				local csrfToken = getCsrfToken(p3)

				if csrfToken == nil then
					callback(true, p3)
					return
				end

				local v2 = {
					url = data.url,
					method = data.method,
					body = data.body,
					headers = mergeHeaders(data.headers, { ["x-csrf-token"] = csrfToken }) -- inferred equivalent call
				}

				v = p.request(v2, function(p4, p5)
					if flag then
						return
					end

					callback(p4, p5)
				end)
			end)

			return function()
				if flag then
					return
				end

				flag = true

				if v then
					v()
				end
			end
		end
	}
end

return withCsrfRetry
