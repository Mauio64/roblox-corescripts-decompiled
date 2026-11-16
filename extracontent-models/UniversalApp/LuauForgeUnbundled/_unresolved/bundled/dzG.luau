local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/dzH")

return function(p2, p3)
	local joined = p2 or { focused = false }

	if p3.type == module.name then
		joined = Cryo.Dictionary.join(joined, { focused = p3.focused })
	end

	return joined
end
