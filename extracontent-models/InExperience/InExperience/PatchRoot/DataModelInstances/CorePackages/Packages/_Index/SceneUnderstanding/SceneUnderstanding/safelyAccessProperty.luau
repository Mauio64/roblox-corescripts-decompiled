local function safelyAccessProperty(p1, s1: string, p2) -- line: 15
	local ok, result = pcall(function() -- line: 16
		-- upvalues: p1 (copy), s1 (copy)
		return p1[s1]
	end)

	if ok then
		return result
	end

	return p2
end

return safelyAccessProperty
