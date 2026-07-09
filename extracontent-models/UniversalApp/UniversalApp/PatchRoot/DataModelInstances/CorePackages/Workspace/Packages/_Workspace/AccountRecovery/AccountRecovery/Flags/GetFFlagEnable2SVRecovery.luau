local Parent = script:FindFirstAncestor("AccountRecovery").Parent
local FFlagEnable2SVRecovery = require(Parent.SharedFlags).FFlagEnable2SVRecovery

return function() -- line: 5
	-- upvalues: FFlagEnable2SVRecovery (copy)
	return FFlagEnable2SVRecovery
end
