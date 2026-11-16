local parent = script:FindFirstAncestor("LocalUserIdStore").Parent
local Signals = require(parent.Signals)

local signal, setCurrentUserId = Signals.createSignal("")

return {
	getCurrentUserId = signal,
	setCurrentUserId = setCurrentUserId,
	reset = function()
		setCurrentUserId("")
	end
}
