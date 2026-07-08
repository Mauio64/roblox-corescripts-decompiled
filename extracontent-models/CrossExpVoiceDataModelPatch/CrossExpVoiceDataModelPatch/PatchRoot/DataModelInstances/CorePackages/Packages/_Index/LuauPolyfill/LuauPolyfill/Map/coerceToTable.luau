local ParentParent = script.Parent.Parent
local Parent = require(script.Parent)
local instanceof = require(ParentParent.instanceof)
local reduce = require(ParentParent.Array.reduce)

require(ParentParent.types)

local function coerceToTable(p1) -- line: 9
	-- upvalues: instanceof (copy), Parent (copy), reduce (copy)
	if not instanceof(p1, Parent) then
		return p1
	end

	return reduce(p1:entries(), function(p2, p3) -- line: 15
		p2[p3[1]] = p3[2]

		return p2
	end, {})
end

return coerceToTable
