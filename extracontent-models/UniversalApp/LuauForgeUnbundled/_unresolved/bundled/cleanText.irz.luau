local function cleanText(value)
	return (value:gsub("[^ -~\n]", ""))
end

return cleanText
