local function truncateToMaxLength(value, p2)
	local v5 = math.max(0, (math.floor(p2)))
	local v6 = utf8.len(value)

	if v6 == nil then
		if v5 < #value then
			return (string.sub(value, 1, v5))
		end

		return value
	elseif v6 <= v5 then
		return value
	else
		return (string.sub(value, 1, utf8.offset(value, v5 + 1) - 1))
	end
end

return truncateToMaxLength
