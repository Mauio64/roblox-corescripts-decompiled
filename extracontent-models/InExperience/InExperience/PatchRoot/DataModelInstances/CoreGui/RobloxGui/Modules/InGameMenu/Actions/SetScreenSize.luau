local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("SET_SCREEN_SIZE", function(newScreenSize)
	return { newScreenSize = newScreenSize }
end)
