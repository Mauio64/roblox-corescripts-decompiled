local HttpService = game:GetService("HttpService")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local function tryJsonDecode(buf)
	if buf == nil or buf == "" then
		return nil
	end

	if typeof(buf) == "buffer" then
		buf = buffer.tostring(buf)
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, buf)

	if success then
		return result
	end

	return nil
end

local function rpcDecoder(callback)
	return function(p2)
		local responseBody = p2.responseBody
		local result

		if not (responseBody == nil or responseBody == "") then
			if typeof(responseBody) == "buffer" then
				responseBody = buffer.tostring(responseBody)
			end

			local success
			success, result = pcall(HttpService.JSONDecode, HttpService, responseBody)

			if not success then
				result = nil
			end
		end

		if typeof(result) == "table" and result.error then
			local err = result.error
			return nil, tostring(err.message or "JSON-RPC error"), err.code
		end

		if p2.statusCode >= 200 and p2.statusCode < 300 then
			local result2 = if typeof(result) == "table" then result.result else nil

			if callback == nil then
				return result2, nil, nil
			end

			local v5, v6 = callback(result2)
			return v5, v6, nil
		else
			local v5

			if typeof(p2.responseBody) == "buffer" then
				v5 = buffer.tostring(p2.responseBody)
			else
				v5 = p2.responseBody or ""
			end

			return nil, ("CAS HTTP %d: %s"):format(p2.statusCode, v5), nil
		end
	end
end

return rpcDecoder
