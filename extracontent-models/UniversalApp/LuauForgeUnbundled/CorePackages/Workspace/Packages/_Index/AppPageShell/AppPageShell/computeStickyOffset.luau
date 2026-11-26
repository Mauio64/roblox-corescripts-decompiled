local function computeStickyOffset(p2, p3, p4)
	local v5 = math.min(math.floor(p2 - p3), 0)

	if p4 == nil or not (p4 > 0 and p4 < p3) then
		return v5
	end

	return (math.max(v5, p4 - p3))
end

return computeStickyOffset
