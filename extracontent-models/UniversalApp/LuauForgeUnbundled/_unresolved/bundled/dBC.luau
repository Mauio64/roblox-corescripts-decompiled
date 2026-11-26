local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dBD")

return function(options, p2)
	local joined = options or {}

	if p2.type == module.name then
		joined = Cryo.Dictionary.join(joined, p2.subscriptionStatuses)
	end

	return joined
end
