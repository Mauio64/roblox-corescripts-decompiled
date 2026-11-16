local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dyy")

return function(options, p2)
	local joined = options or {}

	if p2.type == module.name then
		joined = Cryo.Dictionary.join(joined, p2.subscriptionProductsThumbnails)
	end

	return joined
end
