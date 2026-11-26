local module = require("@luauforge/bundled/eie")
local module2 = require("@luauforge/bundled/fDf")
local module3 = require("@luauforge/bundled/dPN")

return function()
	local v5 = module(module2)
	return function(p2)
		v5.sendCounter(module3.Counter.PREFIX .. p2)
	end
end
