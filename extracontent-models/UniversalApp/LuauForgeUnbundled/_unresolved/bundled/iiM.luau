local module = require("@luauforge/bundled/iiN")
local module2 = require("@luauforge/bundled/ijc")
return {
	ReadAloudManager = module,
	ConnectReadAloudToSettings = function()
		return module2(module)
	end
}
