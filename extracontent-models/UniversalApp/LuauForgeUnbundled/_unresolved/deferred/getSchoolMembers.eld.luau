local HttpService = game:GetService("HttpService")

local module = require("@luauforge/deferred/ekE")
local module2 = require("@luauforge/deferred/ekF")

local module3 = require("@luauforge/deferred/ekG")
local module4 = require("@luauforge/deferred/ekI")
require("@luauforge/deferred/ekr")

local function getSchoolMembers(p2, p3, value, p4)
	local formatted = `{module3.members}?sortOrder=Asc&limit={value or 25}`

	if p2 ~= nil then
		formatted = `{formatted}&roleSetId={p2}`
	end

	if p3 ~= nil then
		formatted = `{formatted}&cursor={HttpService:UrlEncode(p3)}`
	end

	local fetched = module.fetch({
		method = "GET",
		url = formatted,
		analyticsKey = "school-verification.get-members",
		network = p4,
		decode = function(p5)
			return p5
		end
	})

	return module.asPromise(fetched):catch(function(p5)
		return module2.reject(module4(p5))
	end), fetched.dispose
end

return getSchoolMembers
