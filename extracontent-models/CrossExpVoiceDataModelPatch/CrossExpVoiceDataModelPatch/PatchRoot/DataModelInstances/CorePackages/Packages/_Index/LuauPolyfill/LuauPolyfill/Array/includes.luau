local parent = script.Parent.Parent
require(parent.types)

local indexOf = require(script.Parent.indexOf)

return function(p, p2, p3: number?): boolean
	return indexOf(p, p2, p3) ~= -1
end
