local v = newproxy(true)
getmetatable(v).__tostring = function(): string
	return "Object.None"
end

return v
