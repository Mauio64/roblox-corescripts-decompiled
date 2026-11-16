local parent = script:FindFirstAncestor("Groups").Parent

local Http = require(parent.Http)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder.new({
	base = Http.Url.GROUPS_URL,
	path = "v1/groups/{groupId}/pages/overview"
})

local function getGroupOverviewPaneConfig(p: string, p2)
	local groupId

	if p2 ~= nil then
		groupId = tostring(p2)
	end

	if groupId == nil or string.match(groupId, "^[1-9]%d*$") == nil then
		return nil
	end

	return {
		surfaceKey = "OverviewPane",
		configKey = `Groups-OverviewPane-{p == "" and "unknown" or p}-{groupId}`,
		url = urlBuilder({ groupId = groupId }),
		groupId = groupId
	}
end

return getGroupOverviewPaneConfig
