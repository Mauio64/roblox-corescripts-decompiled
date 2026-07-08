local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local ParseContentIds = require(ParentParent.util.ParseContentIds)
local pcallDeferred = require(ParentParent.util.pcallDeferred)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local getFFlagUGCValidateHSRMeshIds = require(ParentParent.flags.getFFlagUGCValidateHSRMeshIds)
local t1 = {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.LAYERED_CLOTHING
	},
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.consumerConfig,
		ValidationEnums.SharedDataMember.hsrAssets
	},
	fflag = getFFlagUGCValidateMigrateSchemaProperties,
	expectedFailures = {}
}

local function validateHSRStructure(t2: {[any]: any}, p1, p2) -- line: 29
	-- upvalues: ErrorSourceStrings (copy)
	if #t2 ~= 1 then
		p2:fail(ErrorSourceStrings.Keys.HSRAssetInvalidRoot, {
			InstancePath = p1:GetFullName()
		})

		return nil
	end

	local v14 = t2[1]

	if not v14:IsA("HiddenSurfaceRemovalAsset") then
		p2:fail(ErrorSourceStrings.Keys.HSRAssetInvalidRoot, {
			InstancePath = p1:GetFullName()
		})

		return nil
	end

	if #v14:GetDescendants() > 0 then
		p2:fail(ErrorSourceStrings.Keys.HSRAssetHasChildren, {
			InstancePath = p1:GetFullName()
		})

		return nil
	end

	return v14
end

function t1.run(p3, p4) -- line: 59
	-- upvalues: ValidationEnums (copy), getFFlagUGCValidateHSRMeshIds (copy), ErrorSourceStrings (copy), ParseContentIds (copy), validateHSRStructure (copy), pcallDeferred (copy), UGCValidationService (copy)
	if p4.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.IEC then
		return
	end

	local v17 = p4.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.Backend
	local v18 = getFFlagUGCValidateHSRMeshIds()
	local descendants = p4.rootInstance:GetDescendants()

	table.insert(descendants, p4.rootInstance)

	for _, v21 in descendants do
		if v21:IsA("WrapLayer") then
			local HSRAssetId = v21.HSRAssetId

			if not HSRAssetId or HSRAssetId == "" then
				if v17 then
					p3:fail(ErrorSourceStrings.Keys.HSRAssetIdRequired, {
						InstancePath = v21:GetFullName()
					})
				end
			else
				local v23 = ParseContentIds.tryGetAssetIdFromContentId(HSRAssetId)

				if not v23 then
					p3:fail(ErrorSourceStrings.Keys.HSRAssetIdInvalidUrl, {
						InstancePath = v21:GetFullName()
					})
				else
					local v24 = p4.hsrAssets[v23]

					if v24 then
						local v25 = validateHSRStructure(v24, v21, p3)

						if v25 and v18 then
							local v26, v27 = pcallDeferred(function() -- line: 109
								-- upvalues: UGCValidationService (copy), v21 (copy), v25 (copy)
								return UGCValidationService:ValidateHSRMeshIds(v21, v25)
							end, {})

							if not v26 then
								p3:fail(ErrorSourceStrings.Keys.HSRMeshIdValidationError, {
									InstancePath = v21:GetFullName()
								})
							elseif not v27 then
								p3:fail(ErrorSourceStrings.Keys.HSRMeshIdsMismatch, {
									InstancePath = v21:GetFullName()
								})
							end
						end
					end
				end
			end
		end
	end
end

return t1
