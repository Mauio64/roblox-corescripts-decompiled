local module = require("@luauforge/deferred/ehk")
local module2 = require("@luauforge/deferred/ehl")

local module3 = require("@luauforge/deferred/ehm")
local module4 = require("@luauforge/deferred/eho")
require("@luauforge/deferred/egX")

local function recordSchoolVerificationAttempt(p2, p3)
	local fetched = module.fetch({
		method = "POST",
		url = module3.recordAttempt,
		analyticsKey = "school-verification.record-attempt",
		body = { schoolName = p2 },
		network = p3,
		decode = function(p4): boolean
			return true
		end
	})

	return module.asPromise(fetched):catch(function(p4)
		return module2.reject(module4(p4))
	end)
end

return recordSchoolVerificationAttempt
