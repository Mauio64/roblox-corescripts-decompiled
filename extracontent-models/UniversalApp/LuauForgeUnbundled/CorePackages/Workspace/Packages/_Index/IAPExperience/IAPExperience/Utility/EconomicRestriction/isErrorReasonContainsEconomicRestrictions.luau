local function isErrorReasonContainsEconomicRestrictions(value): boolean
	return string.find(value, "EconomicRestrictions") ~= nil
end

return isErrorReasonContainsEconomicRestrictions
