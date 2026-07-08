local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local prettyPrintVector3 = require(ParentParent.util.prettyPrintVector3)
local BoundsCalculator = require(ParentParent.util.BoundsCalculator)
local BoundsDataUtils = require(ParentParent.util.BoundsDataUtils)
local MeshSpaceUtils = require(ParentParent.util.MeshSpaceUtils)
local getFStringUGCValidationAttachmentErrorLink = require(ParentParent.flags.getFStringUGCValidationAttachmentErrorLink)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local getAttachmentCFrameInPartSpace = require(ParentParent.util.getAttachmentCFrameInPartSpace)

local function validateInMeshSpace(p1, p2, p3, p4, p5) -- line: 21
	-- upvalues: getAttachmentCFrameInPartSpace (copy), BoundsDataUtils (copy), Analytics (copy), MeshSpaceUtils (copy), prettyPrintVector3 (copy), getFStringUGCValidationAttachmentErrorLink (copy)
	local v20 = p5.cframe * getAttachmentCFrameInPartSpace(p1)
	local v21 = BoundsDataUtils.calculateBoundsCenters(p5.boundsData)
	local v22 = BoundsDataUtils.calculateBoundsDimensions(p5.boundsData)

	if not v21 or not v22 then
		return false, { "Missing mesh data for " .. p2.Name }
	end

	local v23 = (v20.Position - v21) / (v22 / 2)
	local min = p3.min
	local max = p3.max

	for _, v27 in {
		"X",
		"Y",
		"Z"
	} do
		if v23[v27] < min[v27] or v23[v27] > max[v27] then
			Analytics.reportFailure(Analytics.ErrorType.validateBodyPartChildAttachmentBounds_InvalidAttachmentPosition, nil, p4)

			local v28 = MeshSpaceUtils.clampAttachmentToBounds(p1, p5, p3, 0.001)

			assert(v21 and v22, "meshCenterOpt and meshDimensionsOpt must be defined")

			local v29, v30 = MeshSpaceUtils.calculateAcceptableBoundsLocalSpace(p3, p5, v22, v21)
			local Position = v29.Position
			local v32, v33, v34 = v29.Rotation:ToOrientation()
			local vector3 = Vector3.new(math.deg(v32), math.deg(v33), (math.deg(v34)))

			return false, { string.format("Attachment (%s) in %s is placed at position [%s] that is outside the valid range. The closest valid position is [%s]. (the attachment must be within the oriented bounding box - Position: [%s], Orientation: [%s], Size: [%s]%s)", p1.Name, p2.Name, prettyPrintVector3(p1.CFrame.Position, 3), prettyPrintVector3(v28.Position, 3), prettyPrintVector3(Position, 3), prettyPrintVector3(vector3, 3), prettyPrintVector3(v30, 3), getFStringUGCValidationAttachmentErrorLink() == "" and "" or ". See " .. getFStringUGCValidationAttachmentErrorLink() .. " for further explanation") }
		end
	end

	return true
end
local function checkAll(p6, _: boolean?, p7, p8, p9) -- line: 88
	-- upvalues: FailureReasonsAccumulator (copy), R15plusUtils (copy), validateInMeshSpace (copy)
	local v41 = FailureReasonsAccumulator.new()
	local p7rigAttachmentToParentname = p6:FindFirstChild(p7.rigAttachmentToParent.name, R15plusUtils.checkFlagEnabledForAllowHrd())

	assert(p7rigAttachmentToParentname)
	v41:updateReasons(validateInMeshSpace(p7rigAttachmentToParentname, p6, p7.rigAttachmentToParent.bounds, p8, p9))

	for k, v in pairs(p7.otherAttachments) do
		local k2 = p6:FindFirstChild(k, R15plusUtils.checkFlagEnabledForAllowHrd())

		assert(k2)
		v41:updateReasons(validateInMeshSpace(k2, p6, v.bounds, p8, p9))
	end

	return v41:getFinalResults()
end
local function validateBodyPartChildAttachmentBounds(p10, p11) -- line: 131
	-- upvalues: Constants (copy), FailureReasonsAccumulator (copy), BoundsCalculator (copy), checkAll (copy), Analytics (copy)
	local timestamp = tick()
	local assetTypeEnum = p11.assetTypeEnum
	local isServer = p11.isServer

	assert(assetTypeEnum)

	local v51 = Constants.ASSET_TYPE_INFO[assetTypeEnum]

	assert(v51)

	local v52 = FailureReasonsAccumulator.new()
	local v53, v54, v55 = BoundsCalculator.calculateIndividualAssetPartsData(p10, p11)

	if not v53 then
		return v53, v54
	end

	if assetTypeEnum == Enum.AssetType.DynamicHead then
		local v56 = v55[p10.Name]

		v52:updateReasons(checkAll(p10, isServer, v51.subParts.Head, p11, v56))
	else
		for k, v in pairs(v51.subParts) do
			local k3 = p10:FindFirstChild(k)

			assert(k3)

			local v60 = v55[k]

			v52:updateReasons(checkAll(k3, isServer, v, p11, v60))
		end
	end

	Analytics.recordScriptTime(script.Name, timestamp, p11)

	return v52:getFinalResults()
end

return validateBodyPartChildAttachmentBounds
