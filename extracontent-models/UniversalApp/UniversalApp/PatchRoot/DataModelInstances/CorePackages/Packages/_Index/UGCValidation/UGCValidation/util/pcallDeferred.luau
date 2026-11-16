local parent = script.Parent.Parent

require(parent.util.Types)
local tryYield = require(parent.util.tryYield)

return function(callback, p)
	tryYield(p)
	return pcall(callback)
end
