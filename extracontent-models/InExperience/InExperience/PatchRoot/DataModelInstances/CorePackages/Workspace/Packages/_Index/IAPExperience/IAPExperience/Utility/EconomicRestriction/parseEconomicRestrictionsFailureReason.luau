local function parseEconomicRestrictionsFailureReason(data)
	if data then
		return data.FailureReason or data.failureReason or data.violationType
	end

	return nil
end

return parseEconomicRestrictionsFailureReason
