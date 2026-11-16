local function getSettingsForMessage(p, p2)
	local userSpecificSettings = p and p.UserSpecificSettings

	if not (p2 and userSpecificSettings) then
		return p
	end

	if userSpecificSettings[p2.userId] then
		return userSpecificSettings[p2.userId]
	end

	if p2.partOrModel and userSpecificSettings[p2.partOrModel:GetFullName()] then
		return userSpecificSettings[p2.partOrModel:GetFullName()]
	end

	return p
end

return getSettingsForMessage
