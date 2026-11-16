local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(experienceInfo)
	return { experienceInfo = experienceInfo }
end)
