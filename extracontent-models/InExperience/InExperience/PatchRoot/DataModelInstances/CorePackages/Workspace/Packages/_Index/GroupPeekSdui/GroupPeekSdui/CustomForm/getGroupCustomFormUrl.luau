local parent = script:FindFirstAncestor("GroupPeekSdui").Parent

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local Http = require(parent.Http)
local Url = Http.Url

local v = urlBuilder.new({
	base = Url.GROUPS_URL,
	path = "v1/groups/{groupId}/forms/{formId}/results",
	query = { cfVertical = "{cfVertical}" }
})

local v2 = urlBuilder.new({
	base = Url.GROUPS_URL,
	path = "v1/groups/{groupId}/forms/{formId}/responses"
})

local function getGroupCustomFormResultsUrl(groupId: string, formId: string, cfVertical: string)
	return v({ groupId = groupId, formId = formId, cfVertical = cfVertical })
end

local function getGroupCustomFormResponsesUrl(groupId: string, formId: string)
	return v2({ groupId = groupId, formId = formId })
end

return { results = getGroupCustomFormResultsUrl, responses = getGroupCustomFormResponsesUrl }
