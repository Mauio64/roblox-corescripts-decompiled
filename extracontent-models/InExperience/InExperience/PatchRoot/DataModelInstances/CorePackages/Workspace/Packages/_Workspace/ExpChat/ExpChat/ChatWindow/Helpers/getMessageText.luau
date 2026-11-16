return function(flag: boolean?, value: string?, value2: string?)
	if value == nil or value == "" then
		return value2 or ""
	end

	if flag then
		return value or ""
	end

	return value2 or ""
end
