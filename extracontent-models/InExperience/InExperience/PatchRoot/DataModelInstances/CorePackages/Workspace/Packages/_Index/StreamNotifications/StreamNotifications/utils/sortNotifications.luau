local function fn(p, p2): boolean
	if p.eventDate == "" or p.eventDate == nil or p2.eventDate == "" or p2.eventDate == nil then
		return true
	end

	local dateTime = DateTime.fromIsoDate(p.eventDate) or nil
	local dateTime2 = DateTime.fromIsoDate(p2.eventDate) or nil

	if dateTime == nil or dateTime2 == nil then
		return true
	end

	return dateTime.UnixTimestampMillis > dateTime2.UnixTimestampMillis
end

return function(p)
	local success, result = pcall(function()
		local clone = table.clone(p)
		table.sort(clone, fn)
		return clone
	end)
	return if success then result else p
end
