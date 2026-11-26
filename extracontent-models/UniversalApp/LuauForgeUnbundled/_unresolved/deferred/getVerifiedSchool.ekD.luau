local module = require("@luauforge/deferred/ekE")
local module2 = require("@luauforge/deferred/ekF")

local module3 = require("@luauforge/deferred/ekG")
local module4 = require("@luauforge/deferred/ekI")
local module5 = require("@luauforge/deferred/ekJ")
require("@luauforge/deferred/ekr")

local function getVerifiedSchool(p2)
	local fetched = module.fetch({
		method = "GET",
		url = module3.school,
		analyticsKey = "school-verification.get-school",
		network = p2,
		decode = function(p3)
			if typeof(p3) == "table" and p3.groupId ~= nil then
				return module5.decodeVerifiedSchool(p3)
			end

			return nil
		end
	})

	return module.asPromise(fetched):catch(function(p3)
		return module2.reject(module4(p3))
	end)
end

return getVerifiedSchool
