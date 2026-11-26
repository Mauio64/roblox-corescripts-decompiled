local module = require("@luauforge/deferred/hGg")
local module2 = require("@luauforge/bundled/ecq")

return {
	get = function(p2)
		local v5 = module2.get(p2)

		return {
			reportAppReady = function(p3)
				module(v5.EventStream, p3, "appReady")
			end
		}
	end
}
