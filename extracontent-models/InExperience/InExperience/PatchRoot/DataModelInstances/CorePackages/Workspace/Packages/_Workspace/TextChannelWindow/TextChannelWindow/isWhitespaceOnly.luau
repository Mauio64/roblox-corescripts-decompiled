local function isWhitespaceOnly(value: string): boolean
	return string.find(value, "%S") == nil
end

return isWhitespaceOnly
