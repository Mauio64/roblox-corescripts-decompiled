local parent = script.Parent
require(parent.Types)

local function copy(p)
	return table.clone(p)
end

return copy
