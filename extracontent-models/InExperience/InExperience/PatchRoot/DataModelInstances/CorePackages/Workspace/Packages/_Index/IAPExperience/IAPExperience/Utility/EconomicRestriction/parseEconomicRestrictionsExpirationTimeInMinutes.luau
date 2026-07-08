local function parseEconomicRestrictionsExpirationTimeInMinutes(p1) -- line: 3
	if not p1 then
		return nil
	end

	return p1.ExpirationTimeInMinutes or (p1.expirationTimeInMinutes or p1.timeoutMinutes)
end

return parseEconomicRestrictionsExpirationTimeInMinutes
