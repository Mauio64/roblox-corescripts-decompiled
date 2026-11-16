local parent = script:FindFirstAncestor("MomentsCreation").Parent

local Signals = require(parent.Signals)

local createSignal = Signals.createSignal

local function createSelectionStore()
	local signal, setSelectedCapture = createSignal(nil)

	return { getSelectedCapture = signal, setSelectedCapture = setSelectedCapture }
end

return createSelectionStore
