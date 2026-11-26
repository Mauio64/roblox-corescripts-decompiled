game:DefineFastString("PCGDKFilteredNotificationTypes", "ExperienceInvitation,SquadExperienceInvitation")

return function()
	local fastString = game:GetFastString("PCGDKFilteredNotificationTypes")

	if fastString == "" then
		return {}
	end

	local v5 = string.split(fastString, ",")
	local matchSet = {}

	for i, v6 in ipairs(v5) do
		local match = v6:match("^%s*(.-)%s*$")

		if match ~= "" then
			matchSet[match] = true
		end
	end

	return matchSet
end
