local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local getExpectedPartSize = require(ParentParent.util.getExpectedPartSize)
local BoundsCalculator = require(ParentParent.util.BoundsCalculator)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local getAttachmentCFrameInPartSpace = require(ParentParent.util.getAttachmentCFrameInPartSpace)
local t1 = {
	[Enum.AssetType.Torso] = true,
	[Enum.AssetType.LeftArm] = true,
	[Enum.AssetType.RightArm] = true,
	[Enum.AssetType.RightLeg] = true,
	[Enum.AssetType.LeftLeg] = true
}
local t2 = {
	UpperTorso = true
}
local t3 = {
	[Enum.AssetType.LeftLeg] = true,
	[Enum.AssetType.RightLeg] = true
}

local function reportFailure_lowerAboveUpper(p1, p2, s1: string, p3) -- line: 40
	-- upvalues: Analytics (copy)
	Analytics.reportFailure(Analytics.ErrorType.validateBodyAttPosRelativeToParent_PartAboveParent, nil, p3)

	return false, { string.format("%s cannot extend above %s. You can adjust how the parts are put together by moving %s", p2.Name, p1.Name, s1) }
end
local function reportFailure_upperBelowLower(p4, p5, s2: string, p6) -- line: 63
	-- upvalues: Analytics (copy)
	Analytics.reportFailure(Analytics.ErrorType.validateBodyAttPosRelativeToParent_ParentBelowPart, nil, p6)

	return false, { string.format("%s cannot extend below %s. You can adjust how the parts are put together by moving %s", p4.Name, p5.Name, s2) }
end

local t5 = {
	validateSinglePartBasedOnBBoxes = function(p7, p8, t4: {[any]: any}, s3: string, p9) -- line: 86
		-- upvalues: FailureReasonsAccumulator (copy), reportFailure_lowerAboveUpper (copy), reportFailure_upperBelowLower (copy)
		local v28 = FailureReasonsAccumulator.new()
		local boundsData = t4[p7.Name].boundsData
		local boundsData2 = t4[p8.Name].boundsData

		if boundsData2.maxOverall and (boundsData.maxOverall and boundsData2.maxOverall.Y > boundsData.maxOverall.Y) then
			v28:updateReasons(reportFailure_lowerAboveUpper(p7, p8, s3, p9))
		end

		if boundsData.minOverall and boundsData2.minOverall and boundsData.minOverall.Y < boundsData2.minOverall.Y then
			v28:updateReasons(reportFailure_upperBelowLower(p7, p8, s3, p9))
		end

		return v28:getFinalResults()
	end,
	validateSinglePartBasedOnAttachmentYPos = function(p10, p11, s4: string, p12) -- line: 112
		-- upvalues: FailureReasonsAccumulator (copy), R15plusUtils (copy), getExpectedPartSize (copy), getAttachmentCFrameInPartSpace (copy), reportFailure_lowerAboveUpper (copy), reportFailure_upperBelowLower (copy)
		local v35 = FailureReasonsAccumulator.new()
		local s4_2 = p11:FindFirstChild(s4, R15plusUtils.checkFlagEnabledForAllowHrd())
		local s4_3 = p10:FindFirstChild(s4, R15plusUtils.checkFlagEnabledForAllowHrd())

		assert(s4_2)
		assert(s4_3)

		local v38 = getExpectedPartSize(p11, p12)
		local v39 = getExpectedPartSize(p10, p12)
		local Position = getAttachmentCFrameInPartSpace(s4_2).Position
		local Position2 = getAttachmentCFrameInPartSpace(s4_3).Position
		local Y = (v38 / 2 - Position).Y
		local Y2 = (v38 / 2 + Position).Y
		local Y3 = (v39 / 2 - Position2).Y
		local Y4 = (v39 / 2 + Position2).Y

		if Y3 < Y then
			v35:updateReasons(reportFailure_lowerAboveUpper(p10, p11, s4, p12))
		end

		if Y2 < Y4 then
			v35:updateReasons(reportFailure_upperBelowLower(p10, p11, s4, p12))
		end

		return v35:getFinalResults()
	end
}

function t5.runValidation(p13, p14) -- line: 150
	-- upvalues: Constants (copy), t1 (copy), BoundsCalculator (copy), FailureReasonsAccumulator (copy), t2 (copy), t5 (copy), t3 (copy), Analytics (copy)
	local timestamp = tick()
	local assetTypeEnum = p14.assetTypeEnum

	assert(assetTypeEnum)

	local v50 = Constants.ASSET_TYPE_INFO[assetTypeEnum]

	assert(v50)

	if not t1[assetTypeEnum] then
		return true
	end

	local v51, v52, v53 = BoundsCalculator.calculateIndividualAssetPartsData(p13, p14)

	if not v51 then
		return false, v52
	end

	assert(v53)

	local v54 = FailureReasonsAccumulator.new()

	for k, v in pairs(v50.subParts) do
		local v57 = Constants.BODYPART_TO_PARENT[k]

		if v57 ~= nil then
			local k2 = p13:FindFirstChild(k)
			local v59 = p13:FindFirstChild(v57)

			assert(k2)
			assert(v59)

			local v60 = v59

			if t2[k] then
				v60 = k2
				k2 = v59
			end

			local name = v.rigAttachmentToParent.name
			local v62, v63 = t5.validateSinglePartBasedOnBBoxes(v60, k2, v53, name, p14)

			v54:updateReasons(v62, v63)

			if v62 and t3[assetTypeEnum] then
				v54:updateReasons(t5.validateSinglePartBasedOnAttachmentYPos(v60, k2, name, p14))
			end
		end
	end

	Analytics.recordScriptTime(script.Name, timestamp, p14)

	return v54:getFinalResults()
end

return t5
