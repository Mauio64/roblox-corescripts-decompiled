local v1 = newproxy(true)

getmetatable(v1).__tostring = function() -- line: 20
	return "Object.None"
end

return v1
