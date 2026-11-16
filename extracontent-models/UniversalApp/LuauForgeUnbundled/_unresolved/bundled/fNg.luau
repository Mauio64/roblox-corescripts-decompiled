local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/fNh")

return function(p2)
	return module((Cryo.Dictionary.join(p2, { waitImpl = wait })))
end
