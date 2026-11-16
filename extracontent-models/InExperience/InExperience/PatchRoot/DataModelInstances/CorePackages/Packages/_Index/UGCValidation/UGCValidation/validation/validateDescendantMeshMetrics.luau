local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent

local Analytics = require(parent.Analytics)
local Constants = require(parent.Constants)
require(parent.util.Types)
local validateSkinningTransfer = require(parent.validation.validateSkinningTransfer)

local FailureReasonsAccumulator = require(parent.util.FailureReasonsAccumulator)
local ParseContentIds = require(parent.util.ParseContentIds)
local getMeshMinMax = require(parent.util.getMeshMinMax)
local getEditableMeshFromContext = require(parent.util.getEditableMeshFromContext)

local getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning = require(parent.flags.getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning)

local function validateIsSkinned(instance, isServer: boolean?, allowEditableInstances: boolean?, data)
	local attribute = instance:GetAttribute(Constants.AlternateMeshIdAttributeName)

	if not instance.HasSkinnedMesh and (attribute == nil or attribute == "" or not allowEditableInstances) then
		Analytics.reportFailure(Analytics.ErrorType.validateDescendantMeshMetrics_NoSkinningInfo, nil, data)

		return false, { `Missing skinning data for {instance.Name}.MeshId. You need to skin your model.` }
	end

	local success, result = pcall(function()
		local editableMeshFromContext, v = getEditableMeshFromContext(instance, "MeshId", data)

		if not editableMeshFromContext then
			error("Failed to retrieve MeshContent")
		end

		return UGCValidationService:ValidateSkinnedEditableMesh(v)
	end)

	if success then
		if result then
			return true
		end

		local formatted = `Detected mismatch between model and skinned data for {instance.Name}. You need to re-skin your model to fix this issue.`

		if isServer then
			error(formatted)
		end

		Analytics.reportFailure(Analytics.ErrorType.validateDescendantMeshMetrics_HasSkinnedMeshMismatch, nil, data)

		return false, { formatted }
	end

	if isServer then
		error("Failed to retrieve mesh data to validate skinned mesh")
	end

	Analytics.reportFailure(Analytics.ErrorType.validateDescendantMeshMetrics_FailedToLoadMesh, nil, data)

	return false, { "Failed to retrieve mesh data to validate skinned mesh" }
end

local function validateMeshIsAtOrigin(p, vector3: Vector3?, vector3_2: Vector3?, data)
	if (vector3 + (vector3_2 - vector3) / 2).Magnitude > 0.001 then
		Analytics.reportFailure(Analytics.ErrorType.validateDescendantMeshMetrics_TooFarFromOrigin, nil, data)

		return
			false,
			{ string.format(
					"Bounds for the mesh '%s' are not centered at the origin. The max allowed distance is '%f'",
					p.fullName,
					0.001
				) }
	end

	return true
end

local function validateDescendantMeshMetrics(p, data)
	local isServer = data.isServer

	assert(data.assetTypeEnum ~= nil, "assetTypeEnum required in validationContext for validateDescendantMeshMetrics")

	local allowEditableInstances = data.allowEditableInstances

	local v = FailureReasonsAccumulator.new()

	local parsed = ParseContentIds.parse(p, Constants.MESH_CONTENT_ID_FIELDS, data)

	for _, v2 in parsed do
		local v3 = {
			fullName = v2.instance:GetFullName(),
			fieldName = v2.fieldName,
			contentId = v2.instance[v2.fieldName],
			context = v2.instance.Name
		}

		local editableMeshFromContext, editableMesh = getEditableMeshFromContext(v2.instance, v2.fieldName, data)

		if not editableMeshFromContext then
			return
				false,
				{ string.format(
						"Failed to load mesh for '%s'. Make sure mesh exists and try again.",
						v2.instance.Name
					) }
		end

		v3.editableMesh = editableMesh

		if v2.instance.ClassName == "MeshPart" then
			assert(v2.fieldName == "MeshId")

			local meshMinMax, v4, v5, v6 = getMeshMinMax(v3, data)

			if not meshMinMax then
				v:updateReasons(false, v4)
			end

			if meshMinMax then
				local now = tick()
				v:updateReasons(validateMeshIsAtOrigin(v3, v5, v6, data))

				Analytics.recordScriptTime("validateMeshIsAtOrigin", now, data)
			end

			local now = tick()
			v:updateReasons(validateIsSkinned(v2.instance, isServer, allowEditableInstances, data))

			Analytics.recordScriptTime("validateIsSkinned", now, data)

			if not getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning() then
				v:updateReasons(validateSkinningTransfer(v2.instance, data))
			end
		elseif v2.instance.ClassName == "WrapTarget" then
			assert(v2.fieldName == "CageMeshId")
			v3.fullName ..= "OuterCage"
		end
	end

	return v:getFinalResults()
end

return validateDescendantMeshMetrics
