require(script.Parent.ChallengeHeaders)
local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local constants = require(GenericChallenges.Utils.constants)
local ChallengeType = require(GenericChallenges.Types.ChallengeType)
require(GenericChallenges.Types.ChallengeParameters)
local TwoStepVerificationActionType = require(GenericChallenges.Types.TwoStepVerificationActionType)
local CaptchaActionType = require(GenericChallenges.Types.CaptchaActionType)
local parent = GenericChallenges.Parent

local AuthCommon = require(parent.AuthCommon)
local Base64 = AuthCommon.Utils.Base64

local NotificationService = game:GetService("NotificationService")
local UserInputService = game:GetService("UserInputService")

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase
local Cryo = require(parent.Cryo)

local function getUserDarkModeSettingQueryParam(): string -- 1 equivalent call inferred from this helper
	if string.lower(NotificationService.SelectedTheme) == "dark" then
		return "true"
	end

	return "false"
end

local function getUserAppTypeQueryParam(): boolean | string
	local platform = UserInputService:GetPlatform()

	if platform == Enum.Platform.Android then
		return "android"
	end

	if platform == Enum.Platform.IOS then
		return "ios"
	end

	if platform == Enum.Platform.Windows then
		return "windows"
	end

	if platform == Enum.Platform.OSX then
		return "osx"
	end

	if platform == Enum.Platform.UWP then
		return "uwp"
	end

	return platform == Enum.Platform.XBoxOne and "xbox" or "unknown"
end

local function getChallengeTypeQueryParameters(p, data)
	if p == ChallengeType.Captcha then
		assert(data.actionType ~= nil, "actionType must be provided to render captcha")
		assert(data.dataExchangeBlob ~= nil, "dataExchangeBlob must be provided to render captcha")
		assert(data.captchaId ~= nil, "captchaId must be provided to render captcha")
		return {
			["action-type"] = CaptchaActionType.toRawValue(data.actionType),
			["data-exchange-blob"] = data.dataExchangeBlob,
			["captcha-id"] = data.captchaId
		}
	elseif p == ChallengeType.TwoStepVerification then
		assert(data.challengeId ~= nil, "challengeId must be provided to render 2sv")
		assert(data.userId ~= nil, "userId must be provided to render 2sv")
		assert(data.actionType ~= nil, "actionType must be provided to render 2sv")
		assert(data.allowRememberDevice ~= nil, "allowRememberDevice must be provided to render 2sv")
		local v = {
			["challenge-id"] = data.challengeId,
			["user-id"] = data.userId,
			["action-type"] = TwoStepVerificationActionType.toRawValue(data.actionType),
			["allow-remember-device"] = data.allowRememberDevice and "true" or "false",
			["client-supports-2sv-recovery"] = data.clientSupports2svRecovery and "true" or "false"
		}

		if data.recoverySessionId ~= nil and string.len(data.recoverySessionId) > 0 then
			v["recovery-session-id"] = data.recoverySessionId
		end

		return v
	elseif p == ChallengeType.SecurityQuestions then
		assert(data.sessionId ~= nil, "sessionId must be provided to render security questions")
		assert(data.userId ~= nil, "userId must be provided to render security questions")
		return { ["user-id"] = data.userId, ["session-id"] = data.sessionId }
	else
		if not (p ~= ChallengeType.Reauthentication and p == ChallengeType.Generic) then
			return {}
		end

		assert(data.genericChallengeId ~= nil, "genericChallengeId must be provided to render challenge")
		assert(data.genericChallengeType ~= nil, "genericChallengeType must be provided to render challenge")

		assert(data.genericChallengeMetadata ~= nil, "genericChallengeMetadata must be provided to render challenge")

		return {
			["generic-challenge-id"] = data.genericChallengeId,
			["generic-challenge-type"] = data.genericChallengeType,
			["challenge-metadata-json"] = data.genericChallengeMetadata
		}
	end
end

return function(data, p, p2)
	if data ~= nil then
		assert(p2 == nil, "challenge parameters cannot be specified for generic challenge rendering")
		assert(string.len(data.challengeId) > 0, "challenge id does not exist")
		assert(data.challengeType.typed ~= nil, "challenge is of an unknown type")
	end

	local v = ChallengeType.Generic

	if p ~= nil then
		assert(ChallengeType.toRawValue(p) ~= nil, "challenge type is not valid")
		v = p
	end

	local v2 = {
		[constants.appTypeQueryParam] = getUserAppTypeQueryParam(),
		[constants.challengeTypeQueryParam] = ChallengeType.toRawValue(v),
		[constants.darkModeQueryParam] = getUserDarkModeSettingQueryParam() -- inferred equivalent call
	}
	local v3

	if p2 == nil then
		assert(data ~= nil, "challenge headers must be defined for generic challenge rendering")

		v3 = {}
		v3[constants.genericChallengeIdQueryParam] = data.challengeId
		v3[constants.genericChallengeTypeQueryParam] = data.challengeType.raw

		v3[constants.challengeMetadataJsonQueryParam] = Base64.EncodeUrl(data.challengeMetadata.decoded)
	else
		v3 = getChallengeTypeQueryParameters(v, p2)
	end

	return urlBuilder.new({
		base = UrlBase.WWW,
		path = "challenge/cdn/hybrid",
		query = Cryo.Dictionary.join(v2, v3)
	})()
end
