local module = require("@luauforge/deferred/ehk")
local module2 = require("@luauforge/deferred/ehl")

local module3 = require("@luauforge/deferred/ehm")
local module4 = require("@luauforge/deferred/eho")
require("@luauforge/deferred/egX")
local verifyErrorKind = require("@luauforge/deferred/egW").VerifyErrorKind

local function leaveSchool(p2, p3)
	local fetched = module.fetch({
		method = "POST",
		url = module3.leave,
		analyticsKey = "school-verification.leave-school",
		body = { groupId = p2 },
		network = p3,
		decode = function(p4): boolean
			if typeof(p4) == "table" and p4.success ~= nil then
				return p4.success == true
			end

			return true
		end
	})

	return module.asPromise(fetched):catch(function(p4)
		return module2.reject(module4(p4))
	end):andThen(function(p4)
		if p4 then
			return p4
		end

		return module2.reject({ kind = verifyErrorKind.Unknown })
	end)
end

return leaveSchool
