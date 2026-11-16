local function calculateCountdownTime(p: number)
	p += 59

	local hours = 0
	local minutes = 0
	local days

	if p >= 86400 then
		days = math.floor(p / 86400)
		p -= days * 86400
	else
		days = 0
	end

	if p >= 3600 then
		hours = math.floor(p / 3600)
		p -= hours * 3600
	end

	if p > 0 then
		minutes = math.floor(p / 60)
	end

	return { days = days, hours = hours, minutes = minutes }
end

return calculateCountdownTime
