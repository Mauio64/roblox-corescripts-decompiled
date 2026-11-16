local function decodeLuauUnicodeEscapes(value: string)
	return (value:gsub("\\u{(%x+)}", function(p)
		local v = tonumber(p, 16)

		if v == nil or v < 0 or v > 1114111 then
			return ""
		end

		return utf8.char(v)
	end))
end

return decodeLuauUnicodeEscapes
