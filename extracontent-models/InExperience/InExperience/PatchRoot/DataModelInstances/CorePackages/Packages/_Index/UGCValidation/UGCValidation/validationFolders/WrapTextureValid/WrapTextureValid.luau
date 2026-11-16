local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local WrapTargetCageUVReferenceValues = require(parent.WrapTargetCageUVReferenceValues)
local createEditableInstancesForContext = require(parent.util.createEditableInstancesForContext)

local getFFlagUGCValidationAllowFullVaas = require(parent.flags.getFFlagUGCValidationAllowFullVaas)
local getFFlagUGCValidateTransitionMakeupBounds = require(parent.flags.getFFlagUGCValidateTransitionMakeupBounds)

local v = { Publish = true, Backend = true, Internal = true, InExpServer = true }

local v2 = { InExpServer = true, InExpClient = true }

local vector2 = Vector2.new(3.28941798, 0.313124001)
local vector2_2 = Vector2.new(3.71058202, 0.734287024)

return {
	categories = { ValidationEnums.UploadCategory.MAKEUP },
	requiredData = { ValidationEnums.SharedDataMember.rootInstance, ValidationEnums.SharedDataMember.consumerConfig },
	expectedFailures = {},
	run = function(object, p)
		local rootInstance = p.rootInstance
		local wrapTextureTransfer = rootInstance:FindFirstChildOfClass("WrapTextureTransfer")

		if wrapTextureTransfer == nil then
			error(string.format("WrapTextureTransfer child not found for %s", rootInstance.Name))
		end

		local consumerConfig = p.consumerConfig
		local v3

		if getFFlagUGCValidationAllowFullVaas() and consumerConfig.isVaaS then
			v3 = consumerConfig.validationEnv == ValidationEnums.ValidationEnv.Backend
		else
			v3 = v[consumerConfig.source] == true
		end

		local v4 = v2[consumerConfig.source] == true

		object:setReportingInstance(wrapTextureTransfer)

		local referenceCageMeshContent = wrapTextureTransfer.ReferenceCageMeshContent
		local v5

		if referenceCageMeshContent.Uri == nil then
			v5 = false
		else
			v5 = referenceCageMeshContent.Uri ~= ""
		end

		local preloadedEditableMeshes = p.consumerConfig.preloadedEditableMeshes
		local editableInstanceInfo, v6 = createEditableInstancesForContext.getEditableInstanceInfo(
			referenceCageMeshContent,
			preloadedEditableMeshes,
			"EditableMesh",
			v4
		)

		if editableInstanceInfo and v6 and v6.instance then
			local instance = v6.instance

			local success, result = pcall(function()
				return UGCValidationService:ValidateEditableMeshUVValuesInReference(
					WrapTargetCageUVReferenceValues.Head,
					instance
				)
			end)

			if success then
				if not result then
					object:fail(ErrorSourceStrings.Keys.WrapTexture_InvalidUV, {
						instanceName = wrapTextureTransfer:GetFullName()
					})

					return
				end

				local MAKEUP_INFO = Constants.MAKEUP_INFO
				local v7

				if getFFlagUGCValidateTransitionMakeupBounds() then
					v7 = wrapTextureTransfer.UVMinBound:FuzzyEq(vector2)
						and wrapTextureTransfer.UVMaxBound:FuzzyEq(vector2_2)
				else
					v7 = false
				end

				if not v7 then
					if not wrapTextureTransfer.UVMinBound:FuzzyEq(MAKEUP_INFO.WrapTextureTransferUVBounds.MinBound) then
						object:fail(ErrorSourceStrings.Keys.WrapTexture_InvalidMinBound, {
							instanceName = wrapTextureTransfer:GetFullName(),
							actual = tostring(wrapTextureTransfer.UVMinBound),
							expected = tostring(MAKEUP_INFO.WrapTextureTransferUVBounds.MinBound)
						})

						return
					end

					if not wrapTextureTransfer.UVMaxBound:FuzzyEq(MAKEUP_INFO.WrapTextureTransferUVBounds.MaxBound) then
						object:fail(ErrorSourceStrings.Keys.WrapTexture_InvalidMaxBound, {
							instanceName = wrapTextureTransfer:GetFullName(),
							actual = tostring(wrapTextureTransfer.UVMaxBound),
							expected = tostring(MAKEUP_INFO.WrapTextureTransferUVBounds.MaxBound)
						})

						if getFFlagUGCValidateTransitionMakeupBounds() then
							return
						end
					end
				end

				if getFFlagUGCValidateTransitionMakeupBounds() and v3 then
					if v7 then
						object:setTelemetryContext("makeupBounds=Old")
					else
						object:setTelemetryContext("makeupBounds=New")
					end
				end
			else
				if v3 then
					object:forceError(string.format(
						"Failed to load UVs for '%s'. Make sure the UV map exists and try again.",
						wrapTextureTransfer:GetFullName()
					))
				end

				object:fail(ErrorSourceStrings.Keys.WrapTexture_FailedToLoadUV, {
					instanceName = wrapTextureTransfer:GetFullName()
				})
			end
		else
			if not v5 then
				object:fail(ErrorSourceStrings.Keys.WrapTexture_NoCage, {
					instanceName = wrapTextureTransfer:GetFullName()
				})
				return
			end

			if v3 then
				object:forceError(string.format(
					"Failed to load ReferenceCageContent for %s",
					wrapTextureTransfer:GetFullName()
				))
			end

			object:fail(ErrorSourceStrings.Keys.WrapTexture_FailedToLoadCage, {
				instanceName = wrapTextureTransfer:GetFullName()
			})
		end
	end
}
