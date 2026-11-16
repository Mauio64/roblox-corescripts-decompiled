require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiTypes")

return function(value, p2)
	if p2 == nil then
		return value
	end

	for k in string.gmatch(value, "{%S+}") do
		local v5 = string.sub(k, 2, #k - 1)

		if p2[v5] then
			value = string.gsub(value, k, p2[v5].label)
		end
	end

	return value
end
