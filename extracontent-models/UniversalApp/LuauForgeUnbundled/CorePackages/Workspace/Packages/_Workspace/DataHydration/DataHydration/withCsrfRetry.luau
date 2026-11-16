require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local function getCsrfToken(p2)
	local headers = p2.headers

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

local function mergeHeaders(items, items2)
	local result = {}

	if items then
		for k, item in items do
			result[k] = item
		end
	end

	for k, item in items2 do
		result[k] = item
	end

	return result
end

local function withCsrfRetry(p2)
	return {
		request = function(data, callback)
			local flag = false
			local v5 = nil

			v5 = p2.request(data, function(p3, p4)
				if flag then
					return
				end

				if not p3 or typeof(p4) ~= "table" then
					callback(p3, p4)
					return
				end

				if p4.statusCode ~= 403 then
					callback(true, p4)
					return
				end

				local csrfToken = getCsrfToken(p4)

				if csrfToken == nil then
					callback(true, p4)
					return
				end

				local v6 = {
					url = data.url,
					method = data.method,
					body = data.body,
					headers = 0
				}
				local headers = data.headers
				local v8 = {}

				if headers then
					for k, header in headers do
						v8[k] = header
					end
				end

				for k, v9 in { ["x-csrf-token"] = csrfToken } do
					v8[k] = v9
				end

				v6.headers = v8

				v5 = p2.request(v6, function(p5, p6)
					if flag then
						return
					end

					callback(p5, p6)
				end)
			end)

			return function()
				if flag then
					return
				end

				flag = true

				if v5 then
					v5()
				end
			end
		end
	}
end

return withCsrfRetry
