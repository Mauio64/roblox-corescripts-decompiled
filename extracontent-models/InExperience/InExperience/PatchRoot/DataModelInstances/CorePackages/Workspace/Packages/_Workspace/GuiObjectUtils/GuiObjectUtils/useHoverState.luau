local useGuiState = require(script.Parent.useGuiState)

local function useHoverState(p): boolean
	return useGuiState(p) == Enum.GuiState.Hover
end

return useHoverState
