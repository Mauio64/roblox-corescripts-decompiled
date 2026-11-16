require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/AvatarExperienceUIKit")

local function getRemainingTimeText(p2, data)
	local unit = p2.unit
	local v5 = p2.value == 1

	if unit == "days" then
		if v5 then
			return data.daySingular
		end

		return data.dayPlural
	elseif unit == "hours" then
		if v5 then
			return data.hourSingular
		end

		return data.hourPlural
	elseif unit == "minutes" then
		if v5 then
			return data.minuteSingular
		end

		return data.minutePlural
	else
		if unit ~= "seconds" then
			warn(`getRemainingTimeText: unexpected TimeUnit "{unit}"`)
			return nil
		end

		if v5 then
			return data.secondSingular
		end

		return data.secondPlural
	end
end

return getRemainingTimeText
