local v1 = newproxy(true)

getmetatable(v1).__tostring = function() -- line: 11
	return "Cryo.None"
end

return v1
