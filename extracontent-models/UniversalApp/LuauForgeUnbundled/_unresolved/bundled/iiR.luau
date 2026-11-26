local CorePackages = game:GetService("CorePackages")

local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dRq")
local module2 = require("@luauforge/bundled/dSA")
local module3 = require("@luauforge/bundled/dRt")
local module4 = require("@luauforge/bundled/dRu")
local module5 = require("@luauforge/bundled/fDB")
local module6 = require("@luauforge/bundled/dRz")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module7 = require("@luauforge/bundled/dRg")
local module8 = require("@luauforge/bundled/dPN")
local module9 = require("@luauforge/bundled/dRv")
local module10 = require("@luauforge/bundled/gLU")
local module11 = require("@luauforge/bundled/dSj")
local module12 = require("@luauforge/bundled/dzP")
require("@luauforge/bundled/dPs")

local defineFastFlag = game:DefineFastFlag("AXFixShoesInPurchasedCharacters", false)

local module13 = require("@luauforge/bundled/dRr")

local fFlagAXMigrateOutfitsToUserInventory = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMigrateOutfitsToUserInventory

local fFlagAXRefetchInventoryOnUpdate = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXRefetchInventoryOnUpdate
local fFlagAXMakeupIECGrantFix = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMakeupIECGrantFix
local module14 = require("@luauforge/bundled/dPt")
local avatarEditorSubcategories = module14.Enums.AvatarEditorSubcategories
local inventoryOutfitType = module14.Enums.InventoryOutfitType

local v5 = memoize(function()
	local v6 = module6()

	for k, v7 in v6 do
		if not (v7 and v7.Subcategories) then
			continue
		end

		for k2, subcategory in v7.Subcategories do
			if subcategory and subcategory.OutfitType == module8.OutfitTypes.DynamicHead then
				return subcategory.SearchUuid
			end
		end
	end

	return nil
end)

return function(p2, p3)
	module12.isType(p2, "string", "GrantOutfit thunk expects outfitId to be a string")
	return function(object)
		local ownedItemIdsBySubtype, ownedItemIdsBySubtype2

		if module13() then
			ownedItemIdsBySubtype = nil
			ownedItemIdsBySubtype2 = nil
		else
			ownedItemIdsBySubtype = object:getState().AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
			object:dispatch(module(p2))
			ownedItemIdsBySubtype2 = object:getState().AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
		end

		object:dispatch(module5(p2)):andThen(function()
			local state = object:getState()
			local joined = state.AvatarExperience.AvatarEditor.OutfitInfos[tostring(p2)]

			if fFlagAXRefetchInventoryOnUpdate and joined then
				module10({
					inventoryOutfitType = joined.inventoryType,
					outfitType = joined.outfitType,
					isEditable = joined.isEditable
				})
			end

			if
				fFlagAXMakeupIECGrantFix
				and joined.outfitType == module8.OutfitTypes.Makeup
				and not joined.isEditable
			then
				joined = Cryo.Dictionary.join(joined, {
					moderationStatus = Enum.ModerationStatus.NotReviewed
				})

				object:dispatch(module11(joined))
			end

			if module13() then
				local v6 = joined.outfitType
				local v7

				if fFlagAXMigrateOutfitsToUserInventory then
					v7 = joined.inventoryType == inventoryOutfitType.Animations
				else
					v7 = joined.inventoryType == module8.OutfitTypes.Animations
				end

				if v7 then
					v6 = module8.OutfitTypes.Animations
				elseif v6 == module8.OutfitTypes.Avatar and joined.isEditable then
					v6 = module8.OutfitTypes.EditableAvatar
				end

				ownedItemIdsBySubtype = object:getState().AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype

				if not fFlagAXRefetchInventoryOnUpdate then
					local v11 = if fFlagAXMigrateOutfitsToUserInventory then joined.isEditable else nil
					object:dispatch(module(p2, v6, v11))
				end

				ownedItemIdsBySubtype2 = object:getState().AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
				object:dispatch(module2(v6))
			end

			if p2 and joined.outfitType == module8.OutfitTypes.DynamicHead then
				local v6 = v5()

				if v6 then
					if not fFlagAXRefetchInventoryOnUpdate then
						object:dispatch(module9(v6, p2))
					end

					if not module13() then
						object:dispatch(module2(module8.OutfitTypes.DynamicHead))
					end
				end
			else
				local v6 = joined.outfitType == module8.OutfitTypes.Makeup

				if p2 and v6 then
					if not fFlagAXRefetchInventoryOnUpdate then
						local v9 = if fFlagAXMigrateOutfitsToUserInventory then avatarEditorSubcategories.MakeupLooks else module7.MakeupOutfitKey
						object:dispatch(module9(v9, p2))
					end
				elseif p2 and joined.isEditable then
					if not fFlagAXRefetchInventoryOnUpdate then
						object:dispatch(module3(p2))
					end
				elseif
					ownedItemIdsBySubtype ~= ownedItemIdsBySubtype2
					and (not defineFastFlag or joined.outfitType == module8.OutfitTypes.Avatar)
				then
					if p2 and not (joined.isEditable or fFlagAXRefetchInventoryOnUpdate) then
						object:dispatch(module4(p2))
					end

					if not module13() then
						local v7 = p3 == avatarScreen.AvatarEditor
						local category = state.AvatarExperience.AvatarEditor.Categories.category
						local subcategory = state.AvatarExperience.AvatarEditor.Categories.subcategory
						local v8 = module6()[category]
						local subcategories = v8 and v8.Subcategories or nil

						if
							not v7
							or not subcategories
							or subcategories[subcategory].SearchUuid ~= module7.PurchasedCharacterKey
						then
							object:dispatch(module2(module8.OutfitTypes.Avatar))
						end
					end
				end
			end
		end)
	end
end
