local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local validateCoplanarIntersection = require(ParentParent.validation.validateCoplanarIntersection)
local validateCageUVs = require(ParentParent.validation.validateCageUVs)
local validateMeshVertColors = require(ParentParent.validation.validateMeshVertColors)
local validateCageUVTriangleArea = require(ParentParent.validation.validateCageUVTriangleArea)
local validateMeshTriangleArea = require(ParentParent.validation.validateMeshTriangleArea)
local validateCageUVValues = require(ParentParent.validation.validateCageUVValues)
local validateTotalSurfaceArea = require(ParentParent.validation.validateTotalSurfaceArea)
local validateSkinningTransfer = require(ParentParent.validation.validateSkinningTransfer)
local getFFlagUGCValidateMigrateCageUV = require(ParentParent.flags.getFFlagUGCValidateMigrateCageUV)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local ParseContentIds = require(ParentParent.util.ParseContentIds)
local getMeshMinMax = require(ParentParent.util.getMeshMinMax)
local getEditableMeshFromContext = require(ParentParent.util.getEditableMeshFromContext)
local floatEquals = require(ParentParent.util.floatEquals)
local getExpectedPartSize = require(ParentParent.util.getExpectedPartSize)
local getFFlagUGCValidateCoplanarTriTestBody = require(ParentParent.flags.getFFlagUGCValidateCoplanarTriTestBody)
local getFIntUGCValidateTriangleLimitTolerance = require(ParentParent.flags.getFIntUGCValidateTriangleLimitTolerance)
local getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning = require(ParentParent.flags.getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning)
local getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality = require(ParentParent.flags.getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality)
local getFFlagUGCValidateMigrateMeshGeometry = require(ParentParent.flags.getFFlagUGCValidateMigrateMeshGeometry)

local function validateIsSkinned(p1, b1: boolean?, b2: boolean?, p2) -- line: 40
	-- upvalues: Constants (copy), Analytics (copy), getEditableMeshFromContext (copy), UGCValidationService (copy)
	local ConstantsAlternateMeshIdAttributeName = p1:GetAttribute(Constants.AlternateMeshIdAttributeName)

	if not p1.HasSkinnedMesh and (ConstantsAlternateMeshIdAttributeName == nil or ConstantsAlternateMeshIdAttributeName == "" or not b2) then
		Analytics.reportFailure(Analytics.ErrorType.validateDescendantMeshMetrics_NoSkinningInfo, nil, p2)

		return false, { `Missing skinning data for { p1.Name }.MeshId. You need to skin your model.` }
	end

	local ok, result = pcall(function() -- line: 58
		-- upvalues: getEditableMeshFromContext (copy), p1 (copy), p2 (copy), UGCValidationService (copy)
		local v72, v73 = getEditableMeshFromContext(p1, "MeshId", p2)

		if not v72 then
			error("Failed to retrieve MeshContent")
		end

		return UGCValidationService:ValidateSkinnedEditableMesh(v73)
	end)

	if not ok then
		if b1 then
			error("Failed to retrieve mesh data to validate skinned mesh")
		end

		Analytics.reportFailure(Analytics.ErrorType.validateDescendantMeshMetrics_FailedToLoadMesh, nil, p2)

		return false, { "Failed to retrieve mesh data to validate skinned mesh" }
	end

	if not result then
		local v37 = `Detected mismatch between model and skinned data for { p1.Name }. You need to re-skin your model to fix this issue.`

		if b1 then
			error(v37)
		end

		Analytics.reportFailure(Analytics.ErrorType.validateDescendantMeshMetrics_HasSkinnedMeshMismatch, nil, p2)

		return false, { v37 }
	end

	return true
end
local function validateTotalAssetTriangles(p3, p4, p5) -- line: 101
	-- upvalues: Constants (copy), getEditableMeshFromContext (copy), Analytics (copy), pcallDeferred (copy), UGCValidationService (copy), getFIntUGCValidateTriangleLimitTolerance (copy)
	local isServer = p5.isServer
	local v42 = assert(Constants.ASSET_RENDER_MESH_MAX_TRIANGLES[p4.Name])

	local function calculateTotalAssetTriangles() -- line: 109
		-- upvalues: p3 (copy), getEditableMeshFromContext (copy), p5 (copy), Analytics (copy), pcallDeferred (copy), UGCValidationService (copy)
		local n1 = 0

		for _, v76 in p3 do
			if v76.instance.ClassName ~= "MeshPart" then
				continue
			end

			assert(v76.fieldName == "MeshId")

			local v77, v78 = getEditableMeshFromContext(v76.instance, v76.fieldName, p5)

			if not v77 then
				Analytics.reportFailure(Analytics.ErrorType.validateDescendantMeshMetrics_FailedToLoadMesh, nil, p5)

				return false, string.format("Failed to load mesh for '%s'. Make sure mesh exists and try again.", v76.instance.Name)
			end

			local v79, v80 = pcallDeferred(function() -- line: 132
				-- upvalues: UGCValidationService (copy), v78 (copy)
				return UGCValidationService:GetEditableMeshTriCount(v78)
			end, p5)

			if not v79 then
				return false, string.format("Failed to execute check for triangle face information for mesh '%s'. Make sure mesh exists and try again.", v76.instance.Name)
			end

			n1 += v80
		end

		return true, nil, n1
	end

	local v44, v45, v46 = calculateTotalAssetTriangles()

	if not v44 then
		if isServer then
			error(v45)
		end

		Analytics.reportFailure(Analytics.ErrorType.validateDescendantMeshMetrics_FailedToCalculateTriangles, nil, p5)

		return false, { v45 }
	end

	if v46 > v42 + v42 * (getFIntUGCValidateTriangleLimitTolerance() / 100) then
		Analytics.reportFailure(Analytics.ErrorType.validateDescendantMeshMetrics_TooManyTriangles, nil, p5)

		return false, { string.format("Mesh resolution of '%d' for '%s' is higher than max supported number of triangles '%d'. You need to retopologize your model to reduce the triangle count.", v46, p4.Name, v42) }
	end

	return true
end
local function validateMeshIsAtOrigin(p6, vector3: Vector3?, vector3_2: Vector3?, p7) -- line: 187
	-- upvalues: Analytics (copy)
	if (vector3 + (vector3_2 - vector3) / 2).Magnitude > 0.001 then
		Analytics.reportFailure(Analytics.ErrorType.validateDescendantMeshMetrics_TooFarFromOrigin, nil, p7)

		return false, { string.format("Bounds for the mesh '%s' are not centered at the origin. The max allowed distance is '%f'", p6.fullName, 0.001) }
	end

	return true
end
local function validateDescendantMeshMetrics(p8, p9) -- line: 218
	-- upvalues: FailureReasonsAccumulator (copy), ParseContentIds (copy), Constants (copy), getFFlagUGCValidateMigrateMeshGeometry (copy), validateTotalAssetTriangles (copy), Analytics (copy), getEditableMeshFromContext (copy), getMeshMinMax (copy), validateMeshIsAtOrigin (copy), floatEquals (copy), getExpectedPartSize (copy), validateTotalSurfaceArea (copy), getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality (copy), getFFlagUGCValidateCoplanarTriTestBody (copy), validateCoplanarIntersection (copy), validateMeshVertColors (copy), validateIsSkinned (copy), getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning (copy), validateSkinningTransfer (copy), validateMeshTriangleArea (copy), getFFlagUGCValidateMigrateCageUV (copy), validateCageUVs (copy), validateCageUVTriangleArea (copy), validateCageUVValues (copy)
	local isServer = p9.isServer

	assert(p9.assetTypeEnum ~= nil, "assetTypeEnum required in validationContext for validateDescendantMeshMetrics")

	local assetTypeEnum = p9.assetTypeEnum
	local allowEditableInstances = p9.allowEditableInstances
	local v56 = FailureReasonsAccumulator.new()
	local v57 = ParseContentIds.parse(p8, Constants.MESH_CONTENT_ID_FIELDS, p9)
	local timestamp = tick()

	if not getFFlagUGCValidateMigrateMeshGeometry() then
		v56:updateReasons(validateTotalAssetTriangles(v57, assetTypeEnum, p9))
	end

	Analytics.recordScriptTime("validateTotalAssetTriangles", timestamp, p9)

	for _, v60 in v57 do
		local t1 = {
			fullName = v60.instance:GetFullName(),
			fieldName = v60.fieldName,
			contentId = v60.instance[v60.fieldName],
			context = v60.instance.Name
		}
		local v62, v63 = getEditableMeshFromContext(v60.instance, v60.fieldName, p9)

		if not v62 then
			return false, { string.format("Failed to load mesh for '%s'. Make sure mesh exists and try again.", v60.instance.Name) }
		end

		t1.editableMesh = v63

		if v60.instance.ClassName == "MeshPart" then
			assert(v60.fieldName == "MeshId")

			local v64, v65, v66, v67 = getMeshMinMax(t1, p9)

			if not v64 then
				v56:updateReasons(false, v65)
			end

			if v64 then
				local timestamp2 = tick()

				v56:updateReasons(validateMeshIsAtOrigin(t1, v66, v67, p9))
				Analytics.recordScriptTime("validateMeshIsAtOrigin", timestamp2, p9)
			end

			if v66 and v67 then
				local v69 = v67 - v66

				if floatEquals(v69.X, 0) or floatEquals(v69.Y, 0) or floatEquals(v69.Z, 0) then
					v56:updateReasons(false, { "Mesh size is zero for " .. t1.fullName .. ". You need to rescale your mesh." })
				else
					local v70 = getExpectedPartSize(v60.instance, p9) / v69

					if not getFFlagUGCValidateMigrateMeshGeometry() then
						v56:updateReasons(validateTotalSurfaceArea(t1, v70, p9))
					end

					if not getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality() and getFFlagUGCValidateCoplanarTriTestBody() then
						v56:updateReasons(validateCoplanarIntersection(t1, v70, p9))
					end
				end
			end

			if not getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality() then
				v56:updateReasons(validateMeshVertColors(t1, true, p9))
			end

			local timestamp3 = tick()

			v56:updateReasons(validateIsSkinned(v60.instance, isServer, allowEditableInstances, p9))
			Analytics.recordScriptTime("validateIsSkinned", timestamp3, p9)

			if not getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning() then
				v56:updateReasons(validateSkinningTransfer(v60.instance, p9))
			end

			if not getFFlagUGCValidateMigrateMeshGeometry() then
				v56:updateReasons(validateMeshTriangleArea(t1, p9))
			end
		elseif v60.instance.ClassName == "WrapTarget" then
			assert(v60.fieldName == "CageMeshId")
			t1.fullName = t1.fullName .. "OuterCage"

			if not getFFlagUGCValidateMigrateCageUV() then
				v56:updateReasons(validateCageUVs(t1, v60.instance, p9))
			end

			if not getFFlagUGCValidateMigrateCageUV() then
				v56:updateReasons(validateCageUVTriangleArea(t1, p9))
			end

			if not getFFlagUGCValidateMigrateCageUV() then
				v56:updateReasons(validateCageUVValues(t1, v60.instance, p9))
			end

			if not getFFlagUGCValidateMigrateMeshGeometry() then
				v56:updateReasons(validateMeshTriangleArea(t1, p9))
			end
		end
	end

	return v56:getFinalResults()
end

return validateDescendantMeshMetrics
