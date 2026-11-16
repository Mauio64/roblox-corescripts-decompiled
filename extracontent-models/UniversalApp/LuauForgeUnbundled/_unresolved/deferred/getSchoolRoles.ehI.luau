local module = require("@luauforge/deferred/ehk")
local module2 = require("@luauforge/deferred/ehl")

local module3 = require("@luauforge/deferred/ehm")
local module4 = require("@luauforge/deferred/eho")
require("@luauforge/deferred/egX")

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
