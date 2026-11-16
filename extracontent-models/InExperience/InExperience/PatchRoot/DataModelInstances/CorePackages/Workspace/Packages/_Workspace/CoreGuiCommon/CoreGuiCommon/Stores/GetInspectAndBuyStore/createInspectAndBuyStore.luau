local parent = script:FindFirstAncestor("CoreGuiCommon").Parent
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

return function()
	local signal, setInspectAndBuyOpen = createSignal(false)

	return { getInspectAndBuyOpen = signal, setInspectAndBuyOpen = setInspectAndBuyOpen }
end
