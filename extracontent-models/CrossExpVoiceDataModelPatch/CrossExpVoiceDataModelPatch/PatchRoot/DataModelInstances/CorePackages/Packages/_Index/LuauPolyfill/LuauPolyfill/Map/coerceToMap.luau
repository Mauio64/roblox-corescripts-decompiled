local ParentParent = script.Parent.Parent
local Parent = require(script.Parent)
local Object = require(ParentParent.Object)
local instanceof = require(ParentParent.instanceof)

require(ParentParent.types)

local function coerceToMap(p1) -- line: 9
	-- upvalues: instanceof (copy), Parent (copy), Object (copy)
	return instanceof(p1, Parent) and p1 or Parent.new(Object.entries(p1))
end

return coerceToMap
