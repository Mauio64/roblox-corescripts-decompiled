local createSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals").createSignal

local function createSelectionStore()
	local signal, v5 = createSignal(nil)

	return { getSelectedCapture = signal, setSelectedCapture = v5 }
end

return createSelectionStore
