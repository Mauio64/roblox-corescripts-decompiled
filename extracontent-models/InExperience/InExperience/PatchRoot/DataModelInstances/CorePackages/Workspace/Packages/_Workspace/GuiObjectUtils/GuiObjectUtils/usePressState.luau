local useGuiState = require(script.Parent.useGuiState)

local function usePressState(t1: {[any]: any}) -- line: 9
	-- upvalues: useGuiState (copy)
	return useGuiState(t1) == Enum.GuiState.Press
end

return usePressState
