local module = require("@luauforge/deferred/ehk")
local module2 = require("@luauforge/deferred/ehl")

local module3 = require("@luauforge/deferred/ehm")
local module4 = require("@luauforge/deferred/eho")
require("@luauforge/deferred/egX")

local function sendSchoolInvite(p2, p3)
	local fetched = module.fetch({
		method = "POST",
		url = module3.invite,
		analyticsKey = "school-verification.send-invite",
		body = { targetUserId = tonumber(p2) },
		network = p3,
		decode = function(p4): nil
			return nil
		end
	})

	return module.asPromise(fetched):catch(function(p4)
		return module2.reject(module4(p4))
	end)
end

return sendSchoolInvite
