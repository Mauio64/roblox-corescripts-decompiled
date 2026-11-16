local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(equippedEmotes)
	return { equippedEmotes = equippedEmotes }
end)
