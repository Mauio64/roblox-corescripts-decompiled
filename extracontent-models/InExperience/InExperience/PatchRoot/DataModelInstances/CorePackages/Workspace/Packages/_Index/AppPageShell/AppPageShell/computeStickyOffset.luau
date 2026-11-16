local function computeStickyOffset(p: number, p2: number, p3: number?)
	local v = math.min(math.floor(p - p2), 0)

	if p3 == nil or not (p3 > 0 and p3 < p2) then
		return v
	end

	return (math.max(v, p3 - p2))
end

return computeStickyOffset
