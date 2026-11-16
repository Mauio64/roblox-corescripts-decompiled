local function parseErrorReasonToEconomicRestriction(value: string)
	local v = string.split(value, "/")

	local count = #v
	return {
		timeoutMinutes = v[count],
		violationType = v[count - 1]
	}
end

return parseErrorReasonToEconomicRestriction
