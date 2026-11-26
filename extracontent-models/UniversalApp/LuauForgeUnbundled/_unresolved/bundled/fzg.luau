local module = require("@luauforge/bundled/fzd")
local module2 = require("@luauforge/bundled/fzh")

local module3 = require("@luauforge/bundled/fzn")

return function(p2, p3, p4)
	return function(p5)
		local v5 = module2.toRawValue(p3)

		if v5 == nil then
			v5 = p3
		end

		return module(p2, v5, module3.toRawValue(p4)):andThen(function(p6)
			return p6.responseBody
		end)
	end
end
