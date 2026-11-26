local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Http")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/UrlBuilder").UrlBuilder.new({
	base = Http.Url.GROUPS_URL,
	path = "v1/groups/{groupId}/pages/overview"
})

local function getGroupOverviewPaneConfig(p2, p3)
	local v5 = if p3 ~= nil then tostring(p3) else nil

	if v5 == nil or string.match(v5, "^[1-9]%d*$") == nil then
		return nil
	end

	return {
		surfaceKey = "OverviewPane",
		configKey = `Groups-OverviewPane-{p2 == "" and "unknown" or p2}-{v5}`,
		url = urlBuilder({ groupId = v5 }),
		groupId = v5
	}
end

return getGroupOverviewPaneConfig
