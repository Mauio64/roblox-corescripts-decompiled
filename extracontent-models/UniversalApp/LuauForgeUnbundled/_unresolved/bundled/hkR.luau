local module = require("@luauforge/bundled/dzP")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport

local SetTryingOnInfo = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Actions/SetTryingOnInfo")
local module4 = require("@luauforge/bundled/dSy")
local module5 = require("@luauforge/bundled/fCd")
local module6 = require("@luauforge/bundled/gLU")
local fFlagAXRefetchInventoryOnUpdate = AvatarExperienceFlags.FFlagAXRefetchInventoryOnUpdate
local module7 = require("@luauforge/bundled/dPN")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module8 = require("@luauforge/bundled/dRz")

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local function fn(p2, p3, p4): boolean
	local v5 = p3 == avatarScreen.AvatarEditor
	local category = p2.AvatarExperience.AvatarEditor.Categories.category
	local subcategory = p2.AvatarExperience.AvatarEditor.Categories.subcategory
	local v6 = module8()[category]

	if not v5 then
		return false
	end

	local subcategories = if v6 then v6.Subcategories or nil else nil
	local assetTypeIdStrings = subcategories and subcategories[subcategory].AssetTypeIdStrings
		or v6.AssetTypeIdStrings

	if assetTypeIdStrings then
		for k, assetTypeIdString in assetTypeIdStrings do
			if assetTypeIdString == p4 then
				return true
			end
		end
	end

	return false
end

return function(p2, p3, p4, p5, p6)
	module.isType(p3, "string", "GrantAsset request expects assetId")
	module.isType(p2, "string", "GrantAsset request expects assetTypeIdString")
	return function(object)
		local ownedItemIdsBySubtype = object:getState().AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
		local v5 = fFlagAXInventoryDurablesSupport and true or nil

		if fFlagAXRefetchInventoryOnUpdate then
			module6({ assetTypeIdString = p2 })
		else
			object:dispatch(SetTryingOnInfo(p2, p3))

			local asset = module7.ItemType.Asset

			if not fFlagAXInventoryDurablesSupport then
				v5 = nil
			end

			object:dispatch(module5(p4, p5, p3, asset, v5))
		end

		local v6

		if not fFlagAXRefetchInventoryOnUpdate then
			v6 = object:getState().AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
		end

		if
			(fFlagAXRefetchInventoryOnUpdate or ownedItemIdsBySubtype ~= v6)
			and not fn(object:getState(), p6, p2)
		then
			object:dispatch(module4(p2))
		end
	end
end
