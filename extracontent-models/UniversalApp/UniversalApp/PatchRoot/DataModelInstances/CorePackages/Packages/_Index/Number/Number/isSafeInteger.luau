local isInteger = require(script.Parent.isInteger)
local MAX_SAFE_INTEGER = require(script.Parent.MAX_SAFE_INTEGER)

return function(p)
	return isInteger(p) and math.abs(p) <= MAX_SAFE_INTEGER
end
