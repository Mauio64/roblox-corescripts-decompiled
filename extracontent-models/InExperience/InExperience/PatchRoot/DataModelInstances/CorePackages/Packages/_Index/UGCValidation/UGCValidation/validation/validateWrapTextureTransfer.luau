local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)
local WrapTargetCageUVReferenceValues = require(ParentParent.WrapTargetCageUVReferenceValues)

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local getEditableMeshFromContext = require(ParentParent.util.getEditableMeshFromContext)

local function validateReferenceCageMeshContent(p1, p2) -- line: 17
	-- upvalues: getEditableMeshFromContext (copy), Analytics (copy), pcallDeferred (copy), UGCValidationService (copy), WrapTargetCageUVReferenceValues (copy)
	local ReferenceCageMeshContent = p1.ReferenceCageMeshContent
	local v13 = ReferenceCageMeshContent.Uri ~= nil and ReferenceCageMeshContent.Uri ~= ""
	local v14, v15 = getEditableMeshFromContext(p1, "ReferenceCageMeshContent", p2)

	if not v14 then
		local v16

		if not v13 then
			Analytics.reportFailure(Analytics.ErrorType.validateWrapTextureTransfer_NoCage, nil, p2)
			v16 = string.format("No ReferenceCageContent provided for %s", p1:GetFullName())
		else
			Analytics.reportFailure(Analytics.ErrorType.validateWrapTextureTransfer_FailedToLoadCage, nil, p2)
			v16 = string.format("Failed to load ReferenceCageContent for %s", p1:GetFullName())
		end

		return false, { v16 }
	end

	local v17, v18 = pcallDeferred(function() -- line: 41
		-- upvalues: UGCValidationService (copy), WrapTargetCageUVReferenceValues (copy), v15 (copy)
		return UGCValidationService:ValidateEditableMeshUVValuesInReference(WrapTargetCageUVReferenceValues.Head, v15)
	end, p2)

	if not v17 then
		local v19 = string.format("Failed to load UVs for '%s'. Make sure the UV map exists and try again.", p1:GetFullName())

		if p2.isServer then
			error(v19)
		end

		Analytics.reportFailure(Analytics.ErrorType.validateWrapTextureTransfer_FailedToLoadUV, nil, p2)

		return false, { v19 }
	end

	if not v18 then
		Analytics.reportFailure(Analytics.ErrorType.validateWrapTextureTransfer_InvalidUV, nil, p2)

		return false, { string.format("Found invalid UV value for cage of '%s'. You need to edit the UV map to fix this issue.", p1:GetFullName()) }
	end

	return true
end
local function validateWrapTextureTransfer(p3, p4) -- line: 75
	-- upvalues: Constants (copy), validateReferenceCageMeshContent (copy), Analytics (copy)
	local timestamp = tick()
	local MAKEUP_INFO = Constants.MAKEUP_INFO
	local WrapTextureTransfer = p3:FindFirstChildOfClass("WrapTextureTransfer")

	assert(WrapTextureTransfer ~= nil, string.format("WrapTextureTransfer child not found for %s", p3.Name))

	local v25, v26 = validateReferenceCageMeshContent(WrapTextureTransfer, p4)

	if not v25 then
		return false, v26
	end

	if not WrapTextureTransfer.UVMinBound:FuzzyEq(MAKEUP_INFO.WrapTextureTransferUVBounds.MinBound) then
		Analytics.reportFailure(Analytics.ErrorType.validateWrapTextureTransfer_InvalidMinBound, nil, p4)

		return false, { string.format("%s.UVMinBound [%s] does not match required UVMinBound of [%s]", WrapTextureTransfer:GetFullName(), tostring(WrapTextureTransfer.UVMinBound), (tostring(MAKEUP_INFO.WrapTextureTransferUVBounds.MinBound))) }
	end

	if not WrapTextureTransfer.UVMaxBound:FuzzyEq(MAKEUP_INFO.WrapTextureTransferUVBounds.MaxBound) then
		Analytics.reportFailure(Analytics.ErrorType.validateWrapTextureTransfer_InvalidMaxBound, nil, p4)

		return false, { string.format("%s.UVMaxBound [%s] does not match required UVMaxBound of [%s]", WrapTextureTransfer:GetFullName(), tostring(WrapTextureTransfer.UVMaxBound), (tostring(MAKEUP_INFO.WrapTextureTransferUVBounds.MaxBound))) }
	end

	Analytics.recordScriptTime(script.Name, timestamp, p4)

	return true
end

return validateWrapTextureTransfer
