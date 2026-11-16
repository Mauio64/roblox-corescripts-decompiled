local function truncateToMaxLength(value: string, p: number)
	local v = math.max(0, (math.floor(p)))
	local v2 = utf8.len(value)

	if v2 == nil then
		if v < #value then
			return (string.sub(value, 1, v))
		end

		return value
	elseif v2 <= v then
		return value
	else
		return (string.sub(value, 1, utf8.offset(value, v + 1) - 1))
	end
end

return truncateToMaxLength
