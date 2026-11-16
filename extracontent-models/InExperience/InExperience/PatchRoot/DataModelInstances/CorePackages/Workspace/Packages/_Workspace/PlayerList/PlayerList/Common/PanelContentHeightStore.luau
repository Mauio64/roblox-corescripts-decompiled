local parent = script.Parent.Parent.Parent

local Signals = require(parent.Signals)

local signal, setBodyContentHeight = Signals.createSignal(0)

return {
	getBodyContentHeight = signal,
	setBodyContentHeight = setBodyContentHeight,
	reset = function()
		setBodyContentHeight(0)
	end
}
