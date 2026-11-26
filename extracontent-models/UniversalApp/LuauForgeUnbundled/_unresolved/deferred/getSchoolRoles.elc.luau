local module = require("@luauforge/deferred/ekE")
local module2 = require("@luauforge/deferred/ekF")

local module3 = require("@luauforge/deferred/ekG")
local module4 = require("@luauforge/deferred/ekI")
require("@luauforge/deferred/ekr")

local function getSchoolRoles(p2)
	local fetched = module.fetch({
		method = "GET",
		url = module3.roles,
		analyticsKey = "school-verification.get-roles",
		network = p2,
		decode = function(p3)
			return p3
		end
	})

	return module.asPromise(fetched):catch(function(p3)
		return module2.reject(module4(p3))
	end), fetched.dispose
end

return getSchoolRoles
