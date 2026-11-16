local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("SET_CURRENT_PAGE", function(newPage)
	return { newPage = newPage }
end)
