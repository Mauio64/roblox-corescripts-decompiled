local module = require("@luauforge/bundled/ggX")

local module2 = require("@luauforge/bundled/gjK")

local function useIsLoginV2DialogLayout(): boolean
	return module.useContext(module2).showLoginModalization == true
end

return useIsLoginV2DialogLayout
