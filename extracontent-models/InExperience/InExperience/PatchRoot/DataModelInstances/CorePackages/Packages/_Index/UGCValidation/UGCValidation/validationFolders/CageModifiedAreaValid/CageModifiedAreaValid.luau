local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local WrapTargetCageUVReferenceValues = require(parent.WrapTargetCageUVReferenceValues)
local CollisionTestUtil = require(parent.util.CollisionTestUtil)
local StringUtil = require(parent.util.StringUtil)

local defineFastInt = game:DefineFastInt("UGCValidateExcludedUVModifyRequirements", 14)
local defineFastInt2 = game:DefineFastInt("UGCValidatePartUVModifyRequirements", 45)
local defineFastInt3 = game:DefineFastInt("UGCValidateRenderMeshInsideModifiedArea", 70)

local v = tonumber((game:DefineFastString("UGCValidateModifiedAreaPaddingModifier", "1.1")))

local v2 = {
	[Enum.AssetType.LeftShoeAccessory] = {
		allowedParts = { LeftFoot = true, LeftLowerLeg = true, LeftUpperLeg = true },
		mainParts = { LeftFoot = true }
	},
	[Enum.AssetType.RightShoeAccessory] = {
		allowedParts = { RightFoot = true, RightLowerLeg = true, RightUpperLeg = true },
		mainParts = { RightFoot = true }
	}
}
local CageModifiedAreaValid = {}

CageModifiedAreaValid.categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING }

CageModifiedAreaValid.requiredData = {
	ValidationEnums.SharedDataMember.innerCagesData,
	ValidationEnums.SharedDataMember.outerCagesData,
	ValidationEnums.SharedDataMember.renderMeshesData
}

CageModifiedAreaValid.conditionalData = {}

CageModifiedAreaValid.expectedFailures = {}

local function gatherUVs(items)
	local uvs = {}

	for k in items do
		local v3 = assert(WrapTargetCageUVReferenceValues[k], "Body area not found in UV reference values")

		for _, v4 in v3 do
			table.insert(uvs, v4)
		end
	end

	return uvs
end

local function lazyGetUVsExcludedForAssetType(state)
	if state.uVsDisallowedForAssetType then
		return state.uVsDisallowedForAssetType
	end

	local set = {}

	for k in WrapTargetCageUVReferenceValues do
		if not state.allowedParts[k] then
			set[k] = true
		end
	end

	state.uVsDisallowedForAssetType = gatherUVs(set)

	return state.uVsDisallowedForAssetType
end

local function lazyGetUVsForAssetType(state) -- 1 equivalent call inferred from this helper
	if not state.uVsForAssetType then
		state.uVsForAssetType = gatherUVs(state.allowedParts)
	end

	return state.uVsForAssetType
end

local function lazyGetMainUVsForAssetType(state) -- 1 equivalent call inferred from this helper
	if not state.mainUVsForAssetType then
		state.mainUVsForAssetType = gatherUVs(state.mainParts)
	end

	return state.mainUVsForAssetType
end

function CageModifiedAreaValid.run(object, data)
	local assetType = data.uploadEnum.assetType

	local v3 = v2[assetType]

	if not v3 then
		return
	end

	local handle = data.innerCagesData.Handle
	local handle2 = data.outerCagesData.Handle

	if not (handle and handle2) then
		return
	end

	local origin = handle.origin
	local origin2 = handle2.origin

	local v4 = lazyGetUVsExcludedForAssetType(v3)

	if #v4 > 0 then
		local editableMeshNumModifiedCageUVsInSet, v5, v6 = UGCValidationService:CalculateEditableMeshNumModifiedCageUVsInSet(
			v4,
			handle.editable,
			origin,
			handle2.editable,
			origin2
		)

		assert(
			editableMeshNumModifiedCageUVsInSet == #v4,
			"all the UVs in allExcludedUVsForBodyArea sent in to CalculateEditableMeshNumModifiedCageUVsInSet should be unique"
		)

		if v5 ~= 0 then
			local v7 = v6 / v5 * 100

			if defineFastInt < v7 then
				object:fail(ErrorSourceStrings.Keys.CageUV_TooManyExcludedModified, {
					modifiedPercent = tostring((math.floor(v7))),
					assetTypeName = assetType.Name,
					maxPercent = tostring(defineFastInt),
					allowedArea = StringUtil.keysToString(v3.allowedParts, "/")
				})
			end
		end
	end

	local v5 = lazyGetMainUVsForAssetType(v3) -- inferred equivalent call

	if #v5 > 0 then
		local editableMeshNumModifiedCageUVsInSet, _, v6 = UGCValidationService:CalculateEditableMeshNumModifiedCageUVsInSet(
			v5,
			handle.editable,
			origin,
			handle2.editable,
			origin2
		)

		assert(
			editableMeshNumModifiedCageUVsInSet == #v5,
			"all the UVs in allUVsForBodyArea sent in to CalculateEditableMeshNumModifiedCageUVsInSet should be unique"
		)

		local v7 = v6 / editableMeshNumModifiedCageUVsInSet * 100

		if v7 < defineFastInt2 then
			object:fail(ErrorSourceStrings.Keys.CageUV_TooFewMainModified, {
				assetTypeName = assetType.Name,
				requiredPercent = tostring(defineFastInt2),
				mainArea = StringUtil.keysToString(v3.mainParts, "/"),
				currentPercent = tostring((math.floor(v7)))
			})
		end
	end

	local v6 = lazyGetUVsForAssetType(v3) -- inferred equivalent call

	if #v6 > 0 then
		local handle3 = data.renderMeshesData.Handle

		if not handle3 then
			return
		end

		local editableMeshModifiedCageBoundingBox, v7 = UGCValidationService:CalculateEditableMeshModifiedCageBoundingBox(
			v6,
			handle.editable,
			origin,
			handle2.editable,
			origin2
		)

		local editableMeshVerts = UGCValidationService:GetEditableMeshVerts(handle3.editable)

		if not editableMeshVerts or #editableMeshVerts == 0 then
			object:fail(ErrorSourceStrings.Keys.CageUV_RenderMeshBoundsCheckFailed)
			return
		end

		local v8 = v7 * v
		local count = 0

		for _, editableMeshVert in editableMeshVerts do
			if CollisionTestUtil.pointInAxisAlignedBounds(editableMeshVert, editableMeshModifiedCageBoundingBox, v8) then
				count += 1
			end
		end

		local v9 = count / #editableMeshVerts * 100

		if v9 < defineFastInt3 then
			local keysToString = StringUtil.keysToString(v3.allowedParts, "/")
			object:fail(ErrorSourceStrings.Keys.CageUV_RenderMeshOutsideModifiedArea, {
				currentPercent = tostring((math.floor(v9))),
				allowedArea = keysToString,
				requiredPercent = tostring(defineFastInt3)
			})
		end
	end
end

return CageModifiedAreaValid
