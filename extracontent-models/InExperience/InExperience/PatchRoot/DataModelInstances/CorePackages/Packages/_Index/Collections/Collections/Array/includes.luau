local parent = script.Parent.Parent.Parent
require(parent.ES7Types)

local indexOf = require(script.Parent.indexOf)

return function(p, p2, p3: number?): boolean
	return indexOf(p, p2, p3) ~= -1
end
