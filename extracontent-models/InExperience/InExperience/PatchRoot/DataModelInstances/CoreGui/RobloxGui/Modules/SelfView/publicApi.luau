local Modules = game:GetService("CoreGui").RobloxGui.Modules
local selfViewVisibilityUpdatedSignal = require(Modules.SelfView.selfViewVisibilityUpdatedSignal)
local u3 = false

return {
	getSelfViewIsOpenAndVisible = function() -- line: 8
		-- upvalues: u3 (ref)
		return u3
	end,
	setSelfViewIsOpenAndVisible = function(p1) -- line: 14
		-- upvalues: u3 (ref), selfViewVisibilityUpdatedSignal (copy)
		u3 = p1
		selfViewVisibilityUpdatedSignal:fire()
	end
}
