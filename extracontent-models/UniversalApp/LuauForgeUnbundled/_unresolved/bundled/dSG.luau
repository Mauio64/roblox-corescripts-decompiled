local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dRg")
local module2 = require("@luauforge/bundled/dFs")

return Rodux.makeActionCreator("SetSelectedBodyPartIndex", function(p2)
	if p2 < 0 or #module.BodyPartButtonData < p2 then
		module2("selectedBodyPartIndex is out of range")
	end

	return { selectedBodyPartIndex = p2 }
end)
