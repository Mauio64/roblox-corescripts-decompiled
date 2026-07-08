local shallowEqual = require(script.Parent.Parent.shallowEqual)
local toString = require(script.Parent.Parent.toString)

local function expectTable(p1) -- line: 4
	-- upvalues: shallowEqual (copy), toString (copy)
	return {
		toEqual = function(p2) -- line: 6
			-- upvalues: shallowEqual (copy), p1 (copy), toString (copy)
			assert(shallowEqual(p1, p2), string.format("expected: %s\ninstead got: %s", toString(p2), toString(p1)))
		end
	}
end

return expectTable
