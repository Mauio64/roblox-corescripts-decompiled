local module = require("@luauforge/bundled/gMy")

local module2 = require("@luauforge/bundled/gMJ")

local function useNavigator()
	return module.useContext(module2)
end

return useNavigator
