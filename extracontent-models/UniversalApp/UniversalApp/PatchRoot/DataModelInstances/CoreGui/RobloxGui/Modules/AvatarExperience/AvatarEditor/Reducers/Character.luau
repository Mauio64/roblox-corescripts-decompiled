local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local scriptParent = script.Parent
local AvatarType = require(scriptParent.AvatarType)
local AvatarScales = require(scriptParent.AvatarScales)
local BodyPartRangeIds = require(scriptParent.BodyPartRangeIds)
local BodyColor3s = require(scriptParent.BodyColor3s)
local OwnedItemIdsBySubtype = require(scriptParent.OwnedItemIdsBySubtype)
local EquippedAssets = require(scriptParent.EquippedAssets)
local OutfitOrAsset = require(scriptParent.OutfitOrAsset)

require(Modules.AvatarExperience.Common.Types)

return Rodux.combineReducers({
	AvatarType = AvatarType,
	AvatarScales = AvatarScales,
	BodyColor3s = BodyColor3s,
	BodyPartRangeIds = BodyPartRangeIds,
	EquippedAssets = EquippedAssets,
	OwnedItemIdsBySubtype = OwnedItemIdsBySubtype,
	OutfitOrAsset = OutfitOrAsset
})
