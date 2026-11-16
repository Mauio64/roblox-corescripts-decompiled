local useGuiState = require("@game/CorePackages/Workspace/Packages/_Workspace/GuiObjectUtils/GuiObjectUtils/useGuiState")

local function useHoverState(p2): boolean
	return useGuiState(p2) == Enum.GuiState.Hover
end

return useHoverState
