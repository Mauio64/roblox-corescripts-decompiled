local module = require("@luauforge/bundled/irv")
local module2 = require("@luauforge/bundled/irK")
return {
	ReadAloudManager = module,
	ConnectReadAloudToSettings = function()
		return module2(module)
	end
}
