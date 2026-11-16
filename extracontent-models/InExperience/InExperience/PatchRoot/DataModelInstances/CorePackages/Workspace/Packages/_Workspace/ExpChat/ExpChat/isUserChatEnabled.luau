return function(value: string): boolean
	return string.sub(value, 1, 7) == "Enabled" or value == "AllUsers"
end
