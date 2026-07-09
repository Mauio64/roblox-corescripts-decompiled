local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local GrantOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.GrantOutfit)
local AddNewOutfitNotification = require(Modules.AvatarExperience.Common.Actions.AddNewOutfitNotification)
local GrantEditableOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.GrantEditableOutfit)
local GrantPurchasedOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.GrantPurchasedOutfit)
local GetOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetOutfit)
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local GrantOutfitByType = require(Modules.AvatarExperience.AvatarEditor.Actions.GrantOutfitByType)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

require(Modules.AvatarExperience.Common.Types)

local v15 = game:DefineFastFlag("AXFixShoesInPurchasedCharacters", false)
local GetFFlagAXEnableNewInventoryItemsList = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableNewInventoryItemsList)
local FFlagAXFixMakeupLookGrantOutfitHoisting = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXFixMakeupLookGrantOutfitHoisting
local v18 = memoize(function() -- line: 49
	-- upvalues: GetAvatarEditorCategories (copy), Constants2 (copy)
	for _, v27 in (GetAvatarEditorCategories()) do
		if v27 and v27.Subcategories then
			for _, v29 in v27.Subcategories do
				if v29 and v29.OutfitType == Constants2.OutfitTypes.DynamicHead then
					return v29.SearchUuid
				end
			end
		end
	end

	return nil
end)

return function(p1, s1: string?) -- line: 65
	-- upvalues: ArgCheck (copy), GetFFlagAXEnableNewInventoryItemsList (copy), GrantOutfit (copy), GetOutfit (copy), Constants2 (copy), AddNewOutfitNotification (copy), v18 (copy), GrantOutfitByType (copy), FFlagAXFixMakeupLookGrantOutfitHoisting (copy), Constants (copy), GrantEditableOutfit (copy), v15 (copy), GrantPurchasedOutfit (copy), AvatarScreen (copy), GetAvatarEditorCategories (copy)
	ArgCheck.isType(p1, "string", "GrantOutfit thunk expects outfitId to be a string")

	return function(p2) -- line: 67
		-- upvalues: GetFFlagAXEnableNewInventoryItemsList (copy), GrantOutfit (copy), p1 (copy), GetOutfit (copy), Constants2 (copy), AddNewOutfitNotification (copy), v18 (copy), GrantOutfitByType (copy), FFlagAXFixMakeupLookGrantOutfitHoisting (copy), Constants (copy), GrantEditableOutfit (copy), v15 (copy), GrantPurchasedOutfit (copy), s1 (copy), AvatarScreen (copy), GetAvatarEditorCategories (copy)
		local OwnedItemIdsBySubtype = nil
		local OwnedItemIdsBySubtype2 = nil

		if not GetFFlagAXEnableNewInventoryItemsList() then
			OwnedItemIdsBySubtype = p2:getState().AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
			p2:dispatch(GrantOutfit(p1))
			OwnedItemIdsBySubtype2 = p2:getState().AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
		end

		p2:dispatch(GetOutfit(p1)):andThen(function() -- line: 75
			-- upvalues: p2 (copy), p1 (copy), GetFFlagAXEnableNewInventoryItemsList (copy), Constants2 (copy), OwnedItemIdsBySubtype (ref), GrantOutfit (copy), OwnedItemIdsBySubtype2 (ref), AddNewOutfitNotification (copy), v18 (copy), GrantOutfitByType (copy), FFlagAXFixMakeupLookGrantOutfitHoisting (copy), Constants (copy), GrantEditableOutfit (copy), v15 (copy), GrantPurchasedOutfit (copy), s1 (copy), AvatarScreen (copy), GetAvatarEditorCategories (copy)
			local v35 = p2:getState()
			local v36 = v35.AvatarExperience.AvatarEditor.OutfitInfos[tostring(p1)]

			if GetFFlagAXEnableNewInventoryItemsList() then
				local outfitType = v36.outfitType

				if v36.inventoryType == Constants2.OutfitTypes.Animations then
					outfitType = Constants2.OutfitTypes.Animations
				elseif outfitType == Constants2.OutfitTypes.Avatar and v36.isEditable then
					outfitType = Constants2.OutfitTypes.EditableAvatar
				end

				OwnedItemIdsBySubtype = p2:getState().AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
				p2:dispatch(GrantOutfit(p1, outfitType))
				OwnedItemIdsBySubtype2 = p2:getState().AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
				p2:dispatch(AddNewOutfitNotification(outfitType))
			end

			if p1 and v36.outfitType == Constants2.OutfitTypes.DynamicHead then
				local v38 = v18()

				if v38 then
					p2:dispatch(GrantOutfitByType(v38, p1))

					if not GetFFlagAXEnableNewInventoryItemsList() then
						p2:dispatch(AddNewOutfitNotification(Constants2.OutfitTypes.DynamicHead))
					end
				end

				return
			end

			local v39 = if not FFlagAXFixMakeupLookGrantOutfitHoisting then nil else v36.outfitType == Constants2.OutfitTypes.Makeup

			if FFlagAXFixMakeupLookGrantOutfitHoisting and p1 and v39 then
				p2:dispatch(GrantOutfitByType(Constants.MakeupOutfitKey, p1))

				return
			end

			if p1 and v36.isEditable then
				p2:dispatch(GrantEditableOutfit(p1))

				return
			end

			if OwnedItemIdsBySubtype ~= OwnedItemIdsBySubtype2 and (not v15 or v36.outfitType == Constants2.OutfitTypes.Avatar) then
				if p1 and not v36.isEditable then
					p2:dispatch(GrantPurchasedOutfit(p1))
				end

				if not GetFFlagAXEnableNewInventoryItemsList() then
					local v40 = s1 == AvatarScreen.AvatarEditor
					local category = v35.AvatarExperience.AvatarEditor.Categories.category
					local subcategory = v35.AvatarExperience.AvatarEditor.Categories.subcategory
					local v43 = GetAvatarEditorCategories()[category]
					local v44 = v43 and v43.Subcategories or nil

					if not v40 or (not v44 or v44[subcategory].SearchUuid ~= Constants.PurchasedCharacterKey) then
						p2:dispatch(AddNewOutfitNotification(Constants2.OutfitTypes.Avatar))
					end
				end
			end
		end)
	end
end
