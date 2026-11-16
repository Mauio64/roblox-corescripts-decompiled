local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("IncrementSavedCharacterModelVersion", function()
	return {}
end)
