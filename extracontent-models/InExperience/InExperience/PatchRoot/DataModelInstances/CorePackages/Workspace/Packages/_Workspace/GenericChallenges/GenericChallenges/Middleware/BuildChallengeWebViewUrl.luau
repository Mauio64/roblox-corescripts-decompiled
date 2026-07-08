require(script.Parent.ChallengeHeaders)

local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local constants = require(GenericChallenges.Utils.constants)
local ChallengeType = require(GenericChallenges.Types.ChallengeType)

require(GenericChallenges.Types.ChallengeParameters)

local TwoStepVerificationActionType = require(GenericChallenges.Types.TwoStepVerificationActionType)
local CaptchaActionType = require(GenericChallenges.Types.CaptchaActionType)
local GenericChallengesParent = GenericChallenges.Parent
local Base64 = require(GenericChallengesParent.AuthCommon).Utils.Base64
local NotificationService = game:GetService("NotificationService")
local UserInputService = game:GetService("UserInputService")
local UrlBuilder = require(GenericChallengesParent.UrlBuilder).UrlBuilder
local UrlBase = require(GenericChallengesParent.UrlBuilder).UrlBase
local Cryo = require(GenericChallengesParent.Cryo)

local function getUserDarkModeSettingQueryParam() -- line: 23
	-- upvalues: NotificationService (copy)
	if string.lower(NotificationService.SelectedTheme) == "dark" then
		return "true"
	end

	return "false"
end
local function getUserAppTypeQueryParam() -- line: 30
	-- upvalues: UserInputService (copy)
	local Platform = UserInputService:GetPlatform()
	local s1 = "unknown"

	if Platform == Enum.Platform.Android then
		return "android"
	end

	if Platform == Enum.Platform.IOS then
		return "ios"
	end

	if Platform == Enum.Platform.Windows then
		return "windows"
	end

	if Platform == Enum.Platform.OSX then
		return "osx"
	end

	if Platform == Enum.Platform.UWP then
		return "uwp"
	end

	if Platform == Enum.Platform.XBoxOne then
		s1 = "xbox"
	end

	return s1
end
local function getChallengeTypeQueryParameters(p1, p2) -- line: 49
	-- upvalues: ChallengeType (copy), CaptchaActionType (copy), TwoStepVerificationActionType (copy)
	if p1 == ChallengeType.Captcha then
		assert(p2.actionType ~= nil, "actionType must be provided to render captcha")
		assert(p2.dataExchangeBlob ~= nil, "dataExchangeBlob must be provided to render captcha")
		assert(p2.captchaId ~= nil, "captchaId must be provided to render captcha")

		return {
			["action-type"] = CaptchaActionType.toRawValue(p2.actionType),
			["data-exchange-blob"] = p2.dataExchangeBlob,
			["captcha-id"] = p2.captchaId
		}
	end

	if p1 == ChallengeType.TwoStepVerification then
		assert(p2.challengeId ~= nil, "challengeId must be provided to render 2sv")
		assert(p2.userId ~= nil, "userId must be provided to render 2sv")
		assert(p2.actionType ~= nil, "actionType must be provided to render 2sv")
		assert(p2.allowRememberDevice ~= nil, "allowRememberDevice must be provided to render 2sv")

		local t1 = {
			["challenge-id"] = p2.challengeId,
			["user-id"] = p2.userId,
			["action-type"] = TwoStepVerificationActionType.toRawValue(p2.actionType),
			["allow-remember-device"] = not p2.allowRememberDevice and "false" or "true",
			["client-supports-2sv-recovery"] = not p2.clientSupports2svRecovery and "false" or "true"
		}

		if p2.recoverySessionId ~= nil and string.len(p2.recoverySessionId) > 0 then
			t1["recovery-session-id"] = p2.recoverySessionId
		end

		return t1
	end

	if p1 == ChallengeType.SecurityQuestions then
		assert(p2.sessionId ~= nil, "sessionId must be provided to render security questions")
		assert(p2.userId ~= nil, "userId must be provided to render security questions")

		return {
			["user-id"] = p2.userId,
			["session-id"] = p2.sessionId
		}
	end

	if p1 == ChallengeType.Reauthentication then
		return {}
	end

	if p1 == ChallengeType.Generic then
		assert(p2.genericChallengeId ~= nil, "genericChallengeId must be provided to render challenge")
		assert(p2.genericChallengeType ~= nil, "genericChallengeType must be provided to render challenge")
		assert(p2.genericChallengeMetadata ~= nil, "genericChallengeMetadata must be provided to render challenge")

		return {
			["generic-challenge-id"] = p2.genericChallengeId,
			["generic-challenge-type"] = p2.genericChallengeType,
			["challenge-metadata-json"] = p2.genericChallengeMetadata
		}
	end

	return {}
end

return function(p3, p4, p5) -- line: 109
	-- upvalues: ChallengeType (copy), constants (copy), getUserAppTypeQueryParam (copy), NotificationService (copy), getChallengeTypeQueryParameters (copy), Base64 (copy), UrlBuilder (copy), UrlBase (copy), Cryo (copy)
	if p3 ~= nil then
		assert(p5 == nil, "challenge parameters cannot be specified for generic challenge rendering")
		assert(string.len(p3.challengeId) > 0, "challenge id does not exist")
		assert(p3.challengeType.typed ~= nil, "challenge is of an unknown type")
	end

	local Generic = ChallengeType.Generic

	if p4 ~= nil then
		assert(ChallengeType.toRawValue(p4) ~= nil, "challenge type is not valid")
		Generic = p4
	end

	local t2 = {
		[constants.appTypeQueryParam] = getUserAppTypeQueryParam(),
		[constants.challengeTypeQueryParam] = ChallengeType.toRawValue(Generic),
		[constants.darkModeQueryParam] = string.lower(NotificationService.SelectedTheme) ~= "dark" and "false" or "true"
	}
	local v26

	if p5 ~= nil then
		v26 = getChallengeTypeQueryParameters(Generic, p5)
	else
		assert(p3 ~= nil, "challenge headers must be defined for generic challenge rendering")
		v26 = {
			[constants.genericChallengeIdQueryParam] = p3.challengeId,
			[constants.genericChallengeTypeQueryParam] = p3.challengeType.raw,
			[constants.challengeMetadataJsonQueryParam] = Base64.EncodeUrl(p3.challengeMetadata.decoded)
		}
	end

	return UrlBuilder.new({
		path = "challenge/cdn/hybrid",
		base = UrlBase.WWW,
		query = Cryo.Dictionary.join(t2, v26)
	})()
end
