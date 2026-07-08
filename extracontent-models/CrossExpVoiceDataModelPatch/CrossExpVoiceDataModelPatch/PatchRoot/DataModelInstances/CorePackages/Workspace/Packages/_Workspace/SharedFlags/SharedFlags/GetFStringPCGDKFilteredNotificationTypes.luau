game:DefineFastString("PCGDKFilteredNotificationTypes", "ExperienceInvitation,SquadExperienceInvitation")

return function() -- line: 3
	local FastString = game:GetFastString("PCGDKFilteredNotificationTypes")

	if FastString == "" then
		return {}
	end

	local t1 = {}
	local parts = string.split(FastString, ",")

	for _, v in ipairs(parts) do
		local v6 = v:match("^%s*(.-)%s*$")

		if v6 ~= "" then
			t1[v6] = true
		end
	end

	return t1
end
