local function fn(p2, p3): boolean
	if p2.eventDate == "" or p2.eventDate == nil or p3.eventDate == "" or p3.eventDate == nil then
		return true
	end

	local dateTime = DateTime.fromIsoDate(p2.eventDate) or nil
	local dateTime2 = DateTime.fromIsoDate(p3.eventDate) or nil

	if dateTime == nil or dateTime2 == nil then
		return true
	end

	return dateTime.UnixTimestampMillis > dateTime2.UnixTimestampMillis
end

return function(p2)
	local success, result = pcall(function()
		local clone = table.clone(p2)
		table.sort(clone, fn)
		return clone
	end)

	if success then
		return result
	end

	return p2
end
