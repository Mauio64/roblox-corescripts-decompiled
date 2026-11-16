local function getCenterScrollOffset(p: number, p2: number, p3: number, p4: number)
	if p4 <= 0 then
		return nil
	end

	local v = math.max(0, p + p2 * 0.5 - p4 * 0.5)
	return if not (math.abs(v - p3) < 1) then v else nil
end

return getCenterScrollOffset
