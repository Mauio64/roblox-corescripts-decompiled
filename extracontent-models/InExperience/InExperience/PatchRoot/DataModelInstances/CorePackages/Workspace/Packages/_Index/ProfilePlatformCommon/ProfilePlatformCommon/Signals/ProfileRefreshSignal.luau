local parent = script:FindFirstAncestor("ProfilePlatformCommon").Parent
local Signals = require(parent.Signals)

local signal, v = Signals.createSignal(0)

return {
	notifyProfileRefresh = function()
		v(os.clock())
	end,
	getProfileRefreshSignal = signal
}
