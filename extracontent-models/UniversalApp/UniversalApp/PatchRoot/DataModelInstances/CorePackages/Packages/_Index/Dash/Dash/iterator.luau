local scriptParent = script.Parent

require(scriptParent.Types)

local function iterator(p1) -- line: 13
	if typeof(p1) == "function" then
		return p1
	end

	if typeof(p1) == "table" then
		if #p1 > 0 then
			return ipairs(p1)
		end

		return pairs(p1)
	end

	return nil
end

return iterator
