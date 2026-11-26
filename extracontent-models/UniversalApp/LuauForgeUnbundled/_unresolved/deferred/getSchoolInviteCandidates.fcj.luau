local module = require("@luauforge/deferred/ekE")
local module2 = require("@luauforge/deferred/ekF")

local module3 = require("@luauforge/deferred/ekG")
local module4 = require("@luauforge/deferred/ekI")
require("@luauforge/deferred/ekr")

local function getSchoolInviteCandidates(p2)
	local fetched = module.fetch({
		method = "GET",
		url = module3.inviteCandidates,
		analyticsKey = "school-verification.get-invite-candidates",
		network = p2,
		decode = function(p3)
			local result = {}

			for k, v5 in p3.data do
				table.insert(result, {
					userId = tostring(v5.userId),
					invited = v5.invited
				})
			end

			return result
		end
	})

	return module.asPromise(fetched):catch(function(p3)
		return module2.reject(module4(p3))
	end)
end

return getSchoolInviteCandidates
