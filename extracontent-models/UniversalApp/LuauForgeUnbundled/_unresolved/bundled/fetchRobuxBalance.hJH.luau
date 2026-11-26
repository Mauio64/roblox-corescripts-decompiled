local module = require("@luauforge/bundled/hIN")
local module2 = require("@luauforge/bundled/hIP")
local url = require("@luauforge/bundled/hIR").Url

local function decode(p2)
	local robux = if typeof(p2) == "table" then p2.robux else nil

	if typeof(robux) == "number" then
		return robux
	end

	return nil
end

local function fetchRobuxBalance(p2, p3)
	return module.asPromise(module.fetch({
		network = p3,
		method = "GET",
		url = `{url.ECONOMY_URL}v1/users/{p2}/currency`,
		analyticsKey = "economy.v1.users.currency",
		decode = decode,
		retry = false,
		headers = {}
	})):catch(function()
		return module2.resolve(nil)
	end)
end

return fetchRobuxBalance
