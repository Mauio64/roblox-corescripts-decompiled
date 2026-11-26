local function computeKeyboardInset(p2, p3, p4, p5, max)
	if p2 and p3 then
		return (math.clamp(p5 - p4, 0, max))
	end

	return 0
end

return computeKeyboardInset
