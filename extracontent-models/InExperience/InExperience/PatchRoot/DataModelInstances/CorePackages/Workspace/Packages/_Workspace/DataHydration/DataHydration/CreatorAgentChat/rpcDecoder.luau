local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpService = game:GetService("HttpService")
require(parent.HttpClient)

local function tryJsonDecode(buf)
	if buf == nil or buf == "" then
		return nil
	end

	if typeof(buf) == "buffer" then
		buf = buffer.tostring(buf)
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, buf)
	return if success then result else nil
end

local function rpcDecoder(callback)
	return function(p)
		local responseBody = p.responseBody
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

		if p.statusCode >= 200 and p.statusCode < 300 then
			local result2

			if typeof(result) == "table" then
				result2 = result.result
			end

			if callback == nil then
				return result2, nil, nil
			end

			local v, v2 = callback(result2)
			return v, v2, nil
		else
			local v

			if typeof(p.responseBody) == "buffer" then
				v = buffer.tostring(p.responseBody)
			else
				v = p.responseBody or ""
			end

			return nil, ("CAS HTTP %d: %s"):format(p.statusCode, v), nil
		end
	end
end

return rpcDecoder
