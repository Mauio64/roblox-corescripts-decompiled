local HttpService = game:GetService("HttpService")
local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpClient = require(DataHydrationParent.HttpClient)
local UrlBase = require(DataHydrationParent.UrlBuilder).UrlBase
local withCsrfRetry = require(DataHydration.withCsrfRetry)

require(script.Parent.UniverseCreateStoreTypes)

local function tryJsonDecode(p1) -- line: 15
	-- upvalues: HttpService (copy)
	if p1 == nil or p1 == "" then
		return nil
	end

	local v11 = if typeof(p1) ~= "buffer" then p1 else buffer.tostring(p1)
	local ok, result = pcall(HttpService.JSONDecode, HttpService, v11)

	if ok then
		return result
	end

	return nil
end
local function decode(p2) -- line: 25
	-- upvalues: HttpService (copy)
	local responseBody = p2.responseBody
	local v16

	if responseBody == nil or responseBody == "" then
		v16 = nil
	else
		local v17 = if typeof(responseBody) ~= "buffer" then responseBody else buffer.tostring(responseBody)
		local ok, result = pcall(HttpService.JSONDecode, HttpService, v17)

		v16 = if not ok then nil else result
	end

	if typeof(v16) == "table" and typeof(v16.code) == "string" and typeof(v16.message) == "string" then
		return nil, ("%s: %s"):format(v16.code, v16.message), p2.statusCode
	end

	if p2.statusCode < 200 or p2.statusCode >= 300 then
		local v20 = if typeof(p2.responseBody) ~= "buffer" then p2.responseBody or "" else buffer.tostring(p2.responseBody)

		return nil, ("http %d: %s"):format(p2.statusCode, v20), p2.statusCode
	end

	return v16, nil, nil
end
local function fetchUniverseCreate(p3, t1: {[any]: any}?) -- line: 43
	-- upvalues: withCsrfRetry (copy), HttpClient (copy), UrlBase (copy), decode (copy)
	local v23 = t1 or {}
	local v24 = v23.network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
	local v25 = v23.baseUrl or UrlBase.APIS
	local v26 = HttpClient.createRequest({
		method = "POST",
		analyticsKey = "universes-create.create",
		networkImpl = v24,
		url = v25 .. "/universes/v1/universes/create",
		body = p3,
		decode = decode
	})

	return HttpClient.asPromise(v26)
end

return fetchUniverseCreate
