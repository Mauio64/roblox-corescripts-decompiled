local function isErrorReasonPrefixWithEconomicRestrictions(value: string): boolean
	return string.sub(value, 1, 20) == "EconomicRestrictions"
end

return isErrorReasonPrefixWithEconomicRestrictions
