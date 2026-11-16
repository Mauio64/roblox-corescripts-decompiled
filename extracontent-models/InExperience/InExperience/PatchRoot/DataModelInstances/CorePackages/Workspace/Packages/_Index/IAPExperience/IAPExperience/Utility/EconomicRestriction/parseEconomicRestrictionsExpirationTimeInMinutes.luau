local function parseEconomicRestrictionsExpirationTimeInMinutes(data)
	if data then
		return data.ExpirationTimeInMinutes or data.expirationTimeInMinutes or data.timeoutMinutes
	end

	return nil
end

return parseEconomicRestrictionsExpirationTimeInMinutes
