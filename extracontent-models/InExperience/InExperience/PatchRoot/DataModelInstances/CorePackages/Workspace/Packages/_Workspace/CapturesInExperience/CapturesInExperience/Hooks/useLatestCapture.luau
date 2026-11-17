local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Signals = require(parent2.Signals)

local GetLatestCaptureStore = require(parent.Stores.GetLatestCaptureStore)
require(parent.Types)

local function useLatestCapture()
	local state, setState = React.useState(function()
		return GetLatestCaptureStore(false).getLatestCapture(false)
	end)

	React.useEffect(function()
		return Signals.createEffect(function(p)
			setState(GetLatestCaptureStore(p).getLatestCapture(p))
		end)
	end, {})

	return state
end

return useLatestCapture
