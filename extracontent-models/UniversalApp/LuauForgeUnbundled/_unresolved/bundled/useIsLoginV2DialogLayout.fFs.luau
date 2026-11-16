local module = require("@luauforge/bundled/fCE")

local module2 = require("@luauforge/bundled/fFq")

local function useIsLoginV2DialogLayout(): boolean
	return module.useContext(module2).showLoginModalization == true
end

return useIsLoginV2DialogLayout
