local Parent = script:FindFirstAncestor("DataHydration").Parent
local HttpService = game:GetService("HttpService")

require(Parent.HttpClient)

local function tryJsonDecode(p1) -- line: 11
	-- upvalues: HttpService (copy)
	if p1 == nil or p1 == "" then
		return nil
	end

	local v6 = if typeof(p1) ~= "buffer" then p1 else buffer.tostring(p1)
	local ok, result = pcall(HttpService.JSONDecode, HttpService, v6)

	if ok then
		return result
	end

	return nil
end
local function rpcDecoder() -- line: 20
	-- upvalues: HttpService (copy)
	return function(p2) -- line: 21
		-- upvalues: HttpService (copy)
		local responseBody = p2.responseBody
		local v11

		if responseBody == nil or responseBody == "" then
			v11 = nil
		else
			local v12 = if typeof(responseBody) ~= "buffer" then responseBody else buffer.tostring(responseBody)
			local ok, result = pcall(HttpService.JSONDecode, HttpService, v12)

			v11 = if not ok then nil else result
		end

		if typeof(v11) == "table" and v11.error then
			local error = v11.error

			return nil, ("CAS error %d: %s"):format(error.code or 0, (tostring(error.message or "JSON-RPC error"))), error.code
		end

		if p2.statusCode >= 200 and p2.statusCode < 300 then
			return if typeof(v11) ~= "table" then nil else v11.result, nil, nil
		end

		local v16 = if typeof(p2.responseBody) ~= "buffer" then p2.responseBody or "" else buffer.tostring(p2.responseBody)

		return nil, ("CAS HTTP %d: %s"):format(p2.statusCode, v16), nil
	end
end

return rpcDecoder
