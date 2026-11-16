local useGuiState = require(script.Parent.useGuiState)

local function usePressState(p): boolean
	return useGuiState(p) == Enum.GuiState.Press
end

return usePressState
