local parent = script:FindFirstAncestor("CoreGuiCommon").Parent
local Signals = require(parent.Signals)

return function()
	local signal, setVisibility = Signals.createSignal(false)

	return { getVisibility = signal, setVisibility = setVisibility }
end
