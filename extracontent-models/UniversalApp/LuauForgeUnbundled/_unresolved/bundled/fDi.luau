local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/dzP")
local module2 = require("@luauforge/bundled/dPN")

return function(object, p2, p3, list, p4, p5, p6)
	module.isType(p2, "string", "catalogSearch event expects eventContext")
	module.isType(p3, "string", "catalogSearch event expects keyword")
	module.isType(list, "table", "catalogSearch event expects assetsReturned")
	module.isType(p4, "number", "catalogSearch event expects pageNumber")
	module.isTypeOrNil(p5, "string", "catalogSearch event expects sortType")
	module.isTypeOrNil(p6, "table", "catalogSearch event expects filters")

	local joined = table.concat(list, ",")

	local v5 = p6 and HttpService:JSONEncode(p6)

	object:sendTelemetryEvent(p2, "catalogSearch", {
		feature = module2.AnalyticsTag,
		keyword = p3,
		page = p4,
		sort = p5,
		filters = v5,
		assetsReturned = joined
	})
end
