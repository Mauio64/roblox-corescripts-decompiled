local function rightPad(value: string, p: number, value2: string?)
	local v = value2 or " "
	local v2 = p - value:len()
	local v3 = v2 % v:len()
	local v4 = (v2 - v3) / v:len()
	return value .. string.rep(value2 or " ", v4) .. v:sub(1, v3)
end

return rightPad
