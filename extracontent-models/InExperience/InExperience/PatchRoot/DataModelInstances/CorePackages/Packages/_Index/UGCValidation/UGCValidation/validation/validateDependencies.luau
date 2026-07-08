local ParentParent = script.Parent.Parent
local RunService = game:GetService("RunService")
local v3 = game:DefineFastFlag("NoStudioOwnershipCheck", false)
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)
local ParseContentIds = require(ParentParent.util.ParseContentIds)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local getAssetCreationDetailsRCC = require(ParentParent.util.getAssetCreationDetailsRCC)

require(ParentParent.util.Types)

local validateCanLoad = require(ParentParent.validation.validateCanLoad)
local validateAssetCreator = require(ParentParent.validation.validateAssetCreator)

local function validateExistance(p1, p2) -- line: 23
	-- upvalues: validateCanLoad (copy)
	for _, v in pairs(p1) do
		if not validateCanLoad(v.instance[v.fieldName], p2) then
			error(string.format("Failed to load children assets (Meshes, Textures, etc.) for '%s'. Make sure the assets exist and try again.", v.instance.Name))
		end
	end
end

local t1 = {
	MODERATION_STATE_REVIEWING = {
		MODERATION_STATE_REVIEWING = true,
		Reviewing = true
	},
	MODERATION_STATE_APPROVED = {
		MODERATION_STATE_APPROVED = true,
		Approved = true
	}
}

local function validateCreatorId(p3, p4, p5, p6, p7, p8) -- line: 44
	-- upvalues: Analytics (copy)
	if not p3[tonumber(p4)] then
		Analytics.reportFailure(Analytics.ErrorType.validateDependencies_IsRestrictedUserId, nil, p8)

		return false, { `{ p5:GetFullName() }.{ p6 } ( { p7 } ) is not owned by the current user. You can only validate assets that you or a group you belong to owns.` }
	end

	return true
end
local function validateModerationState(p9, p10, p11, p12, p13) -- line: 62
	-- upvalues: t1 (copy), Analytics (copy)
	if t1.MODERATION_STATE_REVIEWING[p9] then
		Analytics.reportFailure(Analytics.ErrorType.validateDependencies_IsReviewing, nil, p13)
		error("Failed to load asset {instance:GetFullName()}.{fieldName} ( {id} ) that is still going through the review process. Please, wait for a notification of completion from the review process and try again.")
	end

	if not t1.MODERATION_STATE_APPROVED[p9] then
		Analytics.reportFailure(Analytics.ErrorType.validateDependencies_IsNotApproved, nil, p13)

		return false, { `{ p10:GetFullName() }.{ p11 } ( { p12 } ) is not owned by the current user. You can only validate assets that you or a group you belong to owns.` }
	end

	return true
end
local function validateModerationRCC(p14, p15, p16) -- line: 91
	-- upvalues: FailureReasonsAccumulator (copy), getAssetCreationDetailsRCC (copy), validateCreatorId (copy), validateModerationState (copy)
	if not p14 or #p14 == 0 then
		return true
	end

	local t2 = {}

	for _, v in ipairs(p14) do
		t2[tonumber(v.id)] = true
	end

	local v39 = FailureReasonsAccumulator.new()

	for k, v in pairs(p15) do
		local v42, v43 = getAssetCreationDetailsRCC(k)

		if not v42 then
			error("Failed to load asset")
		end

		local creator = v43.creationContext.creator
		local v45 = if not creator.userId then creator.groupId else creator.userId

		v39:updateReasons(validateCreatorId(t2, v45, v.instance, v.fieldName, k, p16))
		v39:updateReasons(validateModerationState(v43.moderationResult.moderationState, v.instance, v.fieldName, k, p16))
	end

	return v39:getFinalResults()
end
local function validateAssetCreatorsRCC(p17, p18) -- line: 136
	-- upvalues: validateAssetCreator (copy)
	assert(p18.isServer, "isServer must be true for validateAssetCreatorsRCC")

	return validateAssetCreator(p17, p18)
end
local function validateDependencies(p19, p20, t3: {[any]: any}?) -- line: 149
	-- upvalues: ParseContentIds (copy), Constants (copy), Analytics (copy), validateExistance (copy), FailureReasonsAccumulator (copy), v3 (copy), RunService (copy), validateAssetCreatorsRCC (copy), validateModerationRCC (copy)
	local timestamp = tick()
	local v52 = if not p20 then nil else p20.isServer
	local allowEditableInstances = p20.allowEditableInstances
	local v54 = if not p20 then nil else p20.restrictedUserIds
	local v55 = if not p20 then nil else p20.universeId
	local v56 = not not t3 and (t3.skipExistenceCheck or false)
	local v57 = not not t3 and (t3.skipOwnershipCheck or false)

	if v56 and v57 then
		return true
	end

	local t4 = {}
	local v59, v60 = ParseContentIds.parseWithErrorCheck({}, t4, p19, nil, Constants.CONTENT_ID_REQUIRED_FIELDS, p20)

	if not v59 then
		Analytics.reportFailure(Analytics.ErrorType.validateDependencies_ParseFailure, nil, p20)

		return false, v60
	end

	if v52 and not allowEditableInstances and not v56 then
		validateExistance(t4, p20)
	end

	local v61 = FailureReasonsAccumulator.new()

	if not v57 and ((not v3 or v3 and not RunService:IsStudio()) and v52) then
		if v55 then
			v61:updateReasons(validateAssetCreatorsRCC(t4, p20))
		else
			v61:updateReasons(validateModerationRCC(v54, t4, p20))
		end
	end

	if p20 then
		Analytics.recordScriptTime(script.Name, timestamp, p20)
	end

	return v61:getFinalResults()
end

return validateDependencies
