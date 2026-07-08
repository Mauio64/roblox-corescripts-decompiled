local function computeKeyboardInset(b1: boolean, b2: boolean, n1: number, n2: number, n3: number) -- line: 20
	if not b1 or not b2 then
		return 0
	end

	return (math.clamp(n2 - n1, 0, n3))
end

return computeKeyboardInset
