local t1 = {}
local ParentParent = script.Parent.Parent.Parent.Parent
local Array = require(ParentParent.LuauPolyfill).Array

function t1.isNonEmptyArray(p1) -- line: 14
	-- upvalues: Array (copy)
	return (function() -- line: 15
		-- upvalues: Array (copy), p1 (copy)
		if Array.isArray(p1) then
			return #p1 > 0
		end

		return Array.isArray(p1)
	end)()
end

return t1
