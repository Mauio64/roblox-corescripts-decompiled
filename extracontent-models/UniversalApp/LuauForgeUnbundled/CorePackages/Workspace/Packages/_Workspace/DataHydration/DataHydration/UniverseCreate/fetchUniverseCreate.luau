local HttpService = game:GetService("HttpService")

local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBase

local withCsrfRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/withCsrfRetry")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseCreate/UniverseCreateStoreTypes")

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

local function decode(p2)
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

	if
		typeof(result) == "table"
		and typeof(result.code) == "string"
		and typeof(result.message) == "string"
	then
		return nil, ("%s: %s"):format(result.code, result.message), p2.statusCode
	end

	if not (p2.statusCode < 200 or p2.statusCode >= 300) then
		return result, nil, nil
	end

	local v5

	if typeof(p2.responseBody) == "buffer" then
		v5 = buffer.tostring(p2.responseBody)
	else
		v5 = p2.responseBody or ""
	end

	return nil, ("http %d: %s"):format(p2.statusCode, v5), p2.statusCode
end

local function fetchUniverseCreate(p2, options)
	local v5 = options or {}

	local network = v5.network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
	local baseUrl = v5.baseUrl or urlBase.APIS

	local request = HttpClient.createRequest({
		networkImpl = network,
		method = "POST",
		url = baseUrl .. "/universes/v1/universes/create",
		body = p2,
		analyticsKey = "universes-create.create",
		decode = decode
	})

	return HttpClient.asPromise(request)
end

return fetchUniverseCreate
