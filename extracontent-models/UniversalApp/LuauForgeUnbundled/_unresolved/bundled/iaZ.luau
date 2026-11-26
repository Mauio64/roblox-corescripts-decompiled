local pageHeartbeat = require("@luauforge/bundled/bZt").Events.pageHeartbeat
local userInteractions = require("@luauforge/bundled/bZt").Events.userInteractions
local module = require("@luauforge/bundled/ecq")

return {
	get = function(p2)
		local v5 = module.get(p2)

		return {
			reportPageHeartbeat = function(p3, p4)
				pageHeartbeat(v5.EventStream, p3, p4)
			end,
			reportPageChanged = function()
				userInteractions(v5.EventStream, "luaPage")
			end
		}
	end
}
