local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetSelectedEmoteSlot", function(p2)
	return { selectedSlot = p2 }
end)
