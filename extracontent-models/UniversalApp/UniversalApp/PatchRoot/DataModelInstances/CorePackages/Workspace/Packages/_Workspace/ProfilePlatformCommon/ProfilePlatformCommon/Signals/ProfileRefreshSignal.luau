local Parent = script:FindFirstAncestor("ProfilePlatformCommon").Parent
local v2, v3 = require(Parent.Signals).createSignal(0)

return {
	notifyProfileRefresh = function() -- line: 7
		-- upvalues: v3 (copy)
		v3(os.clock())
	end,
	getProfileRefreshSignal = v2
}
