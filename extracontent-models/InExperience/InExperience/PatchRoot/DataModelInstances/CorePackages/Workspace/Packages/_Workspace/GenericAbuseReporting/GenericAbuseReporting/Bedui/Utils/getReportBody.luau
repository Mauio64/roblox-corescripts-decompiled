local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Dash = require(parent.Dash)

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)
local AbuseCategory = require(GenericAbuseReporting.Enums.AbuseCategory)
require(GenericAbuseReporting.Enums.AbuseVector)

return function(data)
	local v = {}

	Dash.forEach(data.additionalReportTags or {}, function(p)
		if not p.tagKey or p.tagKey == "" or not p.tagValue or p.tagValue == "" then
			return
		end

		if v[p.tagKey] == nil then
			v[p.tagKey] = p.tagValue

			return
		end

		local v2 = v[p.tagKey]
		v[p.tagKey] = v2 .. "," .. p.tagValue
	end)

	local v2 = {
		abuseVector = data.abuseVector,
		category = data.formData.abuse_category or AbuseCategory.ABUSE_CATEGORY_INVALID,
		comment = data.formData.free_comment or "",
		submitterId = data.localPlayerUserId,
		targetIdStr = data.targetIdStr,
		targetType = data.abuseVector,
		custom = 0
	}
	local custom

	if next(v) ~= nil then
		custom = v
	end

	v2.custom = custom

	return v2
end
