local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GrantAsset = require(Modules.AvatarExperience.AvatarEditor.Actions.GrantAsset)
local AddNewAssetNotification = require(Modules.AvatarExperience.Common.Actions.AddNewAssetNotification)
local FetchAssetOrBundleInfo = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetOrBundleInfo)
local markInventoryStaleOnGrant = require(Modules.AvatarExperience.AvatarEditor.markInventoryStaleOnGrant)
local FFlagAXRefetchInventoryOnAssetGrant = AvatarExperienceFlags.FFlagAXRefetchInventoryOnAssetGrant
local Constants = require(Modules.AvatarExperience.Common.Constants)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local function v14(p1, p2, p3) -- line: 25
	-- upvalues: AvatarScreen (copy), GetAvatarEditorCategories (copy)
	local v18 = p2 == AvatarScreen.AvatarEditor
	local category = p1.AvatarExperience.AvatarEditor.Categories.category
	local subcategory = p1.AvatarExperience.AvatarEditor.Categories.subcategory
	local v21 = GetAvatarEditorCategories()[category]

	if v18 then
		local v22 = v21 and v21.Subcategories or nil
		local v23 = v22 and v22[subcategory].AssetTypeIdStrings or v21.AssetTypeIdStrings

		if v23 then
			for _, v25 in v23 do
				if v25 == p3 then
					return true
				end
			end
		end
	end

	return false
end

return function(p4, p5, p6, p7, p8) -- line: 47
	-- upvalues: ArgCheck (copy), FFlagAXInventoryDurablesSupport (copy), FFlagAXRefetchInventoryOnAssetGrant (copy), markInventoryStaleOnGrant (copy), GrantAsset (copy), FetchAssetOrBundleInfo (copy), Constants (copy), v14 (copy), AddNewAssetNotification (copy)
	ArgCheck.isType(p5, "string", "GrantAsset request expects assetId")
	ArgCheck.isType(p4, "string", "GrantAsset request expects assetTypeIdString")

	return function(p9) -- line: 50
		-- upvalues: FFlagAXInventoryDurablesSupport (copy), FFlagAXRefetchInventoryOnAssetGrant (copy), markInventoryStaleOnGrant (copy), p4 (copy), GrantAsset (copy), p5 (copy), FetchAssetOrBundleInfo (copy), p6 (copy), p7 (copy), Constants (copy), v14 (copy), p8 (copy), AddNewAssetNotification (copy)
		local OwnedItemIdsBySubtype = p9:getState().AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
		local v33 = not not FFlagAXInventoryDurablesSupport or nil

		if FFlagAXRefetchInventoryOnAssetGrant then
			markInventoryStaleOnGrant({
				assetTypeIdString = p4
			})
		else
			p9:dispatch(GrantAsset(p4, p5))
			p9:dispatch(FetchAssetOrBundleInfo(p6, p7, p5, Constants.ItemType.Asset, if not FFlagAXInventoryDurablesSupport then nil else v33))
		end

		local v34 = if not FFlagAXRefetchInventoryOnAssetGrant then p9:getState().AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype else nil

		if (FFlagAXRefetchInventoryOnAssetGrant or OwnedItemIdsBySubtype ~= v34) and not v14(p9:getState(), p8, p4) then
			p9:dispatch(AddNewAssetNotification(p4))
		end
	end
end
