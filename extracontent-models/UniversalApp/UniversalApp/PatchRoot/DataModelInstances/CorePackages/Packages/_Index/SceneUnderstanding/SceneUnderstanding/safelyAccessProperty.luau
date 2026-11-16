local function safelyAccessProperty(p, p2: string, p3)
	local success, result = pcall(function()
		return p[p2]
	end)
	return if success then result else p3
end

return safelyAccessProperty
