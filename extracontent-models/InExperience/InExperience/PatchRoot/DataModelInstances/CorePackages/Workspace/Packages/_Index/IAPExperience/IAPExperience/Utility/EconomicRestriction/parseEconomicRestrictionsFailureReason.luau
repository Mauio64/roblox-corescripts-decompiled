local function parseEconomicRestrictionsFailureReason(p1) -- line: 3
	if not p1 then
		return nil
	end

	return p1.FailureReason or (p1.failureReason or p1.violationType)
end

return parseEconomicRestrictionsFailureReason
