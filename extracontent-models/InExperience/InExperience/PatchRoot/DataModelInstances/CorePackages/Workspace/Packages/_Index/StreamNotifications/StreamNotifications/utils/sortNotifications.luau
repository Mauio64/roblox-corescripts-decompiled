local function v1(p1, p2) -- line: 1
	if p1.eventDate == "" or (p1.eventDate == nil or p2.eventDate == "" or p2.eventDate == nil) then
		return true
	end

	local v4 = DateTime.fromIsoDate(p1.eventDate) or nil
	local v5 = DateTime.fromIsoDate(p2.eventDate) or nil

	if v4 == nil or v5 == nil then
		return true
	end

	return v4.UnixTimestampMillis > v5.UnixTimestampMillis
end

return function(p3) -- line: 16
	-- upvalues: v1 (copy)
	local ok, result = pcall(function() -- line: 17
		-- upvalues: p3 (copy), v1 (copy)
		local v9 = table.clone(p3)

		table.sort(v9, v1)

		return v9
	end)

	if ok then
		return result
	end

	return p3
end
