local isInteger = require(script.Parent.isInteger)
local MAX_SAFE_INTEGER = require(script.Parent.MAX_SAFE_INTEGER)

return function(p1) -- line: 6
	-- upvalues: isInteger (copy), MAX_SAFE_INTEGER (copy)
	return isInteger(p1) and math.abs(p1) <= MAX_SAFE_INTEGER
end
