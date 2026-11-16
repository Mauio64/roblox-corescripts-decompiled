return function(value): boolean
	return typeof(value) == "number" and value == value and value ~= 1e999 and value ~= -1e999
end
