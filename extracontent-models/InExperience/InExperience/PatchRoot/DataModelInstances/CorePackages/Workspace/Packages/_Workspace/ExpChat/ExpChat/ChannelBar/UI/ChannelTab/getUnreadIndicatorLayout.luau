return function(b1: boolean, b2: boolean, n1: number?, n2: number?, n3: number, n4: number, n5: number) -- line: 9
	if not b1 or (b2 or n1 == nil or n2 == nil) then
		return nil
	end

	local v8 = math.max(0, n1 - n3 * 2)
	local v9 = n4 + n5
	local v10 = v8 < n2 + v9 * 2
	local v11 = if not v10 then (n1 - n2) / 2 else n3 + v9
	local v12 = math.min(n2, if not v10 then v8 else math.max(0, v8 - v9))

	return {
		isPinned = v10,
		textLeft = v11,
		textWidth = v12
	}
end
