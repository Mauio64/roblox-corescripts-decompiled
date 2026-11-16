local parent = script.Parent.Parent

local RunService = game:GetService("RunService")

local defineFastFlag = game:DefineFastFlag("NoStudioOwnershipCheck", false)

local Analytics = require(parent.Analytics)
local Constants = require(parent.Constants)

local ParseContentIds = require(parent.util.ParseContentIds)
local FailureReasonsAccumulator = require(parent.util.FailureReasonsAccumulator)
local getAssetCreationDetailsRCC = require(parent.util.getAssetCreationDetailsRCC)
require(parent.util.Types)

local validateCanLoad = require(parent.validation.validateCanLoad)
local validateAssetCreator = require(parent.validation.validateAssetCreator)

local function validateExistance(items, data)
	for _, item in pairs(items) do
		if not validateCanLoad(item.instance[item.fieldName], data) then
			error(string.format(
				"Failed to load children assets (Meshes, Textures, etc.) for '%s'. Make sure the assets exist and try again.",
				item.instance.Name
			))
		end
	end
end

local v = {
	MODERATION_STATE_REVIEWING = { MODERATION_STATE_REVIEWING = true, Reviewing = true },
	MODERATION_STATE_APPROVED = { MODERATION_STATE_APPROVED = true, Approved = true }
}

local function validateCreatorId(idSet, p, instance, fieldName, k, p2)
	if idSet[tonumber(p)] then
		return true
	end

	Analytics.reportFailure(Analytics.ErrorType.validateDependencies_IsRestrictedUserId, nil, p2)

	return
		false,
		{ `{instance:GetFullName()}.{fieldName} ( {k} ) is not owned by the current user. You can only validate assets that you or a group you belong to owns.` }
end

local function validateModerationState(moderationState, instance, fieldName, k, p)
	if v.MODERATION_STATE_REVIEWING[moderationState] then
		Analytics.reportFailure(Analytics.ErrorType.validateDependencies_IsReviewing, nil, p)
		error("Failed to load asset {instance:GetFullName()}.{fieldName} ( {id} ) that is still going through the review process. Please, wait for a notification of completion from the review process and try again.")
	end

	if v.MODERATION_STATE_APPROVED[moderationState] then
		return true
	end

	Analytics.reportFailure(Analytics.ErrorType.validateDependencies_IsNotApproved, nil, p)

	return
		false,
		{ `{instance:GetFullName()}.{fieldName} ( {k} ) is not owned by the current user. You can only validate assets that you or a group you belong to owns.` }
end

local function validateModerationRCC(restrictedUserIds, items, data)
	if not restrictedUserIds or #restrictedUserIds == 0 then
		return true
	end

	local idSet = {}

	for _, item in ipairs(restrictedUserIds) do
		idSet[tonumber(item.id)] = true
	end

	local v2 = FailureReasonsAccumulator.new()

	for k, item in pairs(items) do
		local assetCreationDetailsRCC, v3 = getAssetCreationDetailsRCC(k)

		if not assetCreationDetailsRCC then
			error("Failed to load asset")
		end

		local creator = v3.creationContext.creator
		local v4

		if creator.userId then
			v4 = creator.userId
		else
			v4 = creator.groupId
		end

		v2:updateReasons(validateCreatorId(idSet, v4, item.instance, item.fieldName, k, data))

		v2:updateReasons(validateModerationState(
			v3.moderationResult.moderationState,
			item.instance,
			item.fieldName,
			k,
			data
		))
	end

	return v2:getFinalResults()
end

local function validateAssetCreatorsRCC(p, data)
	assert(data.isServer, "isServer must be true for validateAssetCreatorsRCC")
	return validateAssetCreator(p, data)
end

local function validateDependencies(p, data, p2)
	local now = tick()
	local isServer

	if data then
		isServer = data.isServer
	end

	local allowEditableInstances = data.allowEditableInstances
	local restrictedUserIds

	if data then
		restrictedUserIds = data.restrictedUserIds
	end

	local universeId

	if data then
		universeId = data.universeId
	end

	local v2

	if p2 then
		v2 = p2.skipExistenceCheck or false
	else
		v2 = false
	end

	local skipOwnershipCheck = p2 and p2.skipOwnershipCheck or false

	if v2 and skipOwnershipCheck then
		return true
	end

	local v3 = {}
	local parseWithErrorCheck, v4 = ParseContentIds.parseWithErrorCheck(
		{},
		v3,
		p,
		nil,
		Constants.CONTENT_ID_REQUIRED_FIELDS,
		data
	)

	if not parseWithErrorCheck then
		Analytics.reportFailure(Analytics.ErrorType.validateDependencies_ParseFailure, nil, data)
		return false, v4
	end

	if isServer and not (allowEditableInstances or v2) then
		validateExistance(v3, data)
	end

	local v5 = FailureReasonsAccumulator.new()

	if not skipOwnershipCheck and (not defineFastFlag or defineFastFlag and not RunService:IsStudio()) and isServer then
		if universeId then
			v5:updateReasons(validateAssetCreatorsRCC(v3, data))
		else
			v5:updateReasons(validateModerationRCC(restrictedUserIds, v3, data))
		end
	end

	if data then
		Analytics.recordScriptTime(script.Name, now, data)
	end

	return v5:getFinalResults()
end

return validateDependencies
