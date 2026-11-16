local function getFriendDuration(data, p: number)
	if not data then
		return nil
	end

	local v = math.floor((p - os.time({
		year = data.year,
		month = data.month,
		day = data.day,
		hour = 0,
		min = 0,
		sec = 0
	})) / 86400)

	if v < 1 then
		return { value = 0, unit = "days" }
	end

	local v2 = os.date("!*t", p)
	local v3 = (v2.year - data.year) * 12 + (v2.month - data.month)

	if v2.day < data.day then
		v3 -= 1
	end

	if v3 >= 12 then
		return {
			value = math.floor(v3 / 12),
			unit = "years"
		}
	end

	if v3 >= 1 then
		return { value = v3, unit = "months" }
	end

	return { value = v, unit = "days" }
end

return getFriendDuration
