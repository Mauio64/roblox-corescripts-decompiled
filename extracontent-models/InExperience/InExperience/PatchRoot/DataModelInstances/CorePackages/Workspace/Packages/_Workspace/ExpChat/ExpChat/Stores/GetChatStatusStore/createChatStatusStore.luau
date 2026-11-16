local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

return function()
	local signal, setChatStatus = createSignal("Unknown")

	return { getChatStatus = signal, setChatStatus = setChatStatus }
end
