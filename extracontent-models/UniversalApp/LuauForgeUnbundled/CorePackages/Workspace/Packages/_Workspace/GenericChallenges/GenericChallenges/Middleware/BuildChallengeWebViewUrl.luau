require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/ChallengeHeaders")

local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Utils/constants")
local ChallengeType = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Types/ChallengeType")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Types/ChallengeParameters")
local TwoStepVerificationActionType = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Types/TwoStepVerificationActionType")
local CaptchaActionType = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Types/CaptchaActionType")

local base64 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/AuthCommon").Utils.Base64

local NotificationService = game:GetService("NotificationService")
local UserInputService = game:GetService("UserInputService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/UrlBuilder").UrlBase
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/Cryo")

local function getUserDarkModeSettingQueryParam(): string
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

local function getChallengeTypeQueryParameters(p2, data)
	if p2 == ChallengeType.Captcha then
		assert(data.actionType ~= nil, "actionType must be provided to render captcha")
		assert(data.dataExchangeBlob ~= nil, "dataExchangeBlob must be provided to render captcha")
		assert(data.captchaId ~= nil, "captchaId must be provided to render captcha")
		return {
			["action-type"] = CaptchaActionType.toRawValue(data.actionType),
			["data-exchange-blob"] = data.dataExchangeBlob,
			["captcha-id"] = data.captchaId
		}
	elseif p2 == ChallengeType.TwoStepVerification then
		assert(data.challengeId ~= nil, "challengeId must be provided to render 2sv")
		assert(data.userId ~= nil, "userId must be provided to render 2sv")
		assert(data.actionType ~= nil, "actionType must be provided to render 2sv")
		assert(data.allowRememberDevice ~= nil, "allowRememberDevice must be provided to render 2sv")
		local v5 = {
			["challenge-id"] = data.challengeId,
			["user-id"] = data.userId,
			["action-type"] = TwoStepVerificationActionType.toRawValue(data.actionType),
			["allow-remember-device"] = data.allowRememberDevice and "true" or "false",
			["client-supports-2sv-recovery"] = data.clientSupports2svRecovery and "true" or "false"
		}

		if data.recoverySessionId ~= nil and string.len(data.recoverySessionId) > 0 then
			v5["recovery-session-id"] = data.recoverySessionId
		end

		return v5
	elseif p2 == ChallengeType.SecurityQuestions then
		assert(data.sessionId ~= nil, "sessionId must be provided to render security questions")
		assert(data.userId ~= nil, "userId must be provided to render security questions")
		return { ["user-id"] = data.userId, ["session-id"] = data.sessionId }
	else
		if not (p2 ~= ChallengeType.Reauthentication and p2 == ChallengeType.Generic) then
			return {}
		end

		assert(data.genericChallengeId ~= nil, "genericChallengeId must be provided to render challenge")
		assert(
			data.genericChallengeType ~= nil,
			"genericChallengeType must be provided to render challenge"
		)

		assert(
			data.genericChallengeMetadata ~= nil,
			"genericChallengeMetadata must be provided to render challenge"
		)

		return {
			["generic-challenge-id"] = data.genericChallengeId,
			["generic-challenge-type"] = data.genericChallengeType,
			["challenge-metadata-json"] = data.genericChallengeMetadata
		}
	end
end

return function(data, p2, p3)
	if data ~= nil then
		assert(p3 == nil, "challenge parameters cannot be specified for generic challenge rendering")
		assert(string.len(data.challengeId) > 0, "challenge id does not exist")
		assert(data.challengeType.typed ~= nil, "challenge is of an unknown type")
	end

	local v5 = ChallengeType.Generic

	if p2 ~= nil then
		assert(ChallengeType.toRawValue(p2) ~= nil, "challenge type is not valid")
		v5 = p2
	end

	local v6 = {
		[constants.appTypeQueryParam] = getUserAppTypeQueryParam(),
		[constants.challengeTypeQueryParam] = ChallengeType.toRawValue(v5),
		[constants.darkModeQueryParam] = string.lower(NotificationService.SelectedTheme) == "dark" and "true" or "false"
	}
	local v7

	if p3 == nil then
		assert(data ~= nil, "challenge headers must be defined for generic challenge rendering")

		v7 = {}
		v7[constants.genericChallengeIdQueryParam] = data.challengeId
		v7[constants.genericChallengeTypeQueryParam] = data.challengeType.raw

		v7[constants.challengeMetadataJsonQueryParam] = base64.EncodeUrl(data.challengeMetadata.decoded)
	else
		v7 = getChallengeTypeQueryParameters(v5, p3)
	end

	return urlBuilder.new({
		base = urlBase.WWW,
		path = "challenge/cdn/hybrid",
		query = Cryo.Dictionary.join(v6, v7)
	})()
end
