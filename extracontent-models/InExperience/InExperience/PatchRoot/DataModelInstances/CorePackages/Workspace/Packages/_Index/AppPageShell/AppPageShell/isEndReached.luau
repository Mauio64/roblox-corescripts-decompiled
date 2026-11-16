local function isEndReached(p: number, p2: number, p3: number, value: number?): boolean
	return not (p3 <= 0 or p2 <= 0) and p3 - (p + p2) <= (value or 0)
end

return isEndReached
