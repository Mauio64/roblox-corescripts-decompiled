local parent = script:FindFirstAncestor("Groups").Parent

local Http = require(parent.Http)

local function getGroupSduiPageConfig(p: string, p2: string, p3)
	local v = p2 == "" and "unknown" or p2
	local groupId

	if p3 ~= nil then
		groupId = tostring(p3)
	end

	if groupId and not string.match(groupId, "^[1-9]%d*$") then
		return nil
	end

	if p == "sidebarSection" and groupId then
		return {
			surfaceKey = "GroupSidebarSection",
			configKey = `Groups-GroupSidebarSection-{v}-{groupId}`,
			url = `{Http.Url.GROUPS_URL}v1/groups/{groupId}/pages/sidebar-section`,
			groupId = groupId
		}
	end

	return nil
end

return getGroupSduiPageConfig
