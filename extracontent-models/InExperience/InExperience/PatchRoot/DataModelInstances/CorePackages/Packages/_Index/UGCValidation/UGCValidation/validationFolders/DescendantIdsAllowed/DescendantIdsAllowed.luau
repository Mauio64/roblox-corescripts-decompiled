local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local RunService = game:GetService("RunService")

local canPublishAssets = require(parent.util.canPublishAssets)
local getAssetCreationDetails = require(parent.util.getAssetCreationDetails)
local getAssetCreationDetailsRCC = require(parent.util.getAssetCreationDetailsRCC)

local getFFlagUGCValidateForwardIECRestrictedUserIds = require(parent.flags.getFFlagUGCValidateForwardIECRestrictedUserIds)

local getFFlagUGCValidateBackendInExperienceViaCanPublish = require(parent.flags.getFFlagUGCValidateBackendInExperienceViaCanPublish)
local getFFlagUGCValidateMakeupCategoryParity = require(parent.flags.getFFlagUGCValidateMakeupCategoryParity)

local v = { MODERATION_STATE_REVIEWING = true, Reviewing = true }
local v2 = { MODERATION_STATE_APPROVED = true, Approved = true }

local function collectContentIdsArray(items) -- 1 equivalent call inferred from this helper
	local contentIdsArray = {}

	for k, _ in items do
		table.insert(contentIdsArray, k)
	end

	return contentIdsArray
end

local function runStudio(object, rootInstance, contentIds)
	local contentIdsArray = collectContentIdsArray(contentIds) -- inferred equivalent call

	if #contentIdsArray == 0 then
		return
	end

	local assetCreationDetails, v3 = getAssetCreationDetails(contentIdsArray)

	if not assetCreationDetails or #v3 ~= #contentIdsArray then
		object:fail(ErrorSourceStrings.Keys.DescendantIdFetchFailed, {
			InstanceFullName = rootInstance:GetFullName()
		})

		return
	end

	for _, v4 in v3 do
		if not (v4.status == Constants.ASSET_STATUS.UNKNOWN or v4.status == Constants.ASSET_STATUS.REVIEW_PENDING or v4.status == Constants.ASSET_STATUS.MODERATED) then
			continue
		end

		local assetId = tostring(v4.assetId)
		local v5 = contentIds[assetId]

		if v5 then
			assetId = string.format("%s.%s ( %s )", v5[1].instance:GetFullName(), v5[1].fieldName, assetId)
		end

		object:fail(ErrorSourceStrings.Keys.DescendantIdNotApproved, {
			ModerationMessages = assetId
		})
	end
end

local function buildOwnerLookup(restrictedUserIds) -- 1 equivalent call inferred from this helper
	local idSet = {}

	for _, item in restrictedUserIds do
		idSet[tonumber(item.id)] = true
	end

	return idSet
end

local function runBackend(object, contentIds, backendConfigs)
	local restrictedUserIds = backendConfigs.restrictedUserIds

	if not restrictedUserIds or #restrictedUserIds == 0 then
		return
	end

	local ownerLookup = buildOwnerLookup(restrictedUserIds) -- inferred equivalent call

	for k, item in contentIds do
		local v3 = item[1]
		local assetCreationDetailsRCC, v4 = getAssetCreationDetailsRCC(k)

		if not assetCreationDetailsRCC then
			object:forceError("Failed to load asset")
		end

		local creator = v4.creationContext.creator
		local v5

		if creator.userId then
			v5 = creator.userId
		else
			v5 = creator.groupId
		end

		if not ownerLookup[tonumber(v5)] then
			object:fail(ErrorSourceStrings.Keys.DescendantIdNotOwned, {
				AssetId = k,
				InstanceFullName = v3.instance:GetFullName(),
				FieldName = v3.fieldName
			})
		end

		local moderationState = v4.moderationResult.moderationState

		if v[moderationState] then
			object:forceError("Failed to load asset " .. v3.instance:GetFullName() .. "." .. v3.fieldName .. " ( " .. k .. " ) that is still going through the review process. Please, wait for a notification of completion from the review process and try again.")
		end

		if not v2[moderationState] then
			object:fail(ErrorSourceStrings.Keys.DescendantIdNotApproved, {
				ModerationMessages = string.format("%s.%s ( %s )", v3.instance:GetFullName(), v3.fieldName, k)
			})
		end
	end
end

local function runCanPublishOwnershipCheck(object, rootInstance, contentIds, data)
	local v3 = getFFlagUGCValidateBackendInExperienceViaCanPublish()

	if v3 then
		if data.token == nil then
			v3 = data.universeId ~= nil
		else
			v3 = false
		end
	end

	if not (data.token or v3) or getFFlagUGCValidateForwardIECRestrictedUserIds() and RunService:IsStudio() then
		return
	end

	local v4 = canPublishAssets(
		contentIds,
		(getFFlagUGCValidateForwardIECRestrictedUserIds() or v3) and data.restrictedUserIds or {},
		data.token,
		data.universeId,
		true
	)

	if v4.status == "tooManyAssets" then
		object:fail(ErrorSourceStrings.Keys.DescendantIdsTooMany, {
			InstanceFullName = rootInstance:GetFullName()
		})
		return
	end

	if v4.status == "loadFailed" then
		object:fail(ErrorSourceStrings.Keys.DescendantIdFetchFailed, {
			InstanceFullName = rootInstance:GetFullName()
		})

		return
	end

	local verdicts = v4.verdicts

	if not verdicts then
		return
	end

	for _, verdict in verdicts do
		if not verdict.allowed then
			object:fail(ErrorSourceStrings.Keys.DescendantIdNotOwned, {
				AssetId = verdict.assetId,
				InstanceFullName = verdict.entry.instance:GetFullName(),
				FieldName = verdict.entry.fieldName
			})
		end
	end
end

local categories

if getFFlagUGCValidateMakeupCategoryParity() then
	categories = Constants.AllAssetUploadCategories
else
	categories = Constants.AllAssetUploadCategoriesIncludingMakeup
end

return {
	["categories"] = categories,
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.consumerConfig,
		ValidationEnums.SharedDataMember.contentIds
	},
	expectedFailures = {},
	run = function(p, data)
		local consumerConfig = data.consumerConfig

		if consumerConfig.source == "AutoSetup" then
			return
		end

		local rootInstance = data.rootInstance
		local contentIds = data.contentIds

		local validationEnv = consumerConfig.validationEnv

		if validationEnv == ValidationEnums.ValidationEnv.Studio then
			runStudio(p, rootInstance, contentIds)
		elseif validationEnv == ValidationEnums.ValidationEnv.Backend then
			local backendConfigs = consumerConfig.backendConfigs

			if getFFlagUGCValidateBackendInExperienceViaCanPublish() and backendConfigs.universeId then
				runCanPublishOwnershipCheck(p, rootInstance, contentIds, {
					universeId = backendConfigs.universeId,
					restrictedUserIds = backendConfigs.restrictedUserIds
				})
			else
				runBackend(p, contentIds, backendConfigs)
			end
		elseif validationEnv == ValidationEnums.ValidationEnv.IEC then
			runCanPublishOwnershipCheck(p, rootInstance, contentIds, consumerConfig.iecConfigs)
		end
	end
}
