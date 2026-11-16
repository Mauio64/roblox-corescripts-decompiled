game:DefineFastString("PCGDKFilteredNotificationTypes", "ExperienceInvitation,SquadExperienceInvitation")

return function()
	local fastString = game:GetFastString("PCGDKFilteredNotificationTypes")

	if fastString == "" then
		return {}
	end

	local v = string.split(fastString, ",")
	local matchSet = {}

	for _, v2 in ipairs(v) do
		local match = v2:match("^%s*(.-)%s*$")

		if match ~= "" then
			matchSet[match] = true
		end
	end

	return matchSet
end
