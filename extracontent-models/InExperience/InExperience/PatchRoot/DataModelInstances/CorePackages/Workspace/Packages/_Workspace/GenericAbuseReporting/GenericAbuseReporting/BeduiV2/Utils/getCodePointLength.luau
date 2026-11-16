local function getCodePointLength(value: string)
	if value == nil then
		return 0
	end

	return utf8.len(value) or value:len()
end

return getCodePointLength
