local function getProperty(p1, p2) -- line: 6
	local ok, result = pcall(function() -- line: 7
		-- upvalues: p1 (copy), p2 (copy)
		return p1[p2]
	end)

	if ok == true then
		return result
	end

	return nil
end
local function propertyMatch(p3, p4) -- line: 14
	for k, v in pairs(p4) do
		local ok, result = pcall(function() -- line: 7
			-- upvalues: p3 (copy), k (copy)
			return p3[k]
		end)

		if v ~= if ok ~= true then nil else result then
			return false
		end
	end

	return true
end
local function findFirstInstance(p5, p6) -- line: 24
	-- upvalues: propertyMatch (copy)
	for _, descendant in ipairs(p5:GetDescendants()) do
		if propertyMatch(descendant, p6) then
			return descendant
		end
	end

	return nil
end

return findFirstInstance
