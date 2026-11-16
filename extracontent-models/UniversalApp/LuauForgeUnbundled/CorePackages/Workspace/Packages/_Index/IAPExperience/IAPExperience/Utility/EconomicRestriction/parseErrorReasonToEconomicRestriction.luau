local function parseErrorReasonToEconomicRestriction(value)
	local v5 = string.split(value, "/")

	local count = #v5
	return {
		timeoutMinutes = v5[count],
		violationType = v5[count - 1]
	}
end

return parseErrorReasonToEconomicRestriction
