local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local WrapTargetCageUVReferenceValues = require(ParentParent.WrapTargetCageUVReferenceValues)
local createEditableInstancesForContext = require(ParentParent.util.createEditableInstancesForContext)
local getFFlagUGCValidateMigrateWrapAndMakeup = require(ParentParent.flags.getFFlagUGCValidateMigrateWrapAndMakeup)
local t1 = {
	Publish = true,
	Backend = true,
	Internal = true,
	InExpServer = true
}
local t2 = {
	InExpServer = true,
	InExpClient = true
}

return {
	fflag = getFFlagUGCValidateMigrateWrapAndMakeup,
	categories = { ValidationEnums.UploadCategory.MAKEUP },
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.consumerConfig
	},
	expectedFailures = {},
	run = function(p1, p2) -- line: 42
		-- upvalues: t1 (copy), t2 (copy), createEditableInstancesForContext (copy), ErrorSourceStrings (copy), UGCValidationService (copy), WrapTargetCageUVReferenceValues (copy), Constants (copy)
		local rootInstance = p2.rootInstance
		local WrapTextureTransfer = rootInstance:FindFirstChildOfClass("WrapTextureTransfer")

		if WrapTextureTransfer == nil then
			error(string.format("WrapTextureTransfer child not found for %s", rootInstance.Name))
		end

		local source = p2.consumerConfig.source
		local v16 = t1[source] == true
		local v17 = t2[source] == true

		p1:setReportingInstance(WrapTextureTransfer)

		local ReferenceCageMeshContent = WrapTextureTransfer.ReferenceCageMeshContent
		local v19 = ReferenceCageMeshContent.Uri ~= nil and ReferenceCageMeshContent.Uri ~= ""
		local preloadedEditableMeshes = p2.consumerConfig.preloadedEditableMeshes
		local v21, v22 = createEditableInstancesForContext.getEditableInstanceInfo(ReferenceCageMeshContent, preloadedEditableMeshes, "EditableMesh", v17)

		if not v21 or not v22 or not v22.instance then
			if not v19 then
				p1:fail(ErrorSourceStrings.Keys.WrapTexture_NoCage, {
					instanceName = WrapTextureTransfer:GetFullName()
				})

				return
			end

			if v16 then
				p1:forceError(string.format("Failed to load ReferenceCageContent for %s", WrapTextureTransfer:GetFullName()))
			end

			p1:fail(ErrorSourceStrings.Keys.WrapTexture_FailedToLoadCage, {
				instanceName = WrapTextureTransfer:GetFullName()
			})

			return
		end

		local instance = v22.instance
		local ok, result = pcall(function() -- line: 95
			-- upvalues: UGCValidationService (copy), WrapTargetCageUVReferenceValues (copy), instance (copy)
			return UGCValidationService:ValidateEditableMeshUVValuesInReference(WrapTargetCageUVReferenceValues.Head, instance)
		end)

		if not ok then
			if v16 then
				p1:forceError(string.format("Failed to load UVs for '%s'. Make sure the UV map exists and try again.", WrapTextureTransfer:GetFullName()))
			end

			p1:fail(ErrorSourceStrings.Keys.WrapTexture_FailedToLoadUV, {
				instanceName = WrapTextureTransfer:GetFullName()
			})

			return
		end

		if not result then
			p1:fail(ErrorSourceStrings.Keys.WrapTexture_InvalidUV, {
				instanceName = WrapTextureTransfer:GetFullName()
			})

			return
		end

		local MAKEUP_INFO = Constants.MAKEUP_INFO

		if not WrapTextureTransfer.UVMinBound:FuzzyEq(MAKEUP_INFO.WrapTextureTransferUVBounds.MinBound) then
			p1:fail(ErrorSourceStrings.Keys.WrapTexture_InvalidMinBound, {
				instanceName = WrapTextureTransfer:GetFullName(),
				actual = tostring(WrapTextureTransfer.UVMinBound),
				expected = tostring(MAKEUP_INFO.WrapTextureTransferUVBounds.MinBound)
			})

			return
		end

		if not WrapTextureTransfer.UVMaxBound:FuzzyEq(MAKEUP_INFO.WrapTextureTransferUVBounds.MaxBound) then
			p1:fail(ErrorSourceStrings.Keys.WrapTexture_InvalidMaxBound, {
				instanceName = WrapTextureTransfer:GetFullName(),
				actual = tostring(WrapTextureTransfer.UVMaxBound),
				expected = tostring(MAKEUP_INFO.WrapTextureTransferUVBounds.MaxBound)
			})
		end
	end
}
