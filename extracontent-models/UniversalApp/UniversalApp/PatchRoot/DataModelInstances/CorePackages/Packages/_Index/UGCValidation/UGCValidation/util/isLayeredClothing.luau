local function isLayeredClothing(instance)
	return instance:FindFirstChildWhichIsA("WrapLayer", true)
end

return isLayeredClothing
