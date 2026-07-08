local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")
local OpenCloudService = game:GetService("OpenCloudService")
local RunService = game:GetService("RunService")

function InvalidArgumentError(s1: string) -- line: 19
	-- upvalues: HttpService (copy)
	return {
		StatusCode = 400,
		Body = HttpService:JSONEncode({
			code = "INVALID_ARGUMENT",
			message = s1
		})
	}
end
function verifyTable(p1, p2) -- line: 37
	if p1 == nil then
		return nil
	end

	if typeof(p1) ~= "table" then
		return InvalidArgumentError(`Argument not a table: { p2 }.`)
	end

	return nil
end
function verifyNumber(p3, p4) -- line: 49
	if p3 == nil then
		return nil
	end

	if typeof(p3) ~= "number" then
		return InvalidArgumentError(`Argument not a number: { p4 }.`)
	end

	return nil
end
function verifyString(p5, p6) -- line: 61
	if p5 == nil then
		return nil
	end

	if typeof(p5) ~= "string" then
		return InvalidArgumentError(`Argument not a string: { p6 }.`)
	end

	return nil
end
function verifyEnum(p7, p8) -- line: 73
	if p7 == nil then
		return nil
	end

	if typeof(p7) ~= "number" and typeof(p7) ~= "string" then
		return InvalidArgumentError(`Argument not an enum: { p8 }.`)
	end

	return nil
end
function getApisUrl() -- line: 85
	-- upvalues: ContentProvider (copy)
	local v14 = ContentProvider.BaseUrl:lower()
	local v15 = string.gsub(v14, "http:", "https:")

	return string.gsub(v15, "www", "apis")
end
function getUrlPrefix(p9) -- line: 91
	-- upvalues: RunService (copy)
	if p9 ~= nil and p9["x-api-key"] ~= nil then
		return ""
	end

	if RunService:IsStudio() then
		return "user"
	end

	return "rcc"
end
function verifyGetUniverseRequest(p10, p11) -- line: 101
	if p10 == nil then
		return nil
	end

	local v19 = verifyTable(p10, p11)

	if v19 ~= nil then
		return v19
	end

	if p10.path == nil then
		return InvalidArgumentError(`Required argument was not provided: { p11 }.path.`)
	end

	local v20 = verifyString(p10.path, `{ p11 }.path`)

	if v20 ~= nil then
		return v20
	end

	return nil
end
function getUniverseUrl(p12, p13) -- line: 122
	if p12.path == nil then
		return InvalidArgumentError("URL parameter provided was nil: getUniverseRequest.path.")
	end

	if string.match(p12.path, "^universes/([^/]+)$") == nil then
		return InvalidArgumentError("URL parameter was not formatted correctly: getUniverseRequest.path.")
	end

	return (string.format("%s%s/cloud/v2/%s", getApisUrl(), getUrlPrefix(p13), (tostring(p12.path))))
end
function getUniverse(p14, p15) -- line: 135
	-- upvalues: OpenCloudService (copy)
	if p14 == nil then
		return InvalidArgumentError("Request provided was nil.")
	end

	local v25 = verifyGetUniverseRequest(p14, "getUniverseRequest")

	if v25 ~= nil then
		return v25
	end

	local v26 = getUniverseUrl(p14, p15)

	if typeof(v26) ~= "string" then
		return v26
	end

	return OpenCloudService:HttpRequestAsync({
		Url = v26,
		Request_Type = "GET",
		Headers = p15
	})
end

OpenCloudService:RegisterOpenCloud("v2", "GetUniverse", getUniverse)

function verifyTranslateTextRequest(p16, p17) -- line: 155
	if p16 == nil then
		return nil
	end

	local v29 = verifyTable(p16, p17)

	if v29 ~= nil then
		return v29
	end

	if p16.path == nil then
		return InvalidArgumentError(`Required argument was not provided: { p17 }.path.`)
	end

	local v30 = verifyString(p16.path, `{ p17 }.path`)

	if v30 ~= nil then
		return v30
	end

	if p16.text == nil then
		return InvalidArgumentError(`Required argument was not provided: { p17 }.text.`)
	end

	local v31 = verifyString(p16.text, `{ p17 }.text`)

	if v31 ~= nil then
		return v31
	end

	local v32 = verifyString(p16.sourceLanguageCode, `{ p17 }.sourceLanguageCode`)

	if v32 ~= nil then
		return v32
	end

	for v33, v34 in p16.targetLanguageCodes do
		local v35 = verifyString(v34, `{ p17 }.targetLanguageCodes[{ v33 }]`)

		if v35 ~= nil then
			return v35
		end
	end

	return nil
end
function translateTextUrl(p18) -- line: 196
	if p18.path == nil then
		return InvalidArgumentError("URL parameter provided was nil: translateTextRequest.path.")
	end

	if string.match(p18.path, "^universes/([^/]+)$") == nil then
		return InvalidArgumentError("URL parameter was not formatted correctly: translateTextRequest.path.")
	end

	return (string.format("%s%s/cloud/v2/%s:translateText", getApisUrl(), getUrlPrefix(), (tostring(p18.path))))
end
function translateText(p19) -- line: 209
	-- upvalues: HttpService (copy), OpenCloudService (copy)
	if p19 == nil then
		return InvalidArgumentError("Request provided was nil.")
	end

	local v38 = verifyTranslateTextRequest(p19, "translateTextRequest")

	if v38 ~= nil then
		return v38
	end

	local v39 = translateTextUrl(p19)

	if typeof(v39) ~= "string" then
		return v39
	end

	local json = HttpService:JSONEncode(p19)

	return OpenCloudService:HttpRequestAsync({
		Url = v39,
		Request_Type = "POST",
		Body = json
	})
end

OpenCloudService:RegisterOpenCloud("v2", "TranslateText", translateText)

function verifyGenerateSpeechRequest(p20, p21) -- line: 231
	if p20 == nil then
		return nil
	end

	local v43 = verifyTable(p20, p21)

	if v43 ~= nil then
		return v43
	end

	if p20.path == nil then
		return InvalidArgumentError(`Required argument was not provided: { p21 }.path.`)
	end

	local v44 = verifyString(p20.path, `{ p21 }.path`)

	if v44 ~= nil then
		return v44
	end

	if p20.text == nil then
		return InvalidArgumentError(`Required argument was not provided: { p21 }.text.`)
	end

	local v45 = verifyString(p20.text, `{ p21 }.text`)

	if v45 ~= nil then
		return v45
	end

	local v46 = verifyGeneratedSpeechStyle(p20.speechStyle, `{ p21 }.speechStyle`)

	if v46 ~= nil then
		return v46
	end

	return nil
end
function verifyGeneratedSpeechStyle(p22, p23) -- line: 265
	if p22 == nil then
		return nil
	end

	local v49 = verifyTable(p22, p23)

	if v49 ~= nil then
		return v49
	end

	local v50 = verifyString(p22.voiceId, `{ p23 }.voiceId`)

	if v50 ~= nil then
		return v50
	end

	local v51 = verifyNumber(p22.pitch, `{ p23 }.pitch`)

	if v51 ~= nil then
		return v51
	end

	local v52 = verifyNumber(p22.speed, `{ p23 }.speed`)

	if v52 ~= nil then
		return v52
	end

	return nil
end
function generateSpeechUrl(p24) -- line: 293
	if p24.path == nil then
		return InvalidArgumentError("URL parameter provided was nil: generateSpeechRequest.path.")
	end

	if string.match(p24.path, "^universes/([^/]+)$") == nil then
		return InvalidArgumentError("URL parameter was not formatted correctly: generateSpeechRequest.path.")
	end

	return (string.format("%s%s/cloud/v2/%s:generateSpeech", getApisUrl(), getUrlPrefix(), (tostring(p24.path))))
end
function generateSpeech(p25) -- line: 306
	-- upvalues: HttpService (copy), OpenCloudService (copy)
	if p25 == nil then
		return InvalidArgumentError("Request provided was nil.")
	end

	local v55 = verifyGenerateSpeechRequest(p25, "generateSpeechRequest")

	if v55 ~= nil then
		return v55
	end

	local v56 = generateSpeechUrl(p25)

	if typeof(v56) ~= "string" then
		return v56
	end

	local json = HttpService:JSONEncode(p25)

	return OpenCloudService:HttpRequestAsync({
		Url = v56,
		Request_Type = "POST",
		Body = json
	})
end

OpenCloudService:RegisterOpenCloud("v2", "GenerateSpeech", generateSpeech)

function verifyGenerateTextRequest(p26, p27) -- line: 328
	if p26 == nil then
		return nil
	end

	local v60 = verifyTable(p26, p27)

	if v60 ~= nil then
		return v60
	end

	if p26.path == nil then
		return InvalidArgumentError(`Required argument was not provided: { p27 }.path.`)
	end

	local v61 = verifyString(p26.path, `{ p27 }.path`)

	if v61 ~= nil then
		return v61
	end

	local v62 = verifyString(p26.userPrompt, `{ p27 }.userPrompt`)

	if v62 ~= nil then
		return v62
	end

	local v63 = verifyString(p26.systemPrompt, `{ p27 }.systemPrompt`)

	if v63 ~= nil then
		return v63
	end

	local v64 = verifyNumber(p26.temperature, `{ p27 }.temperature`)

	if v64 ~= nil then
		return v64
	end

	local v65 = verifyNumber(p26.topP, `{ p27 }.topP`)

	if v65 ~= nil then
		return v65
	end

	local v66 = verifyNumber(p26.maxTokens, `{ p27 }.maxTokens`)

	if v66 ~= nil then
		return v66
	end

	local v67 = verifyNumber(p26.seed, `{ p27 }.seed`)

	if v67 ~= nil then
		return v67
	end

	local v68 = verifyString(p26.contextToken, `{ p27 }.contextToken`)

	if v68 ~= nil then
		return v68
	end

	local v69 = verifyString(p26.model, `{ p27 }.model`)

	if v69 ~= nil then
		return v69
	end

	return nil
end
function generateTextUrl(p28) -- line: 389
	if p28.path == nil then
		return InvalidArgumentError("URL parameter provided was nil: generateTextRequest.path.")
	end

	if string.match(p28.path, "^universes/([^/]+)$") == nil then
		return InvalidArgumentError("URL parameter was not formatted correctly: generateTextRequest.path.")
	end

	return (string.format("%s%s/cloud/v2/%s:generateText", getApisUrl(), getUrlPrefix(), (tostring(p28.path))))
end
function generateText(p29) -- line: 402
	-- upvalues: HttpService (copy), OpenCloudService (copy)
	if p29 == nil then
		return InvalidArgumentError("Request provided was nil.")
	end

	local v72 = verifyGenerateTextRequest(p29, "generateTextRequest")

	if v72 ~= nil then
		return v72
	end

	local v73 = generateTextUrl(p29)

	if typeof(v73) ~= "string" then
		return v73
	end

	local json = HttpService:JSONEncode(p29)

	return OpenCloudService:HttpRequestAsync({
		Url = v73,
		Request_Type = "POST",
		Body = json
	})
end

OpenCloudService:RegisterOpenCloud("v2", "GenerateText", generateText)

function verifyGetPlaceRequest(p30, p31) -- line: 424
	if p30 == nil then
		return nil
	end

	local v77 = verifyTable(p30, p31)

	if v77 ~= nil then
		return v77
	end

	if p30.path == nil then
		return InvalidArgumentError(`Required argument was not provided: { p31 }.path.`)
	end

	local v78 = verifyString(p30.path, `{ p31 }.path`)

	if v78 ~= nil then
		return v78
	end

	return nil
end
function getPlaceUrl(p32, p33) -- line: 445
	if p32.path == nil then
		return InvalidArgumentError("URL parameter provided was nil: getPlaceRequest.path.")
	end

	if string.match(p32.path, "^universes/([^/]+)/places/([^/]+)$") == nil then
		return InvalidArgumentError("URL parameter was not formatted correctly: getPlaceRequest.path.")
	end

	return (string.format("%s%s/cloud/v2/%s", getApisUrl(), getUrlPrefix(p33), (tostring(p32.path))))
end
function getPlace(p34, p35) -- line: 458
	-- upvalues: OpenCloudService (copy)
	if p34 == nil then
		return InvalidArgumentError("Request provided was nil.")
	end

	local v83 = verifyGetPlaceRequest(p34, "getPlaceRequest")

	if v83 ~= nil then
		return v83
	end

	local v84 = getPlaceUrl(p34, p35)

	if typeof(v84) ~= "string" then
		return v84
	end

	return OpenCloudService:HttpRequestAsync({
		Url = v84,
		Request_Type = "GET",
		Headers = p35
	})
end

OpenCloudService:RegisterOpenCloud("v2", "GetPlace", getPlace)

function verifyGetGroupRequest(p36, p37) -- line: 478
	if p36 == nil then
		return nil
	end

	local v87 = verifyTable(p36, p37)

	if v87 ~= nil then
		return v87
	end

	if p36.path == nil then
		return InvalidArgumentError(`Required argument was not provided: { p37 }.path.`)
	end

	local v88 = verifyString(p36.path, `{ p37 }.path`)

	if v88 ~= nil then
		return v88
	end

	return nil
end
function getGroupUrl(p38, p39) -- line: 499
	if p38.path == nil then
		return InvalidArgumentError("URL parameter provided was nil: getGroupRequest.path.")
	end

	if string.match(p38.path, "^groups/([^/]+)$") == nil then
		return InvalidArgumentError("URL parameter was not formatted correctly: getGroupRequest.path.")
	end

	return (string.format("%s%s/cloud/v2/%s", getApisUrl(), getUrlPrefix(p39), (tostring(p38.path))))
end
function getGroup(p40, p41) -- line: 512
	-- upvalues: OpenCloudService (copy)
	if p40 == nil then
		return InvalidArgumentError("Request provided was nil.")
	end

	local v93 = verifyGetGroupRequest(p40, "getGroupRequest")

	if v93 ~= nil then
		return v93
	end

	local v94 = getGroupUrl(p40, p41)

	if typeof(v94) ~= "string" then
		return v94
	end

	return OpenCloudService:HttpRequestAsync({
		Url = v94,
		Request_Type = "GET",
		Headers = p41
	})
end

OpenCloudService:RegisterOpenCloud("v2", "GetGroup", getGroup)

function verifyListInventoryItemsRequest(p42, p43) -- line: 532
	if p42 == nil then
		return nil
	end

	local v97 = verifyTable(p42, p43)

	if v97 ~= nil then
		return v97
	end

	if p42.parent == nil then
		return InvalidArgumentError(`Required argument was not provided: { p43 }.parent.`)
	end

	local v98 = verifyString(p42.parent, `{ p43 }.parent`)

	if v98 ~= nil then
		return v98
	end

	local v99 = verifyNumber(p42.maxPageSize, `{ p43 }.maxPageSize`)

	if v99 ~= nil then
		return v99
	end

	local v100 = verifyString(p42.pageToken, `{ p43 }.pageToken`)

	if v100 ~= nil then
		return v100
	end

	local v101 = verifyString(p42.filter, `{ p43 }.filter`)

	if v101 ~= nil then
		return v101
	end

	return nil
end
function listInventoryItemsUrl(p44, p45) -- line: 568
	if p44.parent == nil then
		return InvalidArgumentError("URL parameter provided was nil: listInventoryItemsRequest.parent.")
	end

	if string.match(p44.parent, "^users/([^/]+)$") == nil then
		return InvalidArgumentError("URL parameter was not formatted correctly: listInventoryItemsRequest.parent.")
	end

	local v104 = string.format("%s%s/cloud/v2/%s/inventory-items", getApisUrl(), getUrlPrefix(p45), (tostring(p44.parent)))

	if p44.maxPageSize == nil and p44.pageToken == nil and p44.filter == nil then
		return v104
	end

	local t1 = {}

	if p44.maxPageSize ~= nil then
		table.insert(t1, string.format("maxPageSize=%s", (tostring(p44.maxPageSize))))
	end

	if p44.pageToken ~= nil then
		table.insert(t1, string.format("pageToken=%s", (tostring(p44.pageToken))))
	end

	if p44.filter ~= nil then
		table.insert(t1, string.format("filter=%s", (tostring(p44.filter))))
	end

	return (string.format("%s?%s", v104, table.concat(t1, "&")))
end
function listInventoryItems(p46, p47) -- line: 598
	-- upvalues: OpenCloudService (copy)
	if p46 == nil then
		return InvalidArgumentError("Request provided was nil.")
	end

	local v108 = verifyListInventoryItemsRequest(p46, "listInventoryItemsRequest")

	if v108 ~= nil then
		return v108
	end

	local v109 = listInventoryItemsUrl(p46, p47)

	if typeof(v109) ~= "string" then
		return v109
	end

	return OpenCloudService:HttpRequestAsync({
		Url = v109,
		Request_Type = "GET",
		Headers = p47
	})
end

OpenCloudService:RegisterOpenCloud("v2", "ListInventoryItems", listInventoryItems)

function verifyListGroupMembershipsRequest(p48, p49) -- line: 618
	if p48 == nil then
		return nil
	end

	local v112 = verifyTable(p48, p49)

	if v112 ~= nil then
		return v112
	end

	if p48.parent == nil then
		return InvalidArgumentError(`Required argument was not provided: { p49 }.parent.`)
	end

	local v113 = verifyString(p48.parent, `{ p49 }.parent`)

	if v113 ~= nil then
		return v113
	end

	local v114 = verifyNumber(p48.maxPageSize, `{ p49 }.maxPageSize`)

	if v114 ~= nil then
		return v114
	end

	local v115 = verifyString(p48.pageToken, `{ p49 }.pageToken`)

	if v115 ~= nil then
		return v115
	end

	local v116 = verifyString(p48.filter, `{ p49 }.filter`)

	if v116 ~= nil then
		return v116
	end

	return nil
end
function listGroupMembershipsUrl(p50, p51) -- line: 654
	if p50.parent == nil then
		return InvalidArgumentError("URL parameter provided was nil: listGroupMembershipsRequest.parent.")
	end

	if string.match(p50.parent, "^groups/([^/]+)$") == nil then
		return InvalidArgumentError("URL parameter was not formatted correctly: listGroupMembershipsRequest.parent.")
	end

	local v119 = string.format("%s%s/cloud/v2/%s/memberships", getApisUrl(), getUrlPrefix(p51), (tostring(p50.parent)))

	if p50.maxPageSize == nil and p50.pageToken == nil and p50.filter == nil then
		return v119
	end

	local t2 = {}

	if p50.maxPageSize ~= nil then
		table.insert(t2, string.format("maxPageSize=%s", (tostring(p50.maxPageSize))))
	end

	if p50.pageToken ~= nil then
		table.insert(t2, string.format("pageToken=%s", (tostring(p50.pageToken))))
	end

	if p50.filter ~= nil then
		table.insert(t2, string.format("filter=%s", (tostring(p50.filter))))
	end

	return (string.format("%s?%s", v119, table.concat(t2, "&")))
end
function listGroupMemberships(p52, p53) -- line: 684
	-- upvalues: OpenCloudService (copy)
	if p52 == nil then
		return InvalidArgumentError("Request provided was nil.")
	end

	local v123 = verifyListGroupMembershipsRequest(p52, "listGroupMembershipsRequest")

	if v123 ~= nil then
		return v123
	end

	local v124 = listGroupMembershipsUrl(p52, p53)

	if typeof(v124) ~= "string" then
		return v124
	end

	return OpenCloudService:HttpRequestAsync({
		Url = v124,
		Request_Type = "GET",
		Headers = p53
	})
end

OpenCloudService:RegisterOpenCloud("v2", "ListGroupMemberships", listGroupMemberships)

function verifyGetOperationRequest(p54, p55) -- line: 704
	if p54 == nil then
		return nil
	end

	local v127 = verifyTable(p54, p55)

	if v127 ~= nil then
		return v127
	end

	if p54.path == nil then
		return InvalidArgumentError(`Required argument was not provided: { p55 }.path.`)
	end

	local v128 = verifyString(p54.path, `{ p55 }.path`)

	if v128 ~= nil then
		return v128
	end

	return nil
end
function getOperationUrl(p56, p57) -- line: 725
	if p56.path == nil then
		return InvalidArgumentError("URL parameter provided was nil: getOperationRequest.path.")
	end

	if string.match(p56.path, "^users/([^/]+)/operations/([^/]+)$") == nil then
		return InvalidArgumentError("URL parameter was not formatted correctly: getOperationRequest.path.")
	end

	return (string.format("%s%s/cloud/v2/%s", getApisUrl(), getUrlPrefix(p57), (tostring(p56.path))))
end
function getOperation(p58, p59) -- line: 738
	-- upvalues: OpenCloudService (copy)
	if p58 == nil then
		return InvalidArgumentError("Request provided was nil.")
	end

	local v133 = verifyGetOperationRequest(p58, "getOperationRequest")

	if v133 ~= nil then
		return v133
	end

	local v134 = getOperationUrl(p58, p59)

	if typeof(v134) ~= "string" then
		return v134
	end

	return OpenCloudService:HttpRequestAsync({
		Url = v134,
		Request_Type = "GET",
		Headers = p59
	})
end

OpenCloudService:RegisterOpenCloud("v2", "GetOperation", getOperation)

function verifyGenerateUserThumbnailRequest(p60, p61) -- line: 758
	if p60 == nil then
		return nil
	end

	local v137 = verifyTable(p60, p61)

	if v137 ~= nil then
		return v137
	end

	if p60.path == nil then
		return InvalidArgumentError(`Required argument was not provided: { p61 }.path.`)
	end

	local v138 = verifyString(p60.path, `{ p61 }.path`)

	if v138 ~= nil then
		return v138
	end

	local v139 = verifyNumber(p60.size, `{ p61 }.size`)

	if v139 ~= nil then
		return v139
	end

	local v140 = verifyEnum(p60.format, `{ p61 }.format`)

	if v140 ~= nil then
		return v140
	end

	local v141 = verifyEnum(p60.shape, `{ p61 }.shape`)

	if v141 ~= nil then
		return v141
	end

	return nil
end
function generateUserThumbnailUrl(p62, p63) -- line: 794
	if p62.path == nil then
		return InvalidArgumentError("URL parameter provided was nil: generateUserThumbnailRequest.path.")
	end

	if string.match(p62.path, "^users/([^/]+)$") == nil then
		return InvalidArgumentError("URL parameter was not formatted correctly: generateUserThumbnailRequest.path.")
	end

	local v144 = string.format("%s%s/cloud/v2/%s:generateThumbnail", getApisUrl(), getUrlPrefix(p63), (tostring(p62.path)))

	if p62.size == nil and p62.format == nil and p62.shape == nil then
		return v144
	end

	local t3 = {}

	if p62.size ~= nil then
		table.insert(t3, string.format("size=%s", (tostring(p62.size))))
	end

	if p62.format ~= nil then
		table.insert(t3, string.format("format=%s", (tostring(p62.format))))
	end

	if p62.shape ~= nil then
		table.insert(t3, string.format("shape=%s", (tostring(p62.shape))))
	end

	return (string.format("%s?%s", v144, table.concat(t3, "&")))
end
function generateUserThumbnail(p64, p65) -- line: 824
	-- upvalues: OpenCloudService (copy)
	if p64 == nil then
		return InvalidArgumentError("Request provided was nil.")
	end

	local v148 = verifyGenerateUserThumbnailRequest(p64, "generateUserThumbnailRequest")

	if v148 ~= nil then
		return v148
	end

	local v149 = generateUserThumbnailUrl(p64, p65)

	if typeof(v149) ~= "string" then
		return v149
	end

	return OpenCloudService:HttpRequestAsync({
		Url = v149,
		Request_Type = "GET",
		Headers = p65
	})
end

OpenCloudService:RegisterOpenCloud("v2", "GenerateUserThumbnail", generateUserThumbnail)
OpenCloudService:RegistrationComplete()
