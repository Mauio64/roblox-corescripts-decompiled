return function(value): boolean
	return type(value) == "number" and value ~= 1e999 and value == math.floor(value)
end
