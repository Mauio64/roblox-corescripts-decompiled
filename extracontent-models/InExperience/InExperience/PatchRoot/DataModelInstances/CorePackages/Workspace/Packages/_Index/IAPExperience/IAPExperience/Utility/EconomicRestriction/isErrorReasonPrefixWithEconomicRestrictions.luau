local function isErrorReasonPrefixWithEconomicRestrictions(s1: string) -- line: 3
	return string.sub(s1, 1, 20) == "EconomicRestrictions"
end

return isErrorReasonPrefixWithEconomicRestrictions
