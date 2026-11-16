local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

return function()
	local signal, v = createSignal(nil)
	local signal2, setComponentId = createSignal(nil)

	return {
		getOpenMessageId = signal,
		getComponentId = signal2,
		toggleDropdown = function(p: string)
			v(function(p2)
				return if p2 ~= p then p else nil
			end)
		end,
		setComponentId = setComponentId
	}
end
