local function decodeLuauUnicodeEscapes(s1: string) -- line: 11
	return (s1:gsub("\\u{(%x+)}", function(p1) -- line: 13
		local num = tonumber(p1, 16)

		if num == nil or num < 0 or num > 1114111 then
			return ""
		end

		return utf8.char(num)
	end))
end

return decodeLuauUnicodeEscapes
