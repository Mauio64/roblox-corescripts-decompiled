local function decodeLuauUnicodeEscapes(value)
	return (value:gsub("\\u{(%x+)}", function(p2)
		local v5 = tonumber(p2, 16)

		if v5 == nil or v5 < 0 or v5 > 1114111 then
			return ""
		end

		return utf8.char(v5)
	end))
end

return decodeLuauUnicodeEscapes
