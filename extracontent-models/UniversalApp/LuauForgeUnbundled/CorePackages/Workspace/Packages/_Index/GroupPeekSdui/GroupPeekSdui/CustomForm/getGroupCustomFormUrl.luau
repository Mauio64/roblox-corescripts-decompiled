local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/GroupPeekSdui/UrlBuilder").UrlBuilder
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GroupPeekSdui/Http").Url

local v5 = urlBuilder.new({
	base = url.GROUPS_URL,
	path = "v1/groups/{groupId}/forms/{formId}/results",
	query = { cfVertical = "{cfVertical}" }
})

local v6 = urlBuilder.new({
	base = url.GROUPS_URL,
	path = "v1/groups/{groupId}/forms/{formId}/responses"
})

local function getGroupCustomFormResultsUrl(p2, p3, p4)
	return v5({ groupId = p2, formId = p3, cfVertical = p4 })
end

local function getGroupCustomFormResponsesUrl(p2, p3)
	return v6({ groupId = p2, formId = p3 })
end

return {
	results = getGroupCustomFormResultsUrl,
	responses = getGroupCustomFormResponsesUrl
}
