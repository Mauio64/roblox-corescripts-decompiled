local function startsWith(value: string, value2: string): boolean
	return value:sub(1, value2:len()) == value2
end

return startsWith
