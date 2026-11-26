local useGuiState = require("@game/CorePackages/Workspace/Packages/_Workspace/GuiObjectUtils/GuiObjectUtils/useGuiState")

local function usePressState(p2): boolean
	return useGuiState(p2) == Enum.GuiState.Press
end

return usePressState
