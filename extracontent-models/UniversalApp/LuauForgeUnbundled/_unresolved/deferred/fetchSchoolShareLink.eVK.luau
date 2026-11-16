local module = require("@luauforge/deferred/ehk")

local module2 = require("@luauforge/deferred/ehm")
local module3 = require("@luauforge/deferred/eVn")

local function fetchSchoolShareLink(surface)
	local fetch = module.fetch
	local v5 = {
		method = "POST",
		url = module2.shareLink,
		analyticsKey = "school-verification.create-share-link",
		body = 0,
		decode = 0
	}

	if not module3 then
		surface = nil
	end

	v5.body = { rewardType = "earlyBirdBackpack", surface = surface }

	function v5.decode(p2)
		if typeof(p2) == "table" and typeof(p2.shareLink) == "string" then
			return p2.shareLink
		end

		return nil
	end

	local fetched = fetch(v5)

	local v7, v8 = module.asPromise(fetched):await()

	if v7 and v8 ~= nil then
		return v8
	end

	return nil
end

return fetchSchoolShareLink
