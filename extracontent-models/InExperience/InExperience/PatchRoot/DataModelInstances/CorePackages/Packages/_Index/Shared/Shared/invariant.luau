local ParentParent = script.Parent.Parent
local Error = require(ParentParent.LuauPolyfill).Error

local function invariant(p1, p2, ...) -- line: 25
	-- upvalues: Error (copy)
	if not p1 then
		error(Error(string.format(p2, ...)))
	end
end

return invariant
