local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")

require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)

return function(value: string, p)
	if p == nil then
		return value
	end

	for k in string.gmatch(value, "{%S+}") do
		local v = string.sub(k, 2, #k - 1)

		if p[v] then
			value = string.gsub(value, k, p[v].label)
		end
	end

	return value
end
