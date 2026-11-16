local parent = script.Parent
require(parent.Types)
local assign = require(parent.assign)

local function join(...)
	return assign({}, ...)
end

return join
