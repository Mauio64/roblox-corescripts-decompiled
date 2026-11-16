local function getFriendDuration(data, p2)
	if not data then
		return nil
	end

	local v5 = math.floor((p2 - os.time({
		year = data.year,
		month = data.month,
		day = data.day,
		hour = 0,
		min = 0,
		sec = 0
	})) / 86400)

	if v5 < 1 then
		return { value = 0, unit = "days" }
	end

	local v6 = os.date("!*t", p2)
	local v7 = (v6.year - data.year) * 12 + (v6.month - data.month)

	if v6.day < data.day then
		v7 -= 1
	end

	if v7 >= 12 then
		return {
			value = math.floor(v7 / 12),
			unit = "years"
		}
	end

	if v7 >= 1 then
		return { value = v7, unit = "months" }
	end

	return { value = v5, unit = "days" }
end

return getFriendDuration
