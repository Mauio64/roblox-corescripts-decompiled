local v = newproxy(true)

getmetatable(v).__tostring = function(): string
	return "Llama.None"
end

return v
