local function isLayeredClothing(p1) -- line: 1
	return p1:FindFirstChildWhichIsA("WrapLayer", true)
end

return isLayeredClothing
