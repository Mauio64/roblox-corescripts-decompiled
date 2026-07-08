local Parent = script:FindFirstAncestor("MomentsCreation").Parent
local createSignal = require(Parent.Signals).createSignal

local function createSelectionStore() -- line: 20
	-- upvalues: createSignal (copy)
	local v4, v5 = createSignal(nil)

	return {
		getSelectedCapture = v4,
		setSelectedCapture = v5
	}
end

return createSelectionStore
