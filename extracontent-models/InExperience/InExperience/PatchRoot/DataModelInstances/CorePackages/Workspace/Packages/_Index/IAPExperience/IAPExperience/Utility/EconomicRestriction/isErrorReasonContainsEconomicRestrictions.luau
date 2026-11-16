local function isErrorReasonContainsEconomicRestrictions(value: string): boolean
	return string.find(value, "EconomicRestrictions") ~= nil
end

return isErrorReasonContainsEconomicRestrictions
