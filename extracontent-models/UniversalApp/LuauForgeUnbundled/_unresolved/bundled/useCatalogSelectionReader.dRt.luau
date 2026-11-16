local module = require("@luauforge/bundled/dPU")

local module2 = require("@luauforge/bundled/dPT")

local function useCatalogSelectionReader()
	return module.useContext(module2.Context)
end

return useCatalogSelectionReader
