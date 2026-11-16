local module = require("@luauforge/bundled/dYT")
local module2 = require("@luauforge/bundled/dwL")
local module3 = require("@luauforge/bundled/foD")

return {
	get = function(p2)
		local eventStream = module.get(p2).EventStream

		return {
			ButtonActivated = function(p3, p4)
				module2.isType(p3, "string", "associatedPageType")
				module2.isType(p4, "string", "currentPage")

				module3(eventStream, "BottomBarButton", p3, p4)
			end
		}
	end
}
