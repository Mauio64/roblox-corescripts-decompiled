local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Dash = require(GenericAbuseReportingParent.Dash)

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)

local AbuseCategory = require(GenericAbuseReporting.Enums.AbuseCategory)

require(GenericAbuseReporting.Enums.AbuseVector)

return function(t1: {[any]: any}) -- line: 28
	-- upvalues: Dash (copy), AbuseCategory (copy)
	local t2 = {}

	Dash.forEach(t1.additionalReportTags or {}, function(p1) -- line: 38
		-- upvalues: t2 (copy)
		if not p1.tagKey or (p1.tagKey == "" or not p1.tagValue or p1.tagValue == "") then
			return
		end

		if t2[p1.tagKey] ~= nil then
			local v8 = t2[p1.tagKey]

			t2[p1.tagKey] = v8 .. "," .. p1.tagValue

			return
		end

		t2[p1.tagKey] = p1.tagValue
	end)

	return {
		abuseVector = t1.abuseVector,
		category = t1.formData.abuse_category or AbuseCategory.ABUSE_CATEGORY_INVALID,
		comment = t1.formData.free_comment or "",
		submitterId = t1.localPlayerUserId,
		targetIdStr = t1.targetIdStr,
		targetType = t1.abuseVector,
		custom = if next(t2) == nil then nil else t2
	}
end
