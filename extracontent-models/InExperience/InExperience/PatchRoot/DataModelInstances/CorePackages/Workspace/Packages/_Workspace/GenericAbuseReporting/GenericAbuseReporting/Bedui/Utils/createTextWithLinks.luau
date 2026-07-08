local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)

return function(s1: string, t1: {[any]: any}?) -- line: 20
	if t1 == nil then
		return s1
	end

	for match in string.gmatch(s1, "{%S+}") do
		local v5 = string.sub(match, 2, #match - 1)

		if t1[v5] then
			s1 = string.gsub(s1, match, t1[v5].label)
		end
	end

	return s1
end
