local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Signals = require(parent2.Signals)

local InputMode = require(parent.InputMode)

return function()
	local signal, v = Signals.createSignal((InputMode.last()))
	local signal2, v2 = Signals.createSignal((InputMode.preferred()))

	InputMode.connect(function()
		v((InputMode.last()))
		v2((InputMode.preferred()))
	end)

	return { getLastInputType = signal, getPreferredInputType = signal2 }
end
