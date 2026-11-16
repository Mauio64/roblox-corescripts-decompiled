local function isEndReached(p2, p3, p4, value): boolean
	if p4 <= 0 or p3 <= 0 then
		return false
	end

	return p4 - (p2 + p3) <= (value or 0)
end

return isEndReached
