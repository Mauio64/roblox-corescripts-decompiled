local function getSettingsForMessage(p1, p2) -- line: 3
	local v4 = p1 and p1.UserSpecificSettings

	if not p2 or not v4 then
		return p1
	end

	if v4[p2.userId] then
		return v4[p2.userId]
	end

	if p2.partOrModel and v4[p2.partOrModel:GetFullName()] then
		return v4[p2.partOrModel:GetFullName()]
	end

	return p1
end

return getSettingsForMessage
