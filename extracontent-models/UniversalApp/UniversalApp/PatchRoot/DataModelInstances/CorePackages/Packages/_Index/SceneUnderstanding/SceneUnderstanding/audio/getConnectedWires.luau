local function getConnectedWires(p1, s1: string) -- line: 1
	local ok, result = pcall(function() -- line: 2
		-- upvalues: p1 (copy), s1 (copy)
		return p1:GetConnectedWires(s1)
	end)

	if ok then
		return result
	end

	return {}
end

return getConnectedWires
