local CorePackages = game:GetService("CorePackages")

local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)

local module = require("@luauforge/bundled/ilk")

local class = {}
class.__index = class

function class.new(p2, kind, p3)
	local v5 = {}
	setmetatable(v5, class)
	v5.kind = kind
	v5.data = p3
	return v5
end

function class.match(p2)
	return LuauPolyfill.instanceof(p2, class)
end

function class.matchAbandoned(p2)
	return class.match(p2) and p2.kind == module.Abandoned
end

function class.matchRateLimited(p2)
	if
		class.match(p2)
		and p2.kind == module.RateLimited
		and p2.data
		and p2.data.retryTime
		and DateTime.fromIsoDate(p2.data.retryTime)
	then
		return p2.data.retryTime
	end

	return nil
end

return class
