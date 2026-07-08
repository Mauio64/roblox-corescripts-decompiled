local Parent = script:FindFirstAncestor("ContactImporter").Parent
local Signal = require(Parent.AppCommonLib).Signal
local u3 = nil
local v4 = Signal.new()

return {
	getStatus = function() -- line: 14
		-- upvalues: u3 (ref)
		return u3
	end,
	setStatus = function(b1: boolean?) -- line: 9
		-- upvalues: u3 (ref), v4 (copy)
		u3 = b1
		v4:fire(b1)
	end,
	statusChanged = v4
}
