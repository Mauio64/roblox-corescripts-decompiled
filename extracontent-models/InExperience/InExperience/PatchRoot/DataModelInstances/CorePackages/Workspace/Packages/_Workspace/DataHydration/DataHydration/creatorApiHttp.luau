local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpService = game:GetService("HttpService")

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

local withCsrfRetry = require(DataHydration.withCsrfRetry)

local CreatorApiHttp = {}

function CreatorApiHttp.baseUrl(options)
	return (options or {}).baseUrl or UrlBase.APIS
end

function CreatorApiHttp.withoutRestrictedAcceptHeader(p)
	return {
		request = function(p2, callback)
			local headers

			if p2.headers ~= nil then
				headers = {}

				for k, header in p2.headers do
					if string.lower(k) ~= "accept" then
						headers[k] = header
					end
				end
			end

			local clone = table.clone(p2)
			clone.headers = headers
			return p.request(clone, callback)
		end
	}
end

function CreatorApiHttp.readNetwork(options)
	local v = options or {}
	local readNetwork = v.readNetwork or v.network

	if readNetwork ~= nil then
		return CreatorApiHttp.withoutRestrictedAcceptHeader(readNetwork)
	end

	local requestInternalNetwork = HttpClient.createRequestInternalNetwork()
	local withoutRestrictedAcceptHeader = CreatorApiHttp.withoutRestrictedAcceptHeader

	if v.retryReads ~= false then
		requestInternalNetwork = HttpClient.withRetry(requestInternalNetwork)
	end

	return withoutRestrictedAcceptHeader(requestInternalNetwork)
end

function CreatorApiHttp.mutatingNetwork(options)
	local v = options or {}
	return CreatorApiHttp.withoutRestrictedAcceptHeader(v.mutatingNetwork or v.network or withCsrfRetry(HttpClient.createRequestInternalNetwork()))
end

function CreatorApiHttp.imagePart(data)
	return {
		name = "imageFile",
		value = data.content,
		fileName = data.fileName,
		contentType = data.contentType
	}
end

function CreatorApiHttp.buildMultipartBody(items)
	local v = {}

	for _, item in items do
		local v2

		if item.fileName == nil then
			v2 = ("Content-Disposition: form-data; name=\"%s\""):format(item.name)
		else
			v2 = ("Content-Disposition: form-data; name=\"%s\"; filename=\"%s\""):format(item.name, item.fileName)
		end

		table.insert(
			v,
			"--" .. "-------CreatorMonetizationFormBoundary" .. "\r\n" .. v2 .. "\r\n" .. (item.contentType == nil and "" or "Content-Type: " .. item.contentType .. "\r\n") .. "\r\n" .. item.value .. "\r\n"
		)
	end

	table.insert(v, "---------CreatorMonetizationFormBoundary--\r\n")
	return table.concat(v)
end

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

local function isOk(statusCode: number): boolean -- 2 equivalent calls inferred from this helper
	return statusCode >= 200 and statusCode < 300
end

function CreatorApiHttp.errorFrom(p)
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

	if typeof(result) == "table" then
		local errorMessage = result.errorMessage or result.message

		if typeof(errorMessage) == "string" then
			if typeof(result.errorCode) == "string" then
				errorMessage = `{result.errorCode}: {errorMessage}`
			end

			return errorMessage, p.statusCode
		end
	end

	local v

	if typeof(p.responseBody) == "buffer" then
		v = buffer.tostring(p.responseBody)
	else
		v = p.responseBody or ""
	end

	return ("http %d: %s"):format(p.statusCode, v), p.statusCode
end

function CreatorApiHttp.jsonDecoder(callback)
	return function(p)
		if not isOk(p.statusCode) then -- inferred equivalent call
			local v, v2 = CreatorApiHttp.errorFrom(p)
			return nil, v, v2
		end

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

		return callback(result), nil, nil
	end
end

function CreatorApiHttp.noContentDecoder(callback)
	return function(p)
		if isOk(p.statusCode) then -- inferred equivalent call
			return callback(), nil, nil
		end

		local v, v2 = CreatorApiHttp.errorFrom(p)
		return nil, v, v2
	end
end

function CreatorApiHttp.multipart(networkImpl, method: string, url: string, p, analyticsKey: string, decode)
	return HttpClient.asPromise(HttpClient.createRequest({
		networkImpl = networkImpl,
		method = method,
		url = url,
		body = CreatorApiHttp.buildMultipartBody(p),
		headers = {},
		encode = HttpClient.encodeRaw("multipart/form-data; boundary=-------CreatorMonetizationFormBoundary"),
		decode = decode,
		analyticsKey = analyticsKey
	}))
end

function CreatorApiHttp.json(networkImpl, method: string, url: string, body, analyticsKey: string, decode)
	return HttpClient.asPromise(HttpClient.createRequest({
		networkImpl = networkImpl,
		method = method,
		url = url,
		body = body,
		headers = {},
		decode = decode,
		analyticsKey = analyticsKey
	}))
end

function CreatorApiHttp.get(p, url: string, analyticsKey: string, callback)
	return HttpClient.asPromise(HttpClient.createRequest({
		networkImpl = CreatorApiHttp.readNetwork(p),
		method = "GET",
		url = url,
		body = nil,
		headers = {},
		analyticsKey = analyticsKey,
		decode = CreatorApiHttp.jsonDecoder(callback)
	}))
end

function CreatorApiHttp.withQuery(p: string, items)
	local v = {}

	for k, item in items do
		if item ~= nil and item ~= "" then
			v[k] = item
		end
	end

	if next(v) == nil then
		return p
	end

	return UrlBuilder.UrlBuilder.addQueryString(p, v)
end

return CreatorApiHttp
