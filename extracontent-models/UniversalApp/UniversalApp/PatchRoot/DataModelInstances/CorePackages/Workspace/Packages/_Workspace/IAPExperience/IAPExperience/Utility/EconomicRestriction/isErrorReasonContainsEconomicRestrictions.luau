local function isErrorReasonContainsEconomicRestrictions(s1: string) -- line: 1
	return string.find(s1, "EconomicRestrictions") ~= nil
end

return isErrorReasonContainsEconomicRestrictions
