local function getProperty(p1, p2) -- line: 7
	local ok, result = pcall(function() -- line: 8
		-- upvalues: p1 (copy), p2 (copy)
		return p1[p2]
	end)

	return ok == true and result or nil
end
local function propertyMatch(p3, p4) -- line: 15
	for k, v in pairs(p4) do
		local ok, result = pcall(function() -- line: 8
			-- upvalues: p3 (copy), k (copy)
			return p3[k]
		end)

		if v ~= (ok == true and result or nil) then
			return false
		end
	end

	return true
end
local function findFirstInstance(p5, p6) -- line: 25
	-- upvalues: propertyMatch (copy)
	for _, descendant in ipairs(p5:GetDescendants()) do
		if propertyMatch(descendant, p6) then
			return descendant
		end
	end

	return nil
end

return findFirstInstance
