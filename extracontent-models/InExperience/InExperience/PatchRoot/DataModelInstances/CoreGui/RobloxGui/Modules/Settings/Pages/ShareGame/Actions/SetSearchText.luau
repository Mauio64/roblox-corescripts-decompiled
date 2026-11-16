local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(searchText)
	return { searchText = searchText }
end)
