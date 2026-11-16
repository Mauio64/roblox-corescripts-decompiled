local function trim(value: string)
	return (value:match("^%s*(.-)%s*$"))
end

return trim
