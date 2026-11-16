local parent = script:FindFirstAncestor("InExperienceOffers").Parent

require(parent.AvatarExperienceUIKit)

local function getRemainingTimeText(p, data)
	local unit = p.unit
	local v = p.value == 1

	if unit == "days" then
		return if v then data.daySingular else data.dayPlural
	elseif unit == "hours" then
		return if v then data.hourSingular else data.hourPlural
	elseif unit == "minutes" then
		if v then
			return data.minuteSingular
		end

		return data.minutePlural
	else
		if unit ~= "seconds" then
			warn(`getRemainingTimeText: unexpected TimeUnit "{unit}"`)
			return nil
		end

		if v then
			return data.secondSingular
		end

		return data.secondPlural
	end
end

return getRemainingTimeText
