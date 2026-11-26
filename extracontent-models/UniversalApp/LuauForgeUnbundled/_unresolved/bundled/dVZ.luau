local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetCreatorFilter", function(value)
	return {
		creatorFilter = value or ""
	}
end)
