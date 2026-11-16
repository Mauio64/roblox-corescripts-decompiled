local HttpService = game:GetService("HttpService")

local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder")
local urlBase = UrlBuilder.UrlBase

local withCsrfRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/withCsrfRetry")

local v5 = {}

function v5.baseUrl(options)
	return (options or {}).baseUrl or urlBase.APIS
end

function v5.withoutRestrictedAcceptHeader(p2)
	return {
		request = function(p3, p4)
			local headers

			if p3.headers ~= nil then
				headers = {}

				for k, header in p3.headers do
					if string.lower(k) ~= "accept" then
						headers[k] = header
					end
				end
			end

			local clone = table.clone(p3)
			clone.headers = headers
			return p2.request(clone, p4)
		end
	}
end

function v5.readNetwork(options)
	local v6 = options or {}
	local readNetwork = v6.readNetwork or v6.network

	if readNetwork ~= nil then
		return v5.withoutRestrictedAcceptHeader(readNetwork)
	end

	local requestInternalNetwork = HttpClient.createRequestInternalNetwork()
	local withoutRestrictedAcceptHeader = v5.withoutRestrictedAcceptHeader

	if v6.retryReads ~= false then
		requestInternalNetwork = HttpClient.withRetry(requestInternalNetwork)
	end

	return withoutRestrictedAcceptHeader(requestInternalNetwork)
end

function v5.mutatingNetwork(options)
	local v6 = options or {}
	return v5.withoutRestrictedAcceptHeader(v6.mutatingNetwork or v6.network or withCsrfRetry(HttpClient.createRequestInternalNetwork()))
end

function v5.imagePart(data)
	return {
		name = "imageFile",
		value = data.content,
		fileName = data.fileName,
		contentType = data.contentType
	}
end

function v5.buildMultipartBody(items)
	local v6 = {}

	for k, item in items do
		local v7 = if item.fileName == nil then ("Content-Disposition: form-data; name=\"%s\""):format(item.name) else ("Content-Disposition: form-data; name=\"%s\"; filename=\"%s\""):format(
			item.name,
			item.fileName
		)
		table.insert(
			v6,
			"--" .. "-------CreatorMonetizationFormBoundary" .. "\r\n" .. v7 .. "\r\n" .. (item.contentType == nil and "" or "Content-Type: " .. item.contentType .. "\r\n") .. "\r\n" .. item.value .. "\r\n"
		)
	end

	table.insert(v6, "---------CreatorMonetizationFormBoundary--\r\n")
	return table.concat(v6)
end

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

local function isOk(p2): boolean
	return p2 >= 200 and p2 < 300
end

function v5.errorFrom(p2)
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

	if typeof(result) == "table" then
		local errorMessage = result.errorMessage or result.message

		if typeof(errorMessage) == "string" then
			if typeof(result.errorCode) == "string" then
				errorMessage = `{result.errorCode}: {errorMessage}`
			end

			return errorMessage, p2.statusCode
		end
	end

	local v6

	if typeof(p2.responseBody) == "buffer" then
		v6 = buffer.tostring(p2.responseBody)
	else
		v6 = p2.responseBody or ""
	end

	return ("http %d: %s"):format(p2.statusCode, v6), p2.statusCode
end

function v5.jsonDecoder(p2)
	return function(p3)
		local statusCode = p3.statusCode
		local v6 = statusCode >= 200 and statusCode < 300

		if not v6 then
			local v7, v8 = v5.errorFrom(p3)
			return nil, v7, v8
		end

		local responseBody = p3.responseBody
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

		return p2(result), nil, nil
	end
end

function v5.noContentDecoder(callback)
	return function(p2)
		local statusCode = p2.statusCode
		local v6 = statusCode >= 200 and statusCode < 300

		if v6 then
			return callback(), nil, nil
		end

		local v7, v8 = v5.errorFrom(p2)
		return nil, v7, v8
	end
end

function v5.multipart(p2, p3, p4, p5, p6, p7)
	return HttpClient.asPromise(HttpClient.createRequest({
		networkImpl = p2,
		method = p3,
		url = p4,
		body = v5.buildMultipartBody(p5),
		headers = {},
		encode = HttpClient.encodeRaw("multipart/form-data; boundary=-------CreatorMonetizationFormBoundary"),
		decode = p7,
		analyticsKey = p6
	}))
end

function v5.json(p2, p3, p4, p5, p6, p7)
	return HttpClient.asPromise(HttpClient.createRequest({
		networkImpl = p2,
		method = p3,
		url = p4,
		body = p5,
		headers = {},
		decode = p7,
		analyticsKey = p6
	}))
end

function v5.get(p2, p3, p4, p5)
	return HttpClient.asPromise(HttpClient.createRequest({
		networkImpl = v5.readNetwork(p2),
		method = "GET",
		url = p3,
		body = nil,
		headers = {},
		analyticsKey = p4,
		decode = v5.jsonDecoder(p5)
	}))
end

function v5.withQuery(p2, items)
	local v6 = {}

	for k, item in items do
		if item ~= nil and item ~= "" then
			v6[k] = item
		end
	end

	if next(v6) == nil then
		return p2
	end

	return UrlBuilder.UrlBuilder.addQueryString(p2, v6)
end

return v5
