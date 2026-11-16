local module = require("@luauforge/bundled/ghS")

local module2 = require("@luauforge/bundled/gid")

local function useNavigator()
	return module.useContext(module2)
end

return useNavigator
