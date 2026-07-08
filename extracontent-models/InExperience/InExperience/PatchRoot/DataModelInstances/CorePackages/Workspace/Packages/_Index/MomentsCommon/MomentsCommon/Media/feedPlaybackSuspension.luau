local Parent = script:FindFirstAncestor("MomentsCommon").Parent
local v2, v3 = require(Parent.Signals).createSignal(false)

return {
	getSuspended = v2,
	setSuspended = v3
}
