return function(value: string)
	return (value:gsub("+", " "):gsub("%%(%x%x)", function(p)
		return (string.char((tonumber(p, 16))))
	end))
end
