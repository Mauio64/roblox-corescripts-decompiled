local function processSoftBreaks(value: string)
	return (value:gsub("%s*[\r\n]%s*", " "))
end

return processSoftBreaks
