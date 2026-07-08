local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local validateFacsJointBounds = require(ParentParent.validation.validateFacsJointBounds)
local getEngineFeatureEngineUGCValidateFACSJointTransformsWithinBounds = require(ParentParent.flags.getEngineFeatureEngineUGCValidateFACSJointTransformsWithinBounds)
local getFFlagUGCValidateMigrateDynamicHeadData = require(ParentParent.flags.getFFlagUGCValidateMigrateDynamicHeadData)
local v8 = game:DefineFastInt("UGCValidateFacialBoundsScale", 120) / 100
local v9 = game:DefineFastInt("UGCValidateFacialExpressivenessThreshold", 10) / 100
local v10 = game:DefineFastInt("UGCValidateFacialExpressivenessMinVertDelta", 2) / 100
local getExpectedPartSize = require(ParentParent.util.getExpectedPartSize)

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local getEditableMeshFromContext = require(ParentParent.util.getEditableMeshFromContext)
local getEngineFeatureEngineUGCValidateMinMaxMeshSizeAcrossAllFacs = require(ParentParent.flags.getEngineFeatureEngineUGCValidateMinMaxMeshSizeAcrossAllFacs)
local t1 = {
	"LeftEyeClosed",
	"EyesLookDown",
	"RightEyeClosed",
	"JawDrop",
	"Pucker",
	"LeftLipCornerPuller",
	"RightLipCornerPuller",
	"ChinRaiser",
	"ChinRaiserUpperLip",
	"LeftCheekRaiser",
	"RightCheekRaiser",
	"LeftInnerBrowRaiser",
	"RightInnerBrowRaiser",
	"LeftLipCornerDown",
	"RightLipCornerDown",
	"LeftLowerLipDepressor",
	"RightLowerLipDepressor"
}

local function downloadFailure(b1: boolean?, s1: string?, p1) -- line: 52
	-- upvalues: Analytics (copy)
	local v23 = string.format("Failed to load model for dynamic head '%s'. Make sure model exists and try again.", s1)

	if b1 then
		error(v23)
	end

	Analytics.reportFailure(Analytics.ErrorType.validateDynamicHeadMeshPartFormat_FailedToLoadMesh, nil, p1)

	return false, { v23 }
end
local function validateFacialBounds(p2, p3) -- line: 79
	-- upvalues: pcallDeferred (copy), getExpectedPartSize (copy), getEditableMeshFromContext (copy), UGCValidationService (copy), v8 (copy)
	local isServer = p3.isServer
	local v27, v28 = pcallDeferred(function() -- line: 85
		-- upvalues: getExpectedPartSize (copy), p2 (copy), p3 (copy), getEditableMeshFromContext (copy), UGCValidationService (copy), v8 (copy)
		local v48 = getExpectedPartSize(p2, p3)
		local v49, v50 = getEditableMeshFromContext(p2, "MeshId", p3)

		if not v49 then
			error("Failed to retrieve MeshContent")
		end

		return UGCValidationService:ValidateEditableMeshFacialBounds(v50, v8, v48)
	end, p3)

	if not v27 then
		local v29 = string.format("Failed to load mesh data for '%s'. Make sure the mesh exists and try again.", p2:GetFullName())

		if isServer ~= nil and isServer then
			error(v29)
		end

		return false, { v29 }
	end

	if not v28 then
		return false, { string.format("DynamicHead (%s) when emoting surpasses the expected bounding box", p2:GetFullName()) }
	end

	return true
end
local function validateFacialExpressiveness(p4, p5) -- line: 119
	-- upvalues: pcallDeferred (copy), getExpectedPartSize (copy), getEditableMeshFromContext (copy), UGCValidationService (copy), v10 (copy), v9 (copy)
	local isServer = p5.isServer
	local v33, v34 = pcallDeferred(function() -- line: 125
		-- upvalues: getExpectedPartSize (copy), p4 (copy), p5 (copy), getEditableMeshFromContext (copy), UGCValidationService (copy), v10 (copy)
		local v51 = getExpectedPartSize(p4, p5)
		local v52, v53 = getEditableMeshFromContext(p4, "MeshId", p5)

		if not v52 then
			error("Failed to retrieve MeshContent")
		end

		return UGCValidationService:ValidateEditableMeshFacialExpressiveness(v53, v10, v51)
	end, p5)

	if not v33 then
		local v35 = string.format("Failed to load mesh data for '%s'. Make sure the mesh exists and try again.", p4:GetFullName())

		if isServer ~= nil and isServer then
			error(v35)
		end

		return false, { v35 }
	end

	if v34 < v9 then
		return false, { string.format("DynamicHead (%s) did not pass threshold (%f < %f) for percent change when emoting", p4:GetFullName(), v34, v9) }
	end

	return true
end
local function validateDynamicHeadData(p6, p7) -- line: 161
	-- upvalues: getFFlagUGCValidateMigrateDynamicHeadData (copy), getEditableMeshFromContext (copy), UGCValidationService (copy), downloadFailure (copy), Analytics (copy), FailureReasonsAccumulator (copy), t1 (copy), validateFacialExpressiveness (copy), getEngineFeatureEngineUGCValidateMinMaxMeshSizeAcrossAllFacs (copy), validateFacialBounds (copy), getEngineFeatureEngineUGCValidateFACSJointTransformsWithinBounds (copy), validateFacsJointBounds (copy)
	local timestamp = tick()
	local isServer = p7.isServer

	if not getFFlagUGCValidateMigrateDynamicHeadData() then
		local ok, result = pcall(function() -- line: 170
			-- upvalues: getEditableMeshFromContext (copy), p6 (copy), p7 (copy), UGCValidationService (copy)
			local v54, v55 = getEditableMeshFromContext(p6, "MeshId", p7)

			if not v54 then
				error("Failed to retrieve MeshContent")
			end

			return UGCValidationService:ValidateDynamicHeadEditableMesh(v55)
		end)

		if not ok then
			return downloadFailure(isServer, p6.Name, p7)
		end

		if not result then
			Analytics.reportFailure(Analytics.ErrorType.validateDynamicHeadMeshPartFormat_ValidateDynamicHeadMesh, nil, p7)

			return false, { string.format("Failed validation for dynamic head '%s' due to missing FACS information. You need to provide FACS controls for at least 17 poses (see documentation).", p6.Name) }
		end
	end

	local v42 = FailureReasonsAccumulator.new()

	if not getFFlagUGCValidateMigrateDynamicHeadData() then
		local ok, result, v45 = pcall(function() -- line: 203
			-- upvalues: getEditableMeshFromContext (copy), p6 (copy), p7 (copy), UGCValidationService (copy), t1 (copy)
			local v56, v57 = getEditableMeshFromContext(p6, "MeshId", p7)

			if not v56 then
				error("Failed to retrieve MeshContent")
			end

			return UGCValidationService:GetDynamicHeadEditableMeshInactiveControls(v57, t1)
		end)

		if not ok then
			if string.find(result, "Download Error") == 1 then
				return downloadFailure(isServer, p6.Name, p7)
			end

			assert(false, result)
		end

		local v46 = #result == 0
		local v47 = #v45 == 0

		if not v46 or not v47 then
			Analytics.reportFailure(Analytics.ErrorType.validateDynamicHeadMeshPartFormat_ValidateDynamicHeadMeshControls, nil, p7)
			v42:updateReasons(v46, { `{ p6.Name }.MeshId ({ p6.MeshId }) is missing FACS controls: { table.concat(result, ", ") }` })
			v42:updateReasons(v47, { `{ p6.Name }.MeshId ({ p6.MeshId }) has inactive FACS controls: { table.concat(v45, ", ") }` })
		end
	end

	if not getFFlagUGCValidateMigrateDynamicHeadData() then
		v42:updateReasons(validateFacialExpressiveness(p6, p7))
	end

	if not getEngineFeatureEngineUGCValidateMinMaxMeshSizeAcrossAllFacs() then
		v42:updateReasons(validateFacialBounds(p6, p7))
	end

	if not getFFlagUGCValidateMigrateDynamicHeadData() and getEngineFeatureEngineUGCValidateFACSJointTransformsWithinBounds() then
		v42:updateReasons(validateFacsJointBounds(p6, p7))
	end

	Analytics.recordScriptTime(script.Name, timestamp, p7)

	return v42:getFinalResults()
end

return validateDynamicHeadData
