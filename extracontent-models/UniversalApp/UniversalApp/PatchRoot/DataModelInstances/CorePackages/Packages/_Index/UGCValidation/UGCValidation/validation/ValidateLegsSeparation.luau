local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)
local flags = ParentParent.flags
local getFFlagUGCValidateLegFullBodySeparation = require(flags.getFFlagUGCValidateLegFullBodySeparation)
local GetFStringUGCValidateLegHipAttachmentRange = require(flags.GetFStringUGCValidateLegHipAttachmentRange)
local GetFStringUGCValidateAllowedLegOverlapMultiplier = require(flags.GetFStringUGCValidateAllowedLegOverlapMultiplier)
local util = ParentParent.util

require(util.Types)

local FailureReasonsAccumulator = require(util.FailureReasonsAccumulator)
local BoundsDataUtils = require(util.BoundsDataUtils)
local BoundsCalculator = require(util.BoundsCalculator)
local t1 = {}

local function validateAttachmentPosition(p1, p2) -- line: 23
	-- upvalues: GetFStringUGCValidateLegHipAttachmentRange (copy)
	if p2 == Enum.AssetType.RightLeg then
		local v18 = p1.RightUpperLeg.Size.X * GetFStringUGCValidateLegHipAttachmentRange.asNumber()

		if v18 < p1.RightUpperLeg.RightHipRigAttachment.CFrame.Position.X then
			return false, { string.format("RightUpperLeg.RightHipRigAttachment.CFrame.Position.X is %.2f and cannot be greater than %.2f. Please fix the Attachment.", p1.RightUpperLeg.RightHipRigAttachment.CFrame.Position.X, v18) }
		end
	elseif p2 == Enum.AssetType.LeftLeg then
		local v19 = -p1.LeftUpperLeg.Size.X * GetFStringUGCValidateLegHipAttachmentRange.asNumber()

		if v19 > p1.LeftUpperLeg.LeftHipRigAttachment.CFrame.Position.X then
			return false, { string.format("LeftUpperLeg.LeftHipRigAttachment.CFrame.Position.X is %.2f and cannot be less than %.2f. Please fix the Attachment.", p1.LeftUpperLeg.LeftHipRigAttachment.CFrame.Position.X, v19) }
		end
	end

	return true
end

function t1.validateAsset(p3, p4) -- line: 54
	-- upvalues: FailureReasonsAccumulator (copy), validateAttachmentPosition (copy), Analytics (copy)
	local timestamp = tick()
	local assetTypeEnum = p4.assetTypeEnum

	assert(assetTypeEnum)

	if assetTypeEnum ~= Enum.AssetType.RightLeg and assetTypeEnum ~= Enum.AssetType.LeftLeg then
		return true
	end

	local v24 = FailureReasonsAccumulator.new()

	v24:updateReasons(validateAttachmentPosition(p3, assetTypeEnum))

	if not v24:getFinalResults() then
		Analytics.reportFailure(Analytics.ErrorType.validateLegsSeparation_InvalidAttachmentPosition, nil, p4)
	end

	Analytics.recordScriptTime(script.Name, timestamp, p4)

	return v24:getFinalResults()
end

local function calculateBounds(t2: {[any]: any}, t3: {[any]: any}) -- line: 83
	-- upvalues: BoundsDataUtils (copy)
	local t4 = {}

	for _, v29 in t3 do
		t4 = BoundsDataUtils.combineBounds(t4, t2[v29].boundsData)
	end

	return t4
end
local function validateFullBodyInternal(p5, p6) -- line: 91
	-- upvalues: BoundsCalculator (copy), calculateBounds (copy), Constants (copy), BoundsDataUtils (copy), GetFStringUGCValidateAllowedLegOverlapMultiplier (copy)
	local v32, v33, v34 = BoundsCalculator.calculateIndividualFullBodyPartsData(p5, p6, nil, false)

	if not v32 then
		return false, v33
	end

	local v35 = calculateBounds(v34, {
		Constants.NAMED_R15_BODY_PARTS.LeftUpperLeg,
		Constants.NAMED_R15_BODY_PARTS.LeftLowerLeg,
		Constants.NAMED_R15_BODY_PARTS.LeftFoot
	})
	local v36 = BoundsDataUtils.calculateBoundsCenters(v35)
	local v37 = BoundsDataUtils.calculateBoundsDimensions(v35)
	local v38 = calculateBounds(v34, {
		Constants.NAMED_R15_BODY_PARTS.RightUpperLeg,
		Constants.NAMED_R15_BODY_PARTS.RightLowerLeg,
		Constants.NAMED_R15_BODY_PARTS.RightFoot
	})
	local v39 = BoundsDataUtils.calculateBoundsCenters(v38)
	local v40 = BoundsDataUtils.calculateBoundsDimensions(v38)

	if not v36 or not v37 or not v39 or not v40 then
		return true
	end

	local v41 = v39.X - v36.X
	local v42 = (v37.X + v40.X) * 0.5 - v41

	if v42 <= 0 then
		return true
	end

	local v43 = v37.X * GetFStringUGCValidateAllowedLegOverlapMultiplier.asNumber()
	local v44 = v40.X * GetFStringUGCValidateAllowedLegOverlapMultiplier.asNumber()

	if v43 < v42 or v44 < v42 then
		return false, { string.format("The legs overlap by %.2f studs on the x axis. %.2f is the left leg maximum. %.2f is the right leg maximum. Please adjust the legs to reduce overlap.", v42, v43, v44) }
	end

	return true
end

function t1.validateFullBody(p7, p8) -- line: 144
	-- upvalues: getFFlagUGCValidateLegFullBodySeparation (copy), FailureReasonsAccumulator (copy), validateFullBodyInternal (copy), Analytics (copy)
	if not getFFlagUGCValidateLegFullBodySeparation() then
		return true
	end

	local timestamp = tick()
	local v48 = FailureReasonsAccumulator.new()

	v48:updateReasons(validateFullBodyInternal(p7, p8))

	if not v48:getFinalResults() then
		Analytics.reportFailure(Analytics.ErrorType.validateLegsSeparation_LegsOverlap, nil, p8)
	end

	Analytics.recordScriptTime(script.Name, timestamp, p8)

	return v48:getFinalResults()
end

return t1
