local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dRr")

return Rodux.makeActionCreator("GrantOutfit", function(p2, outfitType, isEditable)
	if not module() then
		outfitType = nil
	end

	if not module() then
		isEditable = nil
	end

	return { outfitId = p2, outfitType = outfitType, isEditable = isEditable }
end)
