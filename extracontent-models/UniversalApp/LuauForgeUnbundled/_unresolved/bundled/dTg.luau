local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dwM")

local function IncrementPPEVersion(p2)
	module.isType(p2, "userdata", "IncrementPPEVersion action expects thumbnailType to be userdata")
	return { thumbnailType = p2 }
end

return Rodux.makeActionCreator("IncrementPPEVersion", IncrementPPEVersion)
