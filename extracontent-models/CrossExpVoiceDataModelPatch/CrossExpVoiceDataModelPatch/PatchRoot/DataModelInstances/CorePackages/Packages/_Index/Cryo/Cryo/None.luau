local v = newproxy(true)

getmetatable(v).__tostring = function(): string
	return "Cryo.None"
end

return v
