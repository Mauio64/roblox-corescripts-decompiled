local useProperty = require(script.Parent.useProperty)

local function useGuiState(p)
	return useProperty(p, "GuiState")
end

return useGuiState
