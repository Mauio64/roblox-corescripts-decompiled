local useProperty = require("@game/CorePackages/Workspace/Packages/_Workspace/GuiObjectUtils/GuiObjectUtils/useProperty")

local function useGuiState(p2)
	return useProperty(p2, "GuiState")
end

return useGuiState
