local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Http")

local function getGroupSduiPageConfig(p2, p3, p4)
	local v5 = p3 == "" and "unknown" or p3
	local v6 = if p4 ~= nil then tostring(p4) else nil

	if v6 and not string.match(v6, "^[1-9]%d*$") then
		return nil
	end

	if p2 == "sidebarSection" and v6 then
		return {
			surfaceKey = "GroupSidebarSection",
			configKey = `Groups-GroupSidebarSection-{v5}-{v6}`,
			url = `{module.Url.GROUPS_URL}v1/groups/{v6}/pages/sidebar-section`,
			groupId = v6
		}
	end

	return nil
end

return getGroupSduiPageConfig
