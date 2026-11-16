local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Dash")

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiTypes")
local AbuseCategory = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseCategory")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")

return function(data)
	local v5 = {}

	Dash.forEach(data.additionalReportTags or {}, function(p2)
		if not p2.tagKey or p2.tagKey == "" or not p2.tagValue or p2.tagValue == "" then
			return
		end

		if v5[p2.tagKey] == nil then
			v5[p2.tagKey] = p2.tagValue

			return
		end

		local v6 = v5[p2.tagKey]
		v5[p2.tagKey] = v6 .. "," .. p2.tagValue
	end)

	local v6 = {
		abuseVector = data.abuseVector,
		category = data.formData.abuse_category or AbuseCategory.ABUSE_CATEGORY_INVALID,
		comment = data.formData.free_comment or "",
		submitterId = data.localPlayerUserId,
		targetIdStr = data.targetIdStr,
		targetType = data.abuseVector,
		custom = 0
	}

	local v7 = if next(v5) ~= nil then v5 else nil
	v6.custom = v7

	return v6
end
