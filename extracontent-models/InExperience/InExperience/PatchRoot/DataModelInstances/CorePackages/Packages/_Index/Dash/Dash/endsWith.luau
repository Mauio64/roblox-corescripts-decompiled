local function endsWith(value: string, value2: string): boolean
	return value:sub(-value2:len()) == value2
end

return endsWith
