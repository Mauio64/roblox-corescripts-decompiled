local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local WrapTargetCageUVReferenceValues = require(ParentParent.WrapTargetCageUVReferenceValues)

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local getMeshVerts = require(ParentParent.util.getMeshVerts)
local CollisionTestUtil = require(ParentParent.util.CollisionTestUtil)
local StringUtil = require(ParentParent.util.StringUtil)
local v10 = game:DefineFastInt("UGCValidateExcludedUVModifyRequirements", 14)
local v11 = game:DefineFastInt("UGCValidatePartUVModifyRequirements", 45)
local v12 = game:DefineFastInt("UGCValidateRenderMeshInsideModifiedArea", 70)
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

local function reportTestFailedToExecute(s1: string, s2: string, p1) -- line: 58
	-- upvalues: Analytics (copy)
	if p1.isServer ~= nil and p1.isServer then
		error(s1)
	end

	Analytics.reportFailure(s2, nil, p1)

	return false, { s1 }
end
local function gatherUVs(t3: {[any]: any}) -- line: 73
	-- upvalues: WrapTargetCageUVReferenceValues (copy)
	local t4 = {}

	for v26 in t3 do
		for _, v28 in (assert(WrapTargetCageUVReferenceValues[v26], "Body area not found in UV reference values")) do
			table.insert(t4, v28)
		end
	end

	return t4
end
local function lazyGetUVsExcludedForAssetType(p2) -- line: 87
	-- upvalues: WrapTargetCageUVReferenceValues (copy), gatherUVs (copy)
	if not p2.uVsDisallowedForAssetType then
		local t5 = {}

		for v31 in WrapTargetCageUVReferenceValues do
			if not p2.allowedParts[v31] then
				t5[v31] = true
			end
		end

		p2.uVsDisallowedForAssetType = gatherUVs(t5)
	end

	return p2.uVsDisallowedForAssetType
end
local function lazyGetUVsForAssetType(p3) -- line: 102
	-- upvalues: gatherUVs (copy)
	if not p3.uVsForAssetType then
		p3.uVsForAssetType = gatherUVs(p3.allowedParts)
	end

	return p3.uVsForAssetType
end
local function lazyGetMainUVsForAssetType(p4) -- line: 110
	-- upvalues: gatherUVs (copy)
	if not p4.mainUVsForAssetType then
		p4.mainUVsForAssetType = gatherUVs(p4.mainParts)
	end

	return p4.mainUVsForAssetType
end

function t1.validateExcludedModifiedUVs(p5, cFrame: CFrame, p6, cFrame2: CFrame, p7) -- line: 121
	-- upvalues: t2 (copy), lazyGetUVsExcludedForAssetType (copy), pcallDeferred (copy), UGCValidationService (copy), reportTestFailedToExecute (copy), Analytics (copy), v10 (copy), StringUtil (copy)
	local v39 = assert(t2[p7.assetTypeEnum], "bodyArea should be defined")
	local v40 = lazyGetUVsExcludedForAssetType(v39)

	if #v40 == 0 then
		return true
	end

	local v41, v42, v43, v44 = pcallDeferred(function() -- line: 136
		-- upvalues: UGCValidationService (copy), v40 (copy), p5 (copy), cFrame (copy), p6 (copy), cFrame2 (copy)
		return UGCValidationService:CalculateEditableMeshNumModifiedCageUVsInSet(v40, p5.editableMesh, cFrame, p6.editableMesh, cFrame2)
	end, p7)

	if not v41 then
		return reportTestFailedToExecute("Failed to execute excluded modified cage UV check. Make sure both cage meshes exists and try again.", Analytics.ErrorType.validateExcludedModifiedCageUVs_FailedToExecute, p7)
	end

	assert(v42 == #v40, "all the UVs in allExcludedUVsForBodyArea sent in to CalculateEditableMeshNumModifiedCageUVsInSet should be unique")

	if v43 == 0 then
		return true
	end

	local v45 = v44 / v43 * 100

	if v45 > v10 then
		Analytics.reportFailure(Analytics.ErrorType.validateExcludedModifiedCageUVs_UnexpectedUVValue, nil, p7)

		return false, { string.format("%d%% of modified cage UVs in WrapLayer CageMesh (outer mesh) are outside the expected region of the body. For a %s no more than %d%% of the modified UVs can be outside the %s area. Move your asset to the correct area of the body.", math.floor(v45), p7.assetTypeEnum.Name, v10, StringUtil.keysToString(v39.allowedParts, "/")) }
	end

	return true
end
function t1.validateMainModifiedUVs(p8, cFrame: CFrame, p9, cFrame3: CFrame, p10) -- line: 190
	-- upvalues: t2 (copy), gatherUVs (copy), pcallDeferred (copy), UGCValidationService (copy), reportTestFailedToExecute (copy), Analytics (copy), v11 (copy), StringUtil (copy)
	local v51 = assert(t2[p10.assetTypeEnum], "bodyArea should be defined")

	if not v51.mainUVsForAssetType then
		v51.mainUVsForAssetType = gatherUVs(v51.mainParts)
	end

	local mainUVsForAssetType = v51.mainUVsForAssetType

	if #mainUVsForAssetType == 0 then
		return true
	end

	local v53, v54, _, v56 = pcallDeferred(function() -- line: 205
		-- upvalues: UGCValidationService (copy), mainUVsForAssetType (copy), p8 (copy), cFrame (copy), p9 (copy), cFrame3 (copy)
		return UGCValidationService:CalculateEditableMeshNumModifiedCageUVsInSet(mainUVsForAssetType, p8.editableMesh, cFrame, p9.editableMesh, cFrame3)
	end, p10)

	if not v53 then
		return reportTestFailedToExecute("Failed to execute main modified cage UV check. Make sure both cage meshes exists and try again.", Analytics.ErrorType.validateMainModifiedCageUVs_FailedToExecute, p10)
	end

	assert(v54 == #mainUVsForAssetType, "all the UVs in allUVsForBodyArea sent in to CalculateEditableMeshNumModifiedCageUVsInSet should be unique")

	local v57 = v56 / v54 * 100

	if not (v57 >= v11) then
		Analytics.reportFailure(Analytics.ErrorType.validateMainModifiedCageUVs_TooFewModifiedUVsFound, nil, p10)

		return false, { string.format("The WrapLayer CageMesh (outer mesh) for a %s must modify %d%% of the cage UVs in the %s area. Currently only %d%% are modified. Move your asset to the correct area of the body.", p10.assetTypeEnum.Name, v11, StringUtil.keysToString(v51.mainParts, "/"), (math.floor(v57))) }
	end

	return true
end
function t1.validateRenderMeshInsideModifiedOuterCageArea(p11, p12, cFrame: CFrame, p13, cFrame4: CFrame, p14) -- line: 251
	-- upvalues: t2 (copy), gatherUVs (copy), pcallDeferred (copy), UGCValidationService (copy), getMeshVerts (copy), reportTestFailedToExecute (copy), Analytics (copy), num (copy), CollisionTestUtil (copy), v12 (copy), StringUtil (copy)
	local v64 = assert(t2[p14.assetTypeEnum], "bodyArea should be defined")

	if not v64.uVsForAssetType then
		v64.uVsForAssetType = gatherUVs(v64.allowedParts)
	end

	local uVsForAssetType = v64.uVsForAssetType

	if #uVsForAssetType == 0 then
		return true
	end

	local v66, v67, v68 = pcallDeferred(function() -- line: 267
		-- upvalues: UGCValidationService (copy), uVsForAssetType (copy), p12 (copy), cFrame (copy), p13 (copy), cFrame4 (copy)
		return UGCValidationService:CalculateEditableMeshModifiedCageBoundingBox(uVsForAssetType, p12.editableMesh, cFrame, p13.editableMesh, cFrame4)
	end, p14)
	local v69 = nil

	if v66 then
		local v70, v71

		v66, v70, v71 = getMeshVerts(p11, p14)

		if v66 then
			if v71 and #v71 > 0 then
				v69 = v71
			else
				v66 = false
			end
		end
	end

	if not v66 then
		return reportTestFailedToExecute("Failed to execute testing render mesh inside bounding box of outer cage modified area. Make sure both cage meshes and render mesh exist and try again.", Analytics.ErrorType.validateRenderMeshInsideModifiedOuterCageArea_FailedToExecute, p14)
	end

	local v72 = v68 * num
	local n1 = 0

	for _, v75 in v69 do
		if CollisionTestUtil.pointInAxisAlignedBounds(v75, v67, v72) then
			n1 += 1
		end
	end

	local v76 = n1 / #v69 * 100

	if not (v76 >= v12) then
		Analytics.reportFailure(Analytics.ErrorType.validateRenderMeshInsideModifiedOuterCageArea_RenderMeshNotPositionedCorrectly, nil, p14)

		local v77 = StringUtil.keysToString(v64.allowedParts, "/")

		return false, { string.format("Only %d%% of the render mesh verts are situated in the modified %s area of the WrapLayer CageMesh (outer mesh). %d%% is required. Move the render mesh to be within the modified %s area of the WrapLayer CageMesh (outer mesh).", math.floor(v76), v77, v12, v77) }
	end

	return true
end
function t1.validate(p15, cFrame: CFrame, p16, cFrame5: CFrame, p17, p18) -- line: 330
	-- upvalues: t2 (copy), FailureReasonsAccumulator (copy), t1 (copy)
	local v84 = if not p18.assetTypeEnum then nil else t2[p18.assetTypeEnum]

	if not v84 then
		return true
	end

	assert(v84.allowedParts, "bodyArea.allowedParts should be defined")
	assert(v84.mainParts, "bodyArea.mainParts should be defined")

	local v85 = FailureReasonsAccumulator.new()

	v85:updateReasons(t1.validateExcludedModifiedUVs(p15, cFrame, p16, cFrame5, p18))
	v85:updateReasons(t1.validateMainModifiedUVs(p15, cFrame, p16, cFrame5, p18))
	v85:updateReasons(t1.validateRenderMeshInsideModifiedOuterCageArea(p17, p15, cFrame, p16, cFrame5, p18))

	return v85:getFinalResults()
end

return t1
