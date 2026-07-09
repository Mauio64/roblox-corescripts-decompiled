local function parseErrorReasonToEconomicRestriction(s1: string) -- line: 1
	local parts = string.split(s1, "/")
	local v4 = #parts

	return {
		timeoutMinutes = parts[v4],
		violationType = parts[v4 - 1]
	}
end

return parseErrorReasonToEconomicRestriction
