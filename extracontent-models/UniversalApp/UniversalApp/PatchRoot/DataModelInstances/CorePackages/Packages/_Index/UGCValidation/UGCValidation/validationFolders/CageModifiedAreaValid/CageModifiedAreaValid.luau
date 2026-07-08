local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local WrapTargetCageUVReferenceValues = require(ParentParent.WrapTargetCageUVReferenceValues)
local CollisionTestUtil = require(ParentParent.util.CollisionTestUtil)
local StringUtil = require(ParentParent.util.StringUtil)
local getFFlagUGCValidateMigrateCageUV = require(ParentParent.flags.getFFlagUGCValidateMigrateCageUV)
local v9 = game:DefineFastInt("UGCValidateExcludedUVModifyRequirements", 14)
local v10 = game:DefineFastInt("UGCValidatePartUVModifyRequirements", 45)
local v11 = game:DefineFastInt("UGCValidateRenderMeshInsideModifiedArea", 70)
local num = tonumber((game:DefineFastString("UGCValidateModifiedAreaPaddingModifier", "1.1")))
local t1 = {}
local t2 = {
	[Enum.AssetType.LeftShoeAccessory] = {
		allowedParts = {
			LeftFoot = true,
			LeftLowerLeg = true,
			LeftUpperLeg = true
		},
		mainParts = {
			LeftFoot = true
		}
	},
	[Enum.AssetType.RightShoeAccessory] = {
		allowedParts = {
			RightFoot = true,
			RightLowerLeg = true,
			RightUpperLeg = true
		},
		mainParts = {
			RightFoot = true
		}
	}
}

t1.categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING }
t1.requiredData = {
	ValidationEnums.SharedDataMember.innerCagesData,
	ValidationEnums.SharedDataMember.outerCagesData,
	ValidationEnums.SharedDataMember.renderMeshesData
}
t1.conditionalData = {}
t1.fflag = getFFlagUGCValidateMigrateCageUV
t1.expectedFailures = {}

local function gatherUVs(t3: {[any]: any}) -- line: 84
	-- upvalues: WrapTargetCageUVReferenceValues (copy)
	local t4 = {}

	for v21 in t3 do
		for _, v23 in (assert(WrapTargetCageUVReferenceValues[v21], "Body area not found in UV reference values")) do
			table.insert(t4, v23)
		end
	end

	return t4
end
local function lazyGetUVsExcludedForAssetType(t5: {[any]: any}) -- line: 96
	-- upvalues: WrapTargetCageUVReferenceValues (copy), gatherUVs (copy)
	if not t5.uVsDisallowedForAssetType then
		local t6 = {}

		for v26 in WrapTargetCageUVReferenceValues do
			if not t5.allowedParts[v26] then
				t6[v26] = true
			end
		end

		t5.uVsDisallowedForAssetType = gatherUVs(t6)
	end

	return t5.uVsDisallowedForAssetType
end
local function lazyGetUVsForAssetType(t7: {[any]: any}) -- line: 110
	-- upvalues: gatherUVs (copy)
	if not t7.uVsForAssetType then
		t7.uVsForAssetType = gatherUVs(t7.allowedParts)
	end

	return t7.uVsForAssetType
end
local function lazyGetMainUVsForAssetType(t8: {[any]: any}) -- line: 117
	-- upvalues: gatherUVs (copy)
	if not t8.mainUVsForAssetType then
		t8.mainUVsForAssetType = gatherUVs(t8.mainParts)
	end

	return t8.mainUVsForAssetType
end

function t1.run(p1, p2) -- line: 124
	-- upvalues: t2 (copy), lazyGetUVsExcludedForAssetType (copy), UGCValidationService (copy), v9 (copy), ErrorSourceStrings (copy), StringUtil (copy), gatherUVs (copy), v10 (copy), num (copy), CollisionTestUtil (copy), v11 (copy)
	local assetType = p2.uploadEnum.assetType
	local v32 = t2[assetType]

	if not v32 then
		return
	end

	local Handle = p2.innerCagesData.Handle
	local Handle2 = p2.outerCagesData.Handle

	if not Handle or not Handle2 then
		return
	end

	local origin = Handle.origin
	local origin2 = Handle2.origin
	local v37 = lazyGetUVsExcludedForAssetType(v32)

	if #v37 > 0 then
		local v38, v39, v40 = UGCValidationService:CalculateEditableMeshNumModifiedCageUVsInSet(v37, Handle.editable, origin, Handle2.editable, origin2)

		assert(v38 == #v37, "all the UVs in allExcludedUVsForBodyArea sent in to CalculateEditableMeshNumModifiedCageUVsInSet should be unique")

		if v39 ~= 0 then
			local v41 = v40 / v39 * 100

			if v41 > v9 then
				p1:fail(ErrorSourceStrings.Keys.CageUV_TooManyExcludedModified, {
					modifiedPercent = tostring((math.floor(v41))),
					assetTypeName = assetType.Name,
					maxPercent = tostring(v9),
					allowedArea = StringUtil.keysToString(v32.allowedParts, "/")
				})
			end
		end
	end

	if not v32.mainUVsForAssetType then
		v32.mainUVsForAssetType = gatherUVs(v32.mainParts)
	end

	local mainUVsForAssetType = v32.mainUVsForAssetType

	if #mainUVsForAssetType > 0 then
		local v43, _, v45 = UGCValidationService:CalculateEditableMeshNumModifiedCageUVsInSet(mainUVsForAssetType, Handle.editable, origin, Handle2.editable, origin2)

		assert(v43 == #mainUVsForAssetType, "all the UVs in allUVsForBodyArea sent in to CalculateEditableMeshNumModifiedCageUVsInSet should be unique")

		local v46 = v45 / v43 * 100

		if v46 < v10 then
			p1:fail(ErrorSourceStrings.Keys.CageUV_TooFewMainModified, {
				assetTypeName = assetType.Name,
				requiredPercent = tostring(v10),
				mainArea = StringUtil.keysToString(v32.mainParts, "/"),
				currentPercent = tostring((math.floor(v46)))
			})
		end
	end

	if not v32.uVsForAssetType then
		v32.uVsForAssetType = gatherUVs(v32.allowedParts)
	end

	local uVsForAssetType = v32.uVsForAssetType

	if #uVsForAssetType > 0 then
		local Handle3 = p2.renderMeshesData.Handle

		if not Handle3 then
			return
		end

		local v49, v50 = UGCValidationService:CalculateEditableMeshModifiedCageBoundingBox(uVsForAssetType, Handle.editable, origin, Handle2.editable, origin2)
		local EditableMeshVerts = UGCValidationService:GetEditableMeshVerts(Handle3.editable)

		if not EditableMeshVerts or #EditableMeshVerts == 0 then
			p1:fail(ErrorSourceStrings.Keys.CageUV_RenderMeshBoundsCheckFailed)

			return
		end

		local v52 = v50 * num
		local n1 = 0

		for _, v55 in EditableMeshVerts do
			if CollisionTestUtil.pointInAxisAlignedBounds(v55, v49, v52) then
				n1 += 1
			end
		end

		local v56 = n1 / #EditableMeshVerts * 100

		if v56 < v11 then
			local v57 = StringUtil.keysToString(v32.allowedParts, "/")

			p1:fail(ErrorSourceStrings.Keys.CageUV_RenderMeshOutsideModifiedArea, {
				currentPercent = tostring((math.floor(v56))),
				allowedArea = v57,
				requiredPercent = tostring(v11)
			})
		end
	end
end

return t1
