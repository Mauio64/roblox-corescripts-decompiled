local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Signals = require(parent2.Signals)

require(parent.Types)

local function createLatestCaptureStore()
	local signal, v = Signals.createSignal(nil)
	local signal2, v2 = Signals.createSignal(nil)

	return {
		getLatestCapture = signal,
		getLatestCaptureFilePath = signal2,
		setLatestCapture = function(p, p2: string?)
			v2(p2)
			v(p)
		end,
		clearLatestCapture = function()
			v2(nil)
			v(nil)
		end
	}
end

return createLatestCaptureStore
