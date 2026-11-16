local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

return function()
	local signal, setChatWindowWidth = createSignal(nil)

	return { getChatWindowWidth = signal, setChatWindowWidth = setChatWindowWidth }
end
