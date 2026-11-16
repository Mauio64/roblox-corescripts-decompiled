return function(value, value2): boolean
	return not value or value == "" or string.find(string.lower(value2), string.lower(value), 1, true) ~= nil
end
