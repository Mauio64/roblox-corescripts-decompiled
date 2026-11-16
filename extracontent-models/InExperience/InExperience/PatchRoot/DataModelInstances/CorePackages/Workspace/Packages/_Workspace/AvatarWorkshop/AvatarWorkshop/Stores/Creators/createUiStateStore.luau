local parent = script:FindFirstAncestor("AvatarWorkshop").Parent

local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

local function createUiStateStore()
	local signal, setLastMeasuredGridWidth = createSignal(0)

	return {
		getLastMeasuredGridWidth = signal,
		setLastMeasuredGridWidth = setLastMeasuredGridWidth
	}
end

return createUiStateStore
