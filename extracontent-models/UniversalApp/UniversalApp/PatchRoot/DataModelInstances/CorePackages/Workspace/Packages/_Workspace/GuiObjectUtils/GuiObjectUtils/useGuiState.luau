local useProperty = require(script.Parent.useProperty)

local function useGuiState(t1: {[any]: any}) -- line: 9
	-- upvalues: useProperty (copy)
	return useProperty(t1, "GuiState")
end

return useGuiState
