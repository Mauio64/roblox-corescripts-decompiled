local function isFullyFilteredText(p: string, value: string): boolean
	if value == p then
		return false
	end

	return string.find(value, "#", 1, true) ~= nil and string.find(value, "[^#%s]") == nil
end

return isFullyFilteredText
