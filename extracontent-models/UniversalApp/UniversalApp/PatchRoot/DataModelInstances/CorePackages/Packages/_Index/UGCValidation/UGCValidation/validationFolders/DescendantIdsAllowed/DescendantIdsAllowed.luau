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
local t1 = {
	MODERATION_STATE_REVIEWING = true,
	Reviewing = true
}
local t2 = {
	MODERATION_STATE_APPROVED = true,
	Approved = true
}

local function collectContentIdsArray(p1) -- line: 20
	local t3 = {}

	for v20, _ in p1 do
		table.insert(t3, v20)
	end

	return t3
end
local function runStudio(p2, p3, p4) -- line: 28
	-- upvalues: getAssetCreationDetails (copy), ErrorSourceStrings (copy), Constants (copy)
	local t4 = {}

	for v26, _ in p4 do
		table.insert(t4, v26)
	end

	if #t4 == 0 then
		return
	end

	local v28, v29 = getAssetCreationDetails(t4)

	if not v28 or #v29 ~= #t4 then
		p2:fail(ErrorSourceStrings.Keys.DescendantIdFetchFailed, {
			InstanceFullName = p3:GetFullName()
		})

		return
	end

	for _, v31 in v29 do
		if v31.status == Constants.ASSET_STATUS.UNKNOWN or (v31.status == Constants.ASSET_STATUS.REVIEW_PENDING or v31.status == Constants.ASSET_STATUS.MODERATED) then
			local str = tostring(v31.assetId)
			local v33 = p4[str]
			local v34 = if not v33 then str else string.format("%s.%s ( %s )", v33[1].instance:GetFullName(), v33[1].fieldName, str)

			p2:fail(ErrorSourceStrings.Keys.DescendantIdNotApproved, {
				ModerationMessages = v34
			})
		end
	end
end
local function buildOwnerLookup(p5) -- line: 66
	local t5 = {}

	for _, v38 in p5 do
		t5[tonumber(v38.id)] = true
	end

	return t5
end
local function runBackend(p6, p7, p8) -- line: 74
	-- upvalues: getAssetCreationDetailsRCC (copy), ErrorSourceStrings (copy), t1 (copy), t2 (copy)
	local restrictedUserIds = p8.restrictedUserIds

	if not restrictedUserIds or #restrictedUserIds == 0 then
		return
	end

	local t6 = {}

	for _, v45 in restrictedUserIds do
		t6[tonumber(v45.id)] = true
	end

	for v46, v47 in p7 do
		local v48 = v47[1]
		local v49, v50 = getAssetCreationDetailsRCC(v46)

		if not v49 then
			p6:forceError("Failed to load asset")
		end

		local creator = v50.creationContext.creator

		if not t6[tonumber(if not creator.userId then creator.groupId else creator.userId)] then
			p6:fail(ErrorSourceStrings.Keys.DescendantIdNotOwned, {
				AssetId = v46,
				InstanceFullName = v48.instance:GetFullName(),
				FieldName = v48.fieldName
			})
		end

		local moderationState = v50.moderationResult.moderationState

		if t1[moderationState] then
			p6:forceError("Failed to load asset " .. v48.instance:GetFullName() .. "." .. v48.fieldName .. " ( " .. v46 .. " ) that is still going through the review process. Please, wait for a notification of completion from the review process and try again.")
		end

		if not t2[moderationState] then
			p6:fail(ErrorSourceStrings.Keys.DescendantIdNotApproved, {
				ModerationMessages = string.format("%s.%s ( %s )", v48.instance:GetFullName(), v48.fieldName, v46)
			})
		end
	end
end
local function runIEC(p9, p10, p11, p12) -- line: 132
	-- upvalues: getFFlagUGCValidateForwardIECRestrictedUserIds (copy), RunService (copy), canPublishAssets (copy), ErrorSourceStrings (copy)
	if not p12.token or getFFlagUGCValidateForwardIECRestrictedUserIds() and RunService:IsStudio() then
		return
	end

	local v57 = if not getFFlagUGCValidateForwardIECRestrictedUserIds() then {} else p12.restrictedUserIds or {}
	local v58 = canPublishAssets(p11, v57, p12.token, p12.universeId, true)

	if v58.status == "tooManyAssets" then
		p9:fail(ErrorSourceStrings.Keys.DescendantIdsTooMany, {
			InstanceFullName = p10:GetFullName()
		})

		return
	end

	if v58.status == "loadFailed" then
		p9:fail(ErrorSourceStrings.Keys.DescendantIdFetchFailed, {
			InstanceFullName = p10:GetFullName()
		})

		return
	end

	local verdicts = v58.verdicts

	if not verdicts then
		return
	end

	for _, v61 in verdicts do
		if not v61.allowed then
			p9:fail(ErrorSourceStrings.Keys.DescendantIdNotOwned, {
				AssetId = v61.assetId,
				InstanceFullName = v61.entry.instance:GetFullName(),
				FieldName = v61.entry.fieldName
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
	run = function(p13, p14) -- line: 192
		-- upvalues: ValidationEnums (copy), runStudio (copy), runBackend (copy), runIEC (copy)
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
			runBackend(p13, contentIds, consumerConfig.backendConfigs)

			return
		end

		if consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.IEC then
			runIEC(p13, rootInstance, contentIds, consumerConfig.iecConfigs)
		end
	end
}
