local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GetAvatarEditorStructure = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorStructure)
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local getStaleInventoryGrantStore = AvatarExperienceSlotBasedEditor.Stores.getStaleInventoryGrantStore
local AvatarEditorCategories = AvatarExperienceSlotBasedEditor.Enums.AvatarEditorCategories
local FFlagAXRefetchInventoryOnAssetGrant = AvatarExperienceFlags.FFlagAXRefetchInventoryOnAssetGrant

local function markAllSearchUuidsStale(p1, t1: {[any]: any}?) -- line: 31
	if not t1 then
		return
	end

	for _, v24 in t1 do
		p1.markSearchUuidStale(v24)
	end
end
local function getAllTabSearchUuid() -- line: 40
	-- upvalues: GetAvatarEditorCategories (copy), AvatarEditorCategories (copy)
	for _, v26 in GetAvatarEditorCategories() do
		if v26.Id == AvatarEditorCategories.All and v26.SearchUuid then
			return v26.SearchUuid
		end
	end

	return nil
end
local function appendUniqueSearchUuid(t2: {[any]: any}, s1: string?) -- line: 49
	if not s1 then
		return t2
	end

	for _, v30 in t2 do
		if v30 == s1 then
			return t2
		end
	end

	local v31 = table.clone(t2)

	v31[#v31 + 1] = s1

	return v31
end
local function markSearchUuidSeen(t3: {[any]: any}, t4: {[any]: any}, s2: string?) -- line: 63
	if not s2 or t4[s2] then
		return
	end

	t4[s2] = true
	t3[#t3 + 1] = s2
end
local function getOutfitInventoryKeysForGrant(s3: string) -- line: 71
	-- upvalues: Constants2 (copy), Constants (copy), GetAvatarEditorCategories (copy)
	if s3 == Constants2.OutfitTypes.EditableAvatar then
		return { Constants.EditableCharacterKey }
	end

	if s3 == Constants2.OutfitTypes.Avatar then
		return {
			Constants.PurchasedCharacterKey,
			Constants.CharacterKey
		}
	end

	if s3 == Constants2.OutfitTypes.Makeup then
		return { Constants.MakeupOutfitKey }
	end

	if s3 == Constants2.OutfitTypes.DynamicHead then
		for _, v37 in GetAvatarEditorCategories() do
			if v37.Subcategories then
				for _, v39 in v37.Subcategories do
					if v39.OutfitType == Constants2.OutfitTypes.DynamicHead and v39.SearchUuid then
						return { v39.SearchUuid }
					end
				end
			end
		end
	end

	return {}
end
local function getBundleTypeIdStringsForOutfitType(s4: string) -- line: 92
	-- upvalues: Constants2 (copy)
	if s4 == Constants2.OutfitTypes.EditableAvatar then
		return { Constants2.BundleTypeIdStrings.Avatars }
	end

	local t5 = {}

	for v42, v43 in Constants2.BundleTypeIdStringToOutfitType do
		if v43 == s4 then
			t5[#t5 + 1] = v42
		end
	end

	return t5
end
local function collectSearchUuidsForBundleTypes(t6: {[any]: any}, t7: {[any]: any}, t8: {[any]: any}, t9: {[any]: any}) -- line: 106
	-- upvalues: collectSearchUuidsForBundleTypes (copy)
	for _, v49 in t6 do
		local v50 = v49.BundleTypeIdStrings or v49.BundleTypes

		if v49.SearchUuid and v50 then
			for _, v52 in v50 do
				for _, v54 in t7 do
					if v52 == v54 then
						local SearchUuid = v49.SearchUuid

						if SearchUuid and not t9[SearchUuid] then
							t9[SearchUuid] = true
							t8[#t8 + 1] = SearchUuid
						end
					end
				end
			end
		end

		if v49.Subcategories then
			collectSearchUuidsForBundleTypes(v49.Subcategories, t7, t8, t9)
		end

		if v49.SubcategoryFilters then
			collectSearchUuidsForBundleTypes(v49.SubcategoryFilters, t7, t8, t9)
		end
	end
end
local function getSearchUuidsForGrant(t10: {[any]: any}) -- line: 137
	-- upvalues: GetAvatarEditorStructure (copy), GetAvatarEditorCategories (copy), AvatarEditorCategories (copy), getOutfitInventoryKeysForGrant (copy), getBundleTypeIdStringsForOutfitType (copy), collectSearchUuidsForBundleTypes (copy)
	if t10.assetTypeIdString then
		local v57 = GetAvatarEditorStructure().AssetTypeToSearchUuids[t10.assetTypeIdString] or {}
		local g61 = nil
		local SearchUuid = nil

		for _, v59 in GetAvatarEditorCategories() do
			if v59.Id == AvatarEditorCategories.All and v59.SearchUuid then
				SearchUuid = v59.SearchUuid
				g61 = true
			end

			if g61 then
				break
			end
		end

		if not g61 then
			SearchUuid = nil
		end

		g61 = false

		if not SearchUuid then
			return v57
		end

		for _, v63 in v57 do
			if v63 == SearchUuid then
				return v57
			end
		end

		local v64 = table.clone(v57)

		v64[#v64 + 1] = SearchUuid

		return v64
	end

	local outfitType = t10.outfitType
	local t11 = {}
	local t12 = {}
	local g74 = nil
	local SearchUuid = nil

	if outfitType then
		for _, v69 in getOutfitInventoryKeysForGrant(outfitType) do
			if v69 and not t12[v69] then
				t12[v69] = true
				t11[#t11 + 1] = v69
			end
		end

		local v70 = getBundleTypeIdStringsForOutfitType(outfitType)

		collectSearchUuidsForBundleTypes(GetAvatarEditorCategories(), v70, t11, t12)
	end

	for _, v72 in GetAvatarEditorCategories() do
		if v72.Id == AvatarEditorCategories.All and v72.SearchUuid then
			SearchUuid = v72.SearchUuid
			g74 = true
		end

		if g74 then
			break
		end
	end

	if not g74 then
		SearchUuid = nil
	end

	g74 = false

	if SearchUuid then
		if t12[SearchUuid] then
			return t11
		end

		t12[SearchUuid] = true
		t11[#t11 + 1] = SearchUuid
	end

	return t11
end

return function(t13: {[any]: any}) -- line: 161
	-- upvalues: ArgCheck (copy), FFlagAXRefetchInventoryOnAssetGrant (copy), getStaleInventoryGrantStore (copy), getSearchUuidsForGrant (copy)
	ArgCheck.isType(t13, "table", "markInventoryStaleOnGrant expects grantCategory")

	if not FFlagAXRefetchInventoryOnAssetGrant then
		return
	end

	local v76 = getStaleInventoryGrantStore()
	local v77 = getSearchUuidsForGrant(t13)

	if not v77 then
		return
	end

	for _, v79 in v77 do
		v76.markSearchUuidStale(v79)
	end
end
