local function getManualSelectVariant(p2, value)
	if p2 >= 0 then
		return p2
	end

	return value or 0
end

local function resolveBirthdaySelectVariant(p2, p3, value, value2)
	local v5 = not (p3 >= 0) and (value or 0) or p3
	return p2 and (value2 or 1) <= v5
end

return resolveBirthdaySelectVariant
