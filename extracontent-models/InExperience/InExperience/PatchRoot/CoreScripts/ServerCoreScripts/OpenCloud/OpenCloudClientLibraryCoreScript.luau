local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")
local OpenCloudService = game:GetService("OpenCloudService")
local RunService = game:GetService("RunService")

function InvalidArgumentError(message: string)
	return {
		StatusCode = 400,
		Body = HttpService:JSONEncode({ code = "INVALID_ARGUMENT", message = message })
	}
end

function verifyTable(p, p2)
	if not (p ~= nil and typeof(p) ~= "table") then
		return nil
	end

	return InvalidArgumentError(`Argument not a table: {p2}.`)
end

function verifyNumber(value, p)
	if not (value ~= nil and typeof(value) ~= "number") then
		return nil
	end

	return InvalidArgumentError(`Argument not a number: {p}.`)
end

function verifyString(value, p)
	if not (value ~= nil and typeof(value) ~= "string") then
		return nil
	end

	return InvalidArgumentError(`Argument not a string: {p}.`)
end

function verifyEnum(value, p)
	if value == nil or (typeof(value) == "number" or typeof(value) == "string") then
		return nil
	end

	return InvalidArgumentError(`Argument not an enum: {p}.`)
end

function getApisUrl()
	local baseUrl = ContentProvider.BaseUrl:lower()
	local v = string.gsub(baseUrl, "http:", "https:")
	return string.gsub(v, "www", "apis")
end

function getUrlPrefix(p): string
	if p ~= nil and p["x-api-key"] ~= nil then
		return ""
	end

	return if RunService:IsStudio() then "user" else "rcc"
end

function verifyGetUniverseRequest(p, p2)
	if p == nil then
		return nil
	end

	local v = verifyTable(p, p2)

	if v ~= nil then
		return v
	end

	if p.path == nil then
		return InvalidArgumentError(`Required argument was not provided: {p2}.path.`)
	end

	local v2 = verifyString(p.path, `{p2}.path`)
	return if v2 ~= nil then v2 else nil
end

function getUniverseUrl(p, p2)
	if p.path == nil then
		return InvalidArgumentError("URL parameter provided was nil: getUniverseRequest.path.")
	end

	if string.match(p.path, "^universes/([^/]+)$") == nil then
		return InvalidArgumentError("URL parameter was not formatted correctly: getUniverseRequest.path.")
	end

	return (string.format("%s%s/cloud/v2/%s", getApisUrl(), getUrlPrefix(p2), (tostring(p.path))))
end

function getUniverse(p, headers)
	if p == nil then
		return InvalidArgumentError("Request provided was nil.")
	end

	local v = verifyGetUniverseRequest(p, "getUniverseRequest")

	if v ~= nil then
		return v
	end

	local universeUrl = getUniverseUrl(p, headers)

	if typeof(universeUrl) == "string" then
		return OpenCloudService:HttpRequestAsync({
			["Url"] = universeUrl,
			Request_Type = "GET",
			Headers = headers
		})
	end

	return universeUrl
end

OpenCloudService:RegisterOpenCloud("v2", "GetUniverse", getUniverse)

function verifyTranslateTextRequest(data, p)
	if data == nil then
		return nil
	end

	local v = verifyTable(data, p)

	if v ~= nil then
		return v
	end

	if data.path == nil then
		return InvalidArgumentError(`Required argument was not provided: {p}.path.`)
	end

	local v2 = verifyString(data.path, `{p}.path`)

	if v2 ~= nil then
		return v2
	end

	if data.text == nil then
		return InvalidArgumentError(`Required argument was not provided: {p}.text.`)
	end

	local v3 = verifyString(data.text, `{p}.text`)

	if v3 ~= nil then
		return v3
	end

	local v4 = verifyString(data.sourceLanguageCode, `{p}.sourceLanguageCode`)

	if v4 ~= nil then
		return v4
	end

	for k, targetLanguageCode in data.targetLanguageCodes do
		local v5 = verifyString(targetLanguageCode, `{p}.targetLanguageCodes[{k}]`)

		if v5 ~= nil then
			return v5
		end
	end

	return nil
end

function translateTextUrl(p)
	if p.path == nil then
		return InvalidArgumentError("URL parameter provided was nil: translateTextRequest.path.")
	end

	if string.match(p.path, "^universes/([^/]+)$") == nil then
		return InvalidArgumentError("URL parameter was not formatted correctly: translateTextRequest.path.")
	end

	return (string.format("%s%s/cloud/v2/%s:translateText", getApisUrl(), getUrlPrefix(), (tostring(p.path))))
end

function translateText(p)
	if p == nil then
		return InvalidArgumentError("Request provided was nil.")
	end

	local v = verifyTranslateTextRequest(p, "translateTextRequest")

	if v ~= nil then
		return v
	end

	local url = translateTextUrl(p)

	if typeof(url) == "string" then
		return OpenCloudService:HttpRequestAsync({
			["Url"] = url,
			Request_Type = "POST",
			Body = HttpService:JSONEncode(p)
		})
	end

	return url
end

OpenCloudService:RegisterOpenCloud("v2", "TranslateText", translateText)

function verifyGenerateSpeechRequest(data, p)
	if data == nil then
		return nil
	end

	local v = verifyTable(data, p)

	if v ~= nil then
		return v
	end

	if data.path == nil then
		return InvalidArgumentError(`Required argument was not provided: {p}.path.`)
	end

	local v2 = verifyString(data.path, `{p}.path`)

	if v2 ~= nil then
		return v2
	end

	if data.text == nil then
		return InvalidArgumentError(`Required argument was not provided: {p}.text.`)
	end

	local v3 = verifyString(data.text, `{p}.text`)

	if v3 ~= nil then
		return v3
	end

	local v4 = verifyGeneratedSpeechStyle(data.speechStyle, `{p}.speechStyle`)
	return if v4 ~= nil then v4 else nil
end

function verifyGeneratedSpeechStyle(data, p)
	if data == nil then
		return nil
	end

	local v = verifyTable(data, p)

	if v ~= nil then
		return v
	end

	local v2 = verifyString(data.voiceId, `{p}.voiceId`)

	if v2 ~= nil then
		return v2
	end

	local v3 = verifyNumber(data.pitch, `{p}.pitch`)

	if v3 ~= nil then
		return v3
	end

	local v4 = verifyNumber(data.speed, `{p}.speed`)
	return if v4 ~= nil then v4 else nil
end

function generateSpeechUrl(p)
	if p.path == nil then
		return InvalidArgumentError("URL parameter provided was nil: generateSpeechRequest.path.")
	end

	if string.match(p.path, "^universes/([^/]+)$") == nil then
		return InvalidArgumentError("URL parameter was not formatted correctly: generateSpeechRequest.path.")
	end

	return (string.format("%s%s/cloud/v2/%s:generateSpeech", getApisUrl(), getUrlPrefix(), (tostring(p.path))))
end

function generateSpeech(p)
	if p == nil then
		return InvalidArgumentError("Request provided was nil.")
	end

	local v = verifyGenerateSpeechRequest(p, "generateSpeechRequest")

	if v ~= nil then
		return v
	end

	local url = generateSpeechUrl(p)

	if typeof(url) == "string" then
		return OpenCloudService:HttpRequestAsync({
			["Url"] = url,
			Request_Type = "POST",
			Body = HttpService:JSONEncode(p)
		})
	end

	return url
end

OpenCloudService:RegisterOpenCloud("v2", "GenerateSpeech", generateSpeech)

function verifyGenerateTextRequest(data, p)
	if data == nil then
		return nil
	end

	local v = verifyTable(data, p)

	if v ~= nil then
		return v
	end

	if data.path == nil then
		return InvalidArgumentError(`Required argument was not provided: {p}.path.`)
	end

	local v2 = verifyString(data.path, `{p}.path`)

	if v2 ~= nil then
		return v2
	end

	local v3 = verifyString(data.userPrompt, `{p}.userPrompt`)

	if v3 ~= nil then
		return v3
	end

	local v4 = verifyString(data.systemPrompt, `{p}.systemPrompt`)

	if v4 ~= nil then
		return v4
	end

	local v5 = verifyNumber(data.temperature, `{p}.temperature`)

	if v5 ~= nil then
		return v5
	end

	local v6 = verifyNumber(data.topP, `{p}.topP`)

	if v6 ~= nil then
		return v6
	end

	local v7 = verifyNumber(data.maxTokens, `{p}.maxTokens`)

	if v7 ~= nil then
		return v7
	end

	local v8 = verifyNumber(data.seed, `{p}.seed`)

	if v8 ~= nil then
		return v8
	end

	local v9 = verifyString(data.contextToken, `{p}.contextToken`)

	if v9 ~= nil then
		return v9
	end

	local v10 = verifyString(data.model, `{p}.model`)
	return if v10 ~= nil then v10 else nil
end

function generateTextUrl(p)
	if p.path == nil then
		return InvalidArgumentError("URL parameter provided was nil: generateTextRequest.path.")
	end

	if string.match(p.path, "^universes/([^/]+)$") == nil then
		return InvalidArgumentError("URL parameter was not formatted correctly: generateTextRequest.path.")
	end

	return (string.format("%s%s/cloud/v2/%s:generateText", getApisUrl(), getUrlPrefix(), (tostring(p.path))))
end

function generateText(p)
	if p == nil then
		return InvalidArgumentError("Request provided was nil.")
	end

	local v = verifyGenerateTextRequest(p, "generateTextRequest")

	if v ~= nil then
		return v
	end

	local url = generateTextUrl(p)

	if typeof(url) == "string" then
		return OpenCloudService:HttpRequestAsync({
			["Url"] = url,
			Request_Type = "POST",
			Body = HttpService:JSONEncode(p)
		})
	end

	return url
end

OpenCloudService:RegisterOpenCloud("v2", "GenerateText", generateText)

function verifyGetPlaceRequest(p, p2)
	if p == nil then
		return nil
	end

	local v = verifyTable(p, p2)

	if v ~= nil then
		return v
	end

	if p.path == nil then
		return InvalidArgumentError(`Required argument was not provided: {p2}.path.`)
	end

	local v2 = verifyString(p.path, `{p2}.path`)
	return if v2 ~= nil then v2 else nil
end

function getPlaceUrl(p, p2)
	if p.path == nil then
		return InvalidArgumentError("URL parameter provided was nil: getPlaceRequest.path.")
	end

	if string.match(p.path, "^universes/([^/]+)/places/([^/]+)$") == nil then
		return InvalidArgumentError("URL parameter was not formatted correctly: getPlaceRequest.path.")
	end

	return (string.format("%s%s/cloud/v2/%s", getApisUrl(), getUrlPrefix(p2), (tostring(p.path))))
end

function getPlace(p, headers)
	if p == nil then
		return InvalidArgumentError("Request provided was nil.")
	end

	local v = verifyGetPlaceRequest(p, "getPlaceRequest")

	if v ~= nil then
		return v
	end

	local placeUrl = getPlaceUrl(p, headers)

	if typeof(placeUrl) == "string" then
		return OpenCloudService:HttpRequestAsync({
			["Url"] = placeUrl,
			Request_Type = "GET",
			Headers = headers
		})
	end

	return placeUrl
end

OpenCloudService:RegisterOpenCloud("v2", "GetPlace", getPlace)

function verifyGetGroupRequest(p, p2)
	if p == nil then
		return nil
	end

	local v = verifyTable(p, p2)

	if v ~= nil then
		return v
	end

	if p.path == nil then
		return InvalidArgumentError(`Required argument was not provided: {p2}.path.`)
	end

	local v2 = verifyString(p.path, `{p2}.path`)
	return if v2 ~= nil then v2 else nil
end

function getGroupUrl(p, p2)
	if p.path == nil then
		return InvalidArgumentError("URL parameter provided was nil: getGroupRequest.path.")
	end

	if string.match(p.path, "^groups/([^/]+)$") == nil then
		return InvalidArgumentError("URL parameter was not formatted correctly: getGroupRequest.path.")
	end

	return (string.format("%s%s/cloud/v2/%s", getApisUrl(), getUrlPrefix(p2), (tostring(p.path))))
end

function getGroup(p, headers)
	if p == nil then
		return InvalidArgumentError("Request provided was nil.")
	end

	local v = verifyGetGroupRequest(p, "getGroupRequest")

	if v ~= nil then
		return v
	end

	local groupUrl = getGroupUrl(p, headers)

	if typeof(groupUrl) == "string" then
		return OpenCloudService:HttpRequestAsync({
			["Url"] = groupUrl,
			Request_Type = "GET",
			Headers = headers
		})
	end

	return groupUrl
end

OpenCloudService:RegisterOpenCloud("v2", "GetGroup", getGroup)

function verifyListInventoryItemsRequest(data, p)
	if data == nil then
		return nil
	end

	local v = verifyTable(data, p)

	if v ~= nil then
		return v
	end

	if data.parent == nil then
		return InvalidArgumentError(`Required argument was not provided: {p}.parent.`)
	end

	local v2 = verifyString(data.parent, `{p}.parent`)

	if v2 ~= nil then
		return v2
	end

	local v3 = verifyNumber(data.maxPageSize, `{p}.maxPageSize`)

	if v3 ~= nil then
		return v3
	end

	local v4 = verifyString(data.pageToken, `{p}.pageToken`)

	if v4 ~= nil then
		return v4
	end

	local v5 = verifyString(data.filter, `{p}.filter`)
	return if v5 ~= nil then v5 else nil
end

function listInventoryItemsUrl(data, p)
	if data.parent == nil then
		return InvalidArgumentError("URL parameter provided was nil: listInventoryItemsRequest.parent.")
	end

	if string.match(data.parent, "^users/([^/]+)$") == nil then
		return InvalidArgumentError("URL parameter was not formatted correctly: listInventoryItemsRequest.parent.")
	end

	local v = string.format("%s%s/cloud/v2/%s/inventory-items", getApisUrl(), getUrlPrefix(p), (tostring(data.parent)))

	if data.maxPageSize == nil and data.pageToken == nil and data.filter == nil then
		return v
	end

	local v2 = {}

	if data.maxPageSize ~= nil then
		table.insert(v2, string.format("maxPageSize=%s", (tostring(data.maxPageSize))))
	end

	if data.pageToken ~= nil then
		table.insert(v2, string.format("pageToken=%s", (tostring(data.pageToken))))
	end

	if data.filter ~= nil then
		table.insert(v2, string.format("filter=%s", (tostring(data.filter))))
	end

	return (string.format("%s?%s", v, table.concat(v2, "&")))
end

function listInventoryItems(p, headers)
	if p == nil then
		return InvalidArgumentError("Request provided was nil.")
	end

	local v = verifyListInventoryItemsRequest(p, "listInventoryItemsRequest")

	if v ~= nil then
		return v
	end

	local url = listInventoryItemsUrl(p, headers)

	if typeof(url) == "string" then
		return OpenCloudService:HttpRequestAsync({
			["Url"] = url,
			Request_Type = "GET",
			Headers = headers
		})
	end

	return url
end

OpenCloudService:RegisterOpenCloud("v2", "ListInventoryItems", listInventoryItems)

function verifyListGroupMembershipsRequest(data, p)
	if data == nil then
		return nil
	end

	local v = verifyTable(data, p)

	if v ~= nil then
		return v
	end

	if data.parent == nil then
		return InvalidArgumentError(`Required argument was not provided: {p}.parent.`)
	end

	local v2 = verifyString(data.parent, `{p}.parent`)

	if v2 ~= nil then
		return v2
	end

	local v3 = verifyNumber(data.maxPageSize, `{p}.maxPageSize`)

	if v3 ~= nil then
		return v3
	end

	local v4 = verifyString(data.pageToken, `{p}.pageToken`)

	if v4 ~= nil then
		return v4
	end

	local v5 = verifyString(data.filter, `{p}.filter`)
	return if v5 ~= nil then v5 else nil
end

function listGroupMembershipsUrl(data, p)
	if data.parent == nil then
		return InvalidArgumentError("URL parameter provided was nil: listGroupMembershipsRequest.parent.")
	end

	if string.match(data.parent, "^groups/([^/]+)$") == nil then
		return InvalidArgumentError("URL parameter was not formatted correctly: listGroupMembershipsRequest.parent.")
	end

	local v = string.format("%s%s/cloud/v2/%s/memberships", getApisUrl(), getUrlPrefix(p), (tostring(data.parent)))

	if data.maxPageSize == nil and data.pageToken == nil and data.filter == nil then
		return v
	end

	local v2 = {}

	if data.maxPageSize ~= nil then
		table.insert(v2, string.format("maxPageSize=%s", (tostring(data.maxPageSize))))
	end

	if data.pageToken ~= nil then
		table.insert(v2, string.format("pageToken=%s", (tostring(data.pageToken))))
	end

	if data.filter ~= nil then
		table.insert(v2, string.format("filter=%s", (tostring(data.filter))))
	end

	return (string.format("%s?%s", v, table.concat(v2, "&")))
end

function listGroupMemberships(p, headers)
	if p == nil then
		return InvalidArgumentError("Request provided was nil.")
	end

	local v = verifyListGroupMembershipsRequest(p, "listGroupMembershipsRequest")

	if v ~= nil then
		return v
	end

	local url = listGroupMembershipsUrl(p, headers)

	if typeof(url) == "string" then
		return OpenCloudService:HttpRequestAsync({
			["Url"] = url,
			Request_Type = "GET",
			Headers = headers
		})
	end

	return url
end

OpenCloudService:RegisterOpenCloud("v2", "ListGroupMemberships", listGroupMemberships)

function verifyGetOperationRequest(p, p2)
	if p == nil then
		return nil
	end

	local v = verifyTable(p, p2)

	if v ~= nil then
		return v
	end

	if p.path == nil then
		return InvalidArgumentError(`Required argument was not provided: {p2}.path.`)
	end

	local v2 = verifyString(p.path, `{p2}.path`)
	return if v2 ~= nil then v2 else nil
end

function getOperationUrl(p, p2)
	if p.path == nil then
		return InvalidArgumentError("URL parameter provided was nil: getOperationRequest.path.")
	end

	if string.match(p.path, "^users/([^/]+)/operations/([^/]+)$") == nil then
		return InvalidArgumentError("URL parameter was not formatted correctly: getOperationRequest.path.")
	end

	return (string.format("%s%s/cloud/v2/%s", getApisUrl(), getUrlPrefix(p2), (tostring(p.path))))
end

function getOperation(p, headers)
	if p == nil then
		return InvalidArgumentError("Request provided was nil.")
	end

	local v = verifyGetOperationRequest(p, "getOperationRequest")

	if v ~= nil then
		return v
	end

	local operationUrl = getOperationUrl(p, headers)

	if typeof(operationUrl) == "string" then
		return OpenCloudService:HttpRequestAsync({
			["Url"] = operationUrl,
			Request_Type = "GET",
			Headers = headers
		})
	end

	return operationUrl
end

OpenCloudService:RegisterOpenCloud("v2", "GetOperation", getOperation)

function verifyGenerateUserThumbnailRequest(data, p)
	if data == nil then
		return nil
	end

	local v = verifyTable(data, p)

	if v ~= nil then
		return v
	end

	if data.path == nil then
		return InvalidArgumentError(`Required argument was not provided: {p}.path.`)
	end

	local v2 = verifyString(data.path, `{p}.path`)

	if v2 ~= nil then
		return v2
	end

	local v3 = verifyNumber(data.size, `{p}.size`)

	if v3 ~= nil then
		return v3
	end

	local v4 = verifyEnum(data.format, `{p}.format`)

	if v4 ~= nil then
		return v4
	end

	local v5 = verifyEnum(data.shape, `{p}.shape`)
	return if v5 ~= nil then v5 else nil
end

function generateUserThumbnailUrl(data, p)
	if data.path == nil then
		return InvalidArgumentError("URL parameter provided was nil: generateUserThumbnailRequest.path.")
	end

	if string.match(data.path, "^users/([^/]+)$") == nil then
		return InvalidArgumentError("URL parameter was not formatted correctly: generateUserThumbnailRequest.path.")
	end

	local v = string.format("%s%s/cloud/v2/%s:generateThumbnail", getApisUrl(), getUrlPrefix(p), (tostring(data.path)))

	if data.size == nil and data.format == nil and data.shape == nil then
		return v
	end

	local v2 = {}

	if data.size ~= nil then
		table.insert(v2, string.format("size=%s", (tostring(data.size))))
	end

	if data.format ~= nil then
		table.insert(v2, string.format("format=%s", (tostring(data.format))))
	end

	if data.shape ~= nil then
		table.insert(v2, string.format("shape=%s", (tostring(data.shape))))
	end

	return (string.format("%s?%s", v, table.concat(v2, "&")))
end

function generateUserThumbnail(p, headers)
	if p == nil then
		return InvalidArgumentError("Request provided was nil.")
	end

	local v = verifyGenerateUserThumbnailRequest(p, "generateUserThumbnailRequest")

	if v ~= nil then
		return v
	end

	local url = generateUserThumbnailUrl(p, headers)

	if typeof(url) == "string" then
		return OpenCloudService:HttpRequestAsync({
			["Url"] = url,
			Request_Type = "GET",
			Headers = headers
		})
	end

	return url
end

OpenCloudService:RegisterOpenCloud("v2", "GenerateUserThumbnail", generateUserThumbnail)

OpenCloudService:RegistrationComplete()
