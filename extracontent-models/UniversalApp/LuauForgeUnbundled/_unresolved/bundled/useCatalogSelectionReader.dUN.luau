local module = require("@luauforge/bundled/dTk")

local module2 = require("@luauforge/bundled/dTj")

local function useCatalogSelectionReader()
	return module.useContext(module2.Context)
end

return useCatalogSelectionReader
