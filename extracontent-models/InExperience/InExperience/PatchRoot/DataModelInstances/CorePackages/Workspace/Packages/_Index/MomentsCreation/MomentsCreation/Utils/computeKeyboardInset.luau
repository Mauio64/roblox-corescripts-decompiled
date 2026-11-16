local function computeKeyboardInset(flag: boolean, flag2: boolean, p: number, p2: number, max: number)
	if flag and flag2 then
		return (math.clamp(p2 - p, 0, max))
	end

	return 0
end

return computeKeyboardInset
