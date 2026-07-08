local function leftPad(s1: string, n1: number, s2: string?) -- line: 21
	local v5 = s2 or " "
	local v6 = n1 - s1:len()
	local v7 = v6 % v5:len()
	local v8 = (v6 - v7) / v5:len()

	return string.rep(v5 or " ", v8) .. v5:sub(1, v7) .. s1
end

return leftPad
