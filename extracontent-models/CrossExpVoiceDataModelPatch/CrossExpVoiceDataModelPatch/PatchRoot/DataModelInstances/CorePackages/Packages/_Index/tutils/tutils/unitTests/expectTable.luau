local shallowEqual = require(script.Parent.Parent.shallowEqual)
local toString = require(script.Parent.Parent.toString)

local function expectTable(p)
	return {
		toEqual = function(p2)
			assert(shallowEqual(p, p2), string.format("expected: %s\ninstead got: %s", toString(p2), toString(p)))
		end
	}
end

return expectTable
