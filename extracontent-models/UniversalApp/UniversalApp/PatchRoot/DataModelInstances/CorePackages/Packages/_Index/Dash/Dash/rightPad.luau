local function rightPad(s1: string, n1: number, s2: string?) -- line: 23
	local v5 = s2 or " "
	local v6 = n1 - s1:len()
	local v7 = v6 % v5:len()
	local v8 = (v6 - v7) / v5:len()

	return s1 .. string.rep(s2 or " ", v8) .. v5:sub(1, v7)
end

return rightPad
