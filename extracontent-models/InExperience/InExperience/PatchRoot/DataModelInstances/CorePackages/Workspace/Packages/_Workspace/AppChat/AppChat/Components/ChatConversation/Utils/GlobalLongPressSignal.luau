local Parent = script:FindFirstAncestor("AppChat").Parent
local v2 = require(Parent.AppCommonLib).Signal.new()

return {
	dismissed = v2,
	dismiss = function() -- line: 14
		-- upvalues: v2 (copy)
		v2:fire()
	end
}
