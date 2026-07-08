local ParentParent = script.Parent.Parent.Parent
local HttpService = game:GetService("HttpService")

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local APIUtil = require(ParentParent.util.APIUtil)
local getFFlagUGCValidateEmotesBonesAllowed = require(ParentParent.flags.getFFlagUGCValidateEmotesBonesAllowed)
local getFFlagUGCValidateEmotesBoneUserVerification = require(ParentParent.flags.getFFlagUGCValidateEmotesBoneUserVerification)
local getFFlagUGCValidateAnimBonesSupport = require(ParentParent.flags.getFFlagUGCValidateAnimBonesSupport)
local getFFlagUGCValidationAnimationPackSupport = require(ParentParent.flags.getFFlagUGCValidationAnimationPackSupport)
local t1 = {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION }
}

if getFFlagUGCValidateAnimBonesSupport() and getFFlagUGCValidationAnimationPackSupport() then
	table.insert(t1.categories, ValidationEnums.UploadCategory.ANIMATION)
end

t1.requiredData = { ValidationEnums.SharedDataMember.consumerConfig }
t1.conditionalData = { ValidationEnums.SharedDataMember.curveAnimBoneData }

function t1.fflag() -- line: 24
	-- upvalues: getFFlagUGCValidateEmotesBonesAllowed (copy), getFFlagUGCValidateAnimBonesSupport (copy)
	return getFFlagUGCValidateEmotesBonesAllowed() or getFFlagUGCValidateAnimBonesSupport()
end

t1.expectedFailures = {}
t1.prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }

local function checkTrustedCreatorPermission() -- line: 30
	-- upvalues: APIUtil (copy), HttpService (copy)
	local v12 = string.format("https://itemconfiguration.%s/v1/permissions/action-allowed-for-item-type?trustedCreatorCheck=true&action=1&assetType=61", APIUtil.getBaseDomain())
	local v13, v14 = APIUtil.requestAndRetryGet(v12)

	if not v13 then
		return false, "Failed to check trusted creator permission: " .. tostring(v14)
	end

	local ok, result = pcall(function() -- line: 41
		-- upvalues: HttpService (copy), v14 (copy)
		return HttpService:JSONDecode(v14)
	end)

	if not ok then
		return false, "Failed to decode permission response"
	end

	return result.isActionAllowed == true, nil
end

function t1.run(p1, p2) -- line: 51
	-- upvalues: getFFlagUGCValidateEmotesBoneUserVerification (copy), ValidationEnums (copy), ErrorSourceStrings (copy), checkTrustedCreatorPermission (copy)
	if not getFFlagUGCValidateEmotesBoneUserVerification() then
		return
	end

	local consumerEnv = p2.consumerConfig.consumerEnv

	if consumerEnv == ValidationEnums.ConsumerEnv.IEC then
		p1:fail(ErrorSourceStrings.Keys.CurveAnim_BonesNotAllowed)

		return
	end

	if consumerEnv == ValidationEnums.ConsumerEnv.Backend then
		if not p2.consumerConfig.backendConfigs.isUserInTrustedCreatorProgram then
			p1:fail(ErrorSourceStrings.Keys.CurveAnim_BonesNotAllowed)
		end

		return
	end

	local v20, v21 = checkTrustedCreatorPermission()

	if v21 then
		p1:forceError(v21)
	end

	if not v20 then
		p1:fail(ErrorSourceStrings.Keys.CurveAnim_BonesNotAllowed)
	end
end

return t1
