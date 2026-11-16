local HttpService = game:GetService("HttpService")

local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

local withCsrfRetry = require(DataHydration.withCsrfRetry)
require(script.Parent.UniverseCreateStoreTypes)

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

local function decode(p)
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

	if typeof(result) == "table" and typeof(result.code) == "string" and typeof(result.message) == "string" then
		return nil, ("%s: %s"):format(result.code, result.message), p.statusCode
	end

	if not (p.statusCode < 200 or p.statusCode >= 300) then
		return result, nil, nil
	end

	local v

	if typeof(p.responseBody) == "buffer" then
		v = buffer.tostring(p.responseBody)
	else
		v = p.responseBody or ""
	end

	return nil, ("http %d: %s"):format(p.statusCode, v), p.statusCode
end

local function fetchUniverseCreate(body, options)
	local v = options or {}

	local network = v.network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
	local baseUrl = v.baseUrl or UrlBase.APIS

	local request = HttpClient.createRequest({
		networkImpl = network,
		method = "POST",
		url = baseUrl .. "/universes/v1/universes/create",
		body = body,
		analyticsKey = "universes-create.create",
		decode = decode
	})

	return HttpClient.asPromise(request)
end

return fetchUniverseCreate
