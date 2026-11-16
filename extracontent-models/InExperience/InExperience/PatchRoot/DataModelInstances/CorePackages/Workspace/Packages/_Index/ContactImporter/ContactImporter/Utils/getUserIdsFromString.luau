return function(value: string)
	return string.gmatch(value or "", "([^,]+)")
end
