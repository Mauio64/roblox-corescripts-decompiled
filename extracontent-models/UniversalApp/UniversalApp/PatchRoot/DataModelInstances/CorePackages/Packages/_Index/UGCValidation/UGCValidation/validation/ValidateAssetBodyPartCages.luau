local ParentParent = script.Parent.Parent
local UGCValidationService = game:GetService("UGCValidationService")
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)
local util = ParentParent.util

require(util.Types)

local pcallDeferred = require(util.pcallDeferred)
local FailureReasonsAccumulator = require(util.FailureReasonsAccumulator)
local getExpectedPartSize = require(util.getExpectedPartSize)
local getMeshInfo = require(util.getMeshInfo)
local AssetCalculator = require(util.AssetCalculator)
local flags = ParentParent.flags
local GetFStringUGCValidationMaxCageDistance = require(flags.GetFStringUGCValidationMaxCageDistance)
local t1 = {}

local function validateInternal(p1, p2) -- line: 26
	-- upvalues: getMeshInfo (copy), Constants (copy), getExpectedPartSize (copy), pcallDeferred (copy), UGCValidationService (copy), Analytics (copy), GetFStringUGCValidationMaxCageDistance (copy)
	local v17, v18, v19 = getMeshInfo(p1, Constants.MESH_CONTENT_TYPE.RENDER_MESH, p2)
	local u20 = v19

	if not v17 then
		return false, v18
	end

	local WrapTarget = p1:FindFirstChildWhichIsA("WrapTarget")

	assert(WrapTarget, "Missing WrapTarget child for " .. p1.Name)

	local v22, v23, v24 = getMeshInfo(WrapTarget, Constants.MESH_CONTENT_TYPE.OUTER_CAGE, p2)
	local u25 = v24

	if not v22 then
		return false, v23
	end

	local v26 = getExpectedPartSize(p1, p2) / getExpectedPartSize(p1, p2, true)
	local v27, v28 = pcallDeferred(function() -- line: 50
		-- upvalues: UGCValidationService (copy), u25 (ref), u20 (ref), WrapTarget (copy), v26 (copy)
		return UGCValidationService:CalculateBodyPartMaxCageDistance(u25.editableMesh, u20.editableMesh, WrapTarget.CageOrigin, v26)
	end, p2)

	if not v27 then
		local v29 = `Failed to execute body part max cage distance check. Make sure { p1.Name }'s render mesh and its WrapTarget's cage mesh exist, and try again.`

		if p2.isServer ~= nil and p2.isServer then
			error(v29)
		end

		Analytics.reportFailure(Analytics.ErrorType.validateBodyPartCage_FailedToExecute, nil, p2)

		return false, { v29 }
	end

	if v28 > GetFStringUGCValidationMaxCageDistance.asNumber() then
		Analytics.reportFailure(Analytics.ErrorType.validateBodyPartCage_VertsAreTooFarInFrontOfRenderMesh, nil, p2)

		return false, { string.format("Cage mesh verts referenced in %s.%s.CageMeshId were found that are %.2f studs outside the %s render mesh. %s studs is the maximum. Reduce the size of your cage mesh.", p1.Name, WrapTarget.Name, v28, p1.Name, GetFStringUGCValidationMaxCageDistance.asString()) }
	end

	return true
end

function t1.validateSingleBodyPart(p3, p4) -- line: 93
	-- upvalues: Constants (copy), FailureReasonsAccumulator (copy), validateInternal (copy), Analytics (copy)
	local timestamp = tick()
	local v33 = Constants.ASSET_TYPE_INFO[p4.assetTypeEnum]
	local v34 = FailureReasonsAccumulator.new()

	if Enum.AssetType.DynamicHead == p4.assetTypeEnum then
		return validateInternal(p3, p4)
	end

	for k in pairs(v33.subParts) do
		local k2 = p3:FindFirstChild(k)

		assert(k2, "expected parts have been checked for existance before calling this function")
		v34:updateReasons(validateInternal(k2, p4))
	end

	Analytics.recordScriptTime(script.Name, timestamp, p4)

	return v34:getFinalResults()
end
function t1.validateFullBody(p5, p6) -- line: 116
	-- upvalues: AssetCalculator (copy), getMeshInfo (copy), Constants (copy), getExpectedPartSize (copy), pcallDeferred (copy), UGCValidationService (copy), Analytics (copy), GetFStringUGCValidationMaxCageDistance (copy)
	local timestamp = tick()
	local v40 = AssetCalculator.calculateAllTransformsForFullBody(p5)
	local t2 = {}

	for _, v43 in p5 do
		local v44, v45, v46 = getMeshInfo(v43, Constants.MESH_CONTENT_TYPE.RENDER_MESH, p6)

		if not v44 then
			return false, v45
		end

		local WrapTarget = v43:FindFirstChildWhichIsA("WrapTarget")

		assert(WrapTarget, "Missing WrapTarget child for " .. v43.Name)

		local v48, v49, v50 = getMeshInfo(WrapTarget, Constants.MESH_CONTENT_TYPE.OUTER_CAGE, p6)

		if not v48 then
			return false, v49
		end

		local v51 = getExpectedPartSize(v43, p6) / getExpectedPartSize(v43, p6, true)

		table.insert(t2, {
			renderMesh = v46.editableMesh,
			outerCage = v50.editableMesh,
			renderMeshTransform = v40[v43.Name],
			outerCageLocalTransform = WrapTarget.CageOrigin,
			scale = v51,
			name = v43.Name
		})
	end

	local v52, v53, v54 = pcallDeferred(function() -- line: 158
		-- upvalues: UGCValidationService (copy), t2 (copy)
		return UGCValidationService:CalculateBodyMaxCageDistance(t2)
	end, p6)

	Analytics.recordScriptTime(script.Name, timestamp, p6)

	if not v52 then
		if p6.isServer ~= nil and p6.isServer then
			error("Failed to execute body max cage distance check. Make sure all render meshes and their WrapTarget cage meshes exist, and try again.")
		end

		Analytics.reportFailure(Analytics.ErrorType.validateBodyPartCage_FailedToExecute, nil, p6)

		return false, { "Failed to execute body max cage distance check. Make sure all render meshes and their WrapTarget cage meshes exist, and try again." }
	end

	if v53 > GetFStringUGCValidationMaxCageDistance.asNumber() then
		Analytics.reportFailure(Analytics.ErrorType.validateBodyPartCage_VertsAreTooFarInFrontOfRenderMesh, nil, p6)

		return false, { string.format("A vertex was found on the %s's cage mesh that is %.2f studs away from the closest render mesh. %s studs is the maximum. Make the cage mesh more closely match the shape and size of the render mesh.", v54, v53, GetFStringUGCValidationMaxCageDistance.asString()) .. "[Read more](https://create.roblox.com/docs/art/validation-errors#bodyCageMaxSize)" }
	end

	return true
end

return t1
