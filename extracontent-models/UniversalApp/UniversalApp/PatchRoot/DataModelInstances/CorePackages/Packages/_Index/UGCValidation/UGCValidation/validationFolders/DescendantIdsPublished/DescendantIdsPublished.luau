local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local ParseContentIds = require(parent.util.ParseContentIds)
require(parent.util.Types)
local UnpublishedDependencies = require(parent.util.UnpublishedDependencies)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)

local getFFlagUGCValidateDescendantIdsPublished = require(parent.flags.getFFlagUGCValidateDescendantIdsPublished)

local getFFlagUGCValidateDescendantIdsPublishedShadow = require(parent.flags.getFFlagUGCValidateDescendantIdsPublishedShadow)

local v = { AnimationId = true, TexturePack = true, HSRAssetId = true }

local v2 = { MODERATION_STATE_REJECTED = true, Rejected = true }

return {
	["categories"] = Constants.AllUploadCategories,
	requiredData = { ValidationEnums.SharedDataMember.consumerConfig, ValidationEnums.SharedDataMember.contentIds },
	fflag = getFFlagUGCValidateDescendantIdsPublished,
	shadowFlag = getFFlagUGCValidateDescendantIdsPublishedShadow,
	run = function(object, p)
		if p.consumerConfig.validationEnv ~= ValidationEnums.ValidationEnv.Backend then
			return
		end

		for _, v3 in ParseContentIds.getDistinctReferences(p.contentIds) do
			local entry = v3.entry

			if v[entry.fieldName] then
				continue
			end

			local success, result = pcall(UnpublishedDependencies.getVersion, v3.assetId, entry.version)

			if not success then
				object:fetchError(`Failed to read asset {v3.key}: {result}`)
			end

			if result.published then
				continue
			end

			local fullName = entry.instance:GetFullName()
			local moderationState

			if result.moderationResult then
				moderationState = result.moderationResult.moderationState
			end

			if moderationState == nil or not v2[moderationState] then
				object:fail(
					ErrorSourceStrings.Keys.DescendantIdNotPublished,
					{ AssetId = v3.key, InstanceFullName = fullName, FieldName = entry.fieldName },
					entry.instance
				)
			else
				object:fail(
					ErrorSourceStrings.Keys.DescendantIdNotApproved,
					{
						ModerationMessages = `{fullName}.{entry.fieldName} ( {v3.key} )`
					},
					entry.instance
				)
			end
		end
	end
}
