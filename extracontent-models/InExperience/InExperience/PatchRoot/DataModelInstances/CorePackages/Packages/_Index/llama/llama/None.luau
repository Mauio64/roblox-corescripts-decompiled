local v1 = newproxy(true)

getmetatable(v1).__tostring = function() -- line: 4
	return "Llama.None"
end

return v1
