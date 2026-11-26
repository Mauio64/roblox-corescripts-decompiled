local module = require("@luauforge/deferred/ekE")
local module2 = require("@luauforge/deferred/ekF")

local module3 = require("@luauforge/deferred/ekG")
local module4 = require("@luauforge/deferred/ekI")
require("@luauforge/deferred/ekr")
local verifyErrorKind = require("@luauforge/deferred/ekq").VerifyErrorKind

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
