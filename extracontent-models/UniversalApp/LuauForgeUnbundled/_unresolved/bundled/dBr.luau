local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dBs")

local module2 = require("@luauforge/bundled/dBt")

return function(p2, data)
	local joined = p2 or { count = 0, limit = 0 }

	assert(joined, "")

	if data.type == module.name then
		return (Cryo.Dictionary.join(joined, { count = data.count }))
	end

	if data.type == module2.name then
		joined = Cryo.Dictionary.join(joined, { limit = data.limit })
	end

	return joined
end
