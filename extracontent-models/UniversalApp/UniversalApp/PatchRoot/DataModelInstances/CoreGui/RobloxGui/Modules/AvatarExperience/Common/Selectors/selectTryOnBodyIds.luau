local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)

local function getBodiesInTryOns(t1: {[any]: any}) -- line: 4
	-- upvalues: Constants (copy)
	local t2 = {}

	for v7, v8 in t1 do
		if v8.itemType == Constants.ItemType.Bundle and Constants.BundleTypeIdStringToNameForBackend[v8.itemSubType] == "Body" then
			table.insert(t2, v7)
		end
	end

	return t2
end
local function selectTryOnBodyIds(p1) -- line: 17
	-- upvalues: getBodiesInTryOns (copy)
	local OutfitTryOn = p1.AvatarExperience.AvatarScene.OutfitTryOn

	if OutfitTryOn and OutfitTryOn.TryOnItems then
		return (getBodiesInTryOns(OutfitTryOn.TryOnItems))
	end

	return {}
end

return selectTryOnBodyIds
