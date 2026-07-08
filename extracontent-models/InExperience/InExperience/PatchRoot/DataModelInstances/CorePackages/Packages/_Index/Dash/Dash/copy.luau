local scriptParent = script.Parent

require(scriptParent.Types)

local function copy(p1) -- line: 15
	return table.clone(p1)
end

return copy
