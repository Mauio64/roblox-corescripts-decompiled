local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local RunService = game:GetService("RunService")
local canPublishAssets = require(ParentParent.util.canPublishAssets)
local getAssetCreationDetails = require(ParentParent.util.getAssetCreationDetails)
local getAssetCreationDetailsRCC = require(ParentParent.util.getAssetCreationDetailsRCC)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local getFFlagUGCValidateForwardIECRestrictedUserIds = require(ParentParent.flags.getFFlagUGCValidateForwardIECRestrictedUserIds)
local getFFlagUGCValidateBackendInExperienceViaCanPublish = require(ParentParent.flags.getFFlagUGCValidateBackendInExperienceViaCanPublish)
local t1 = {
	MODERATION_STATE_REVIEWING = true,
	Reviewing = true
}
local t2 = {
	MODERATION_STATE_APPROVED = true,
	Approved = true
}

local function collectContentIdsArray(p1) -- line: 22
	local t3 = {}

	for v21, _ in p1 do
		table.insert(t3, v21)
	end

	return t3
end
local function runStudio(p2, p3, p4) -- line: 30
	-- upvalues: getAssetCreationDetails (copy), ErrorSourceStrings (copy), Constants (copy)
	local t4 = {}

	for v27, _ in p4 do
		table.insert(t4, v27)
	end

	if #t4 == 0 then
		return
	end

	local v29, v30 = getAssetCreationDetails(t4)

	if not v29 or #v30 ~= #t4 then
		p2:fail(ErrorSourceStrings.Keys.DescendantIdFetchFailed, {
			InstanceFullName = p3:GetFullName()
		})

		return
	end

	for _, v32 in v30 do
		if v32.status == Constants.ASSET_STATUS.UNKNOWN or (v32.status == Constants.ASSET_STATUS.REVIEW_PENDING or v32.status == Constants.ASSET_STATUS.MODERATED) then
			local str = tostring(v32.assetId)
			local v34 = p4[str]
			local v35 = if not v34 then str else string.format("%s.%s ( %s )", v34[1].instance:GetFullName(), v34[1].fieldName, str)

			p2:fail(ErrorSourceStrings.Keys.DescendantIdNotApproved, {
				ModerationMessages = v35
			})
		end
	end
end
local function buildOwnerLookup(p5) -- line: 68
	local t5 = {}

	for _, v39 in p5 do
		t5[tonumber(v39.id)] = true
	end

	return t5
end
local function runBackend(p6, p7, p8) -- line: 76
	-- upvalues: getAssetCreationDetailsRCC (copy), ErrorSourceStrings (copy), t1 (copy), t2 (copy)
	local restrictedUserIds = p8.restrictedUserIds

	if not restrictedUserIds or #restrictedUserIds == 0 then
		return
	end

	local t6 = {}

	for _, v46 in restrictedUserIds do
		t6[tonumber(v46.id)] = true
	end

	for v47, v48 in p7 do
		local v49 = v48[1]
		local v50, v51 = getAssetCreationDetailsRCC(v47)

		if not v50 then
			p6:forceError("Failed to load asset")
		end

		local creator = v51.creationContext.creator

		if not t6[tonumber(if not creator.userId then creator.groupId else creator.userId)] then
			p6:fail(ErrorSourceStrings.Keys.DescendantIdNotOwned, {
				AssetId = v47,
				InstanceFullName = v49.instance:GetFullName(),
				FieldName = v49.fieldName
			})
		end

		local moderationState = v51.moderationResult.moderationState

		if t1[moderationState] then
			p6:forceError("Failed to load asset " .. v49.instance:GetFullName() .. "." .. v49.fieldName .. " ( " .. v47 .. " ) that is still going through the review process. Please, wait for a notification of completion from the review process and try again.")
		end

		if not t2[moderationState] then
			p6:fail(ErrorSourceStrings.Keys.DescendantIdNotApproved, {
				ModerationMessages = string.format("%s.%s ( %s )", v49.instance:GetFullName(), v49.fieldName, v47)
			})
		end
	end
end
local function runCanPublishOwnershipCheck(p9, p10, p11, p12) -- line: 134
	-- upvalues: getFFlagUGCValidateBackendInExperienceViaCanPublish (copy), getFFlagUGCValidateForwardIECRestrictedUserIds (copy), RunService (copy), canPublishAssets (copy), ErrorSourceStrings (copy)
	local v58 = getFFlagUGCValidateBackendInExperienceViaCanPublish() and (p12.token == nil and p12.universeId ~= nil)

	if not p12.token and not v58 or getFFlagUGCValidateForwardIECRestrictedUserIds() and RunService:IsStudio() then
		return
	end

	local v59 = if not getFFlagUGCValidateForwardIECRestrictedUserIds() and not v58 then {} else p12.restrictedUserIds or {}
	local v60 = canPublishAssets(p11, v59, p12.token, p12.universeId, true)

	if v60.status == "tooManyAssets" then
		p9:fail(ErrorSourceStrings.Keys.DescendantIdsTooMany, {
			InstanceFullName = p10:GetFullName()
		})

		return
	end

	if v60.status == "loadFailed" then
		p9:fail(ErrorSourceStrings.Keys.DescendantIdFetchFailed, {
			InstanceFullName = p10:GetFullName()
		})

		return
	end

	local verdicts = v60.verdicts

	if not verdicts then
		return
	end

	for _, v63 in verdicts do
		if not v63.allowed then
			p9:fail(ErrorSourceStrings.Keys.DescendantIdNotOwned, {
				AssetId = v63.assetId,
				InstanceFullName = v63.entry.instance:GetFullName(),
				FieldName = v63.entry.fieldName
			})
		end
	end
end

return {
	categories = Constants.AllAssetUploadCategoriesIncludingMakeup,
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.consumerConfig,
		ValidationEnums.SharedDataMember.contentIds
	},
	fflag = getFFlagUGCValidateMigrateSchemaProperties,
	expectedFailures = {},
	run = function(p13, p14) -- line: 203
		-- upvalues: ValidationEnums (copy), runStudio (copy), getFFlagUGCValidateBackendInExperienceViaCanPublish (copy), runCanPublishOwnershipCheck (copy), runBackend (copy)
		local consumerConfig = p14.consumerConfig

		if consumerConfig.source == "AutoSetup" then
			return
		end

		local rootInstance = p14.rootInstance
		local contentIds = p14.contentIds

		if consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.Studio then
			runStudio(p13, rootInstance, contentIds)

			return
		end

		if consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.Backend then
			local backendConfigs = consumerConfig.backendConfigs

			if getFFlagUGCValidateBackendInExperienceViaCanPublish() and backendConfigs.universeId then
				runCanPublishOwnershipCheck(p13, rootInstance, contentIds, {
					universeId = backendConfigs.universeId,
					restrictedUserIds = backendConfigs.restrictedUserIds
				})

				return
			end

			runBackend(p13, contentIds, backendConfigs)

			return
		end

		if consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.IEC then
			runCanPublishOwnershipCheck(p13, rootInstance, contentIds, consumerConfig.iecConfigs)
		end
	end
}
