local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator
local module = require("@luauforge/bundled/dzO")

return makeActionCreator("SetDeveloperProductStatuses", function(p2, p3)
	module.isType(p2, "string", "universeId")
	module.isType(p3, "table", "developerProductStatusesTable")
	return { universeId = p2, developerProductStatuses = p3 }
end)
