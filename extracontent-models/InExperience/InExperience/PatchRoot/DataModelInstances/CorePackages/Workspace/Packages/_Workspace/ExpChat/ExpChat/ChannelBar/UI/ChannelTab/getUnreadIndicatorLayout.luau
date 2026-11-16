return function(flag: boolean, flag2: boolean, p: number?, p2: number?, p3: number, p4: number, p5: number)
	if not flag or flag2 or p == nil or p2 == nil then
		return nil
	end

	local v = math.max(0, p - p3 * 2)
	local v2 = p4 + p5
	local isPinned = v < p2 + v2 * 2
	local textLeft

	if isPinned then
		textLeft = p3 + v2
	else
		textLeft = (p - p2) / 2
	end

	if isPinned then
		v = math.max(0, v - v2)
	end

	return { isPinned = isPinned, textLeft = textLeft, textWidth = math.min(p2, v) }
end
