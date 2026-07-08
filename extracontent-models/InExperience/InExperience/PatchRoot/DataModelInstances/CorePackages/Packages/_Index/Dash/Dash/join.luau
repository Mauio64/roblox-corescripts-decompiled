local scriptParent = script.Parent

require(scriptParent.Types)

local assign = require(scriptParent.assign)

local function join(...) -- line: 13
	-- upvalues: assign (copy)
	return assign({}, ...)
end

return join
