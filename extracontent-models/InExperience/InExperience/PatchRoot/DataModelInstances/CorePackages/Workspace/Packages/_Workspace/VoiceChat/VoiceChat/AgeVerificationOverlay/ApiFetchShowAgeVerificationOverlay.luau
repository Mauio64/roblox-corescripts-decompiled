local VoiceChat = script:FindFirstAncestor("VoiceChat")
local GetShowAgeVerificationOverlay = require(VoiceChat.AgeVerificationOverlay.GetShowAgeVerificationOverlay)
local SetShowAgeVerificationOverlay = require(VoiceChat.AgeVerificationOverlay.SetShowAgeVerificationOverlay)

local parent = VoiceChat.Parent
local Promise = require(parent.Promise)
local Http = require(parent.Http)
local PerformFetch = Http.PerformFetch
local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError

local AppCommonLib = require(parent.AppCommonLib)
local Logging = AppCommonLib.Logging

local function keyMapper(p) -- 2 equivalent calls inferred from this helper
	return "luaapp.showageverificationoverlay." .. p
end

local ApiFetchShowAgeVerificationOverlay = {}
ApiFetchShowAgeVerificationOverlay.KeyMapper = keyMapper

function ApiFetchShowAgeVerificationOverlay.Fetch(p, value: string, value2: string?)
	if type(value) ~= "string" then
		error("ApiFetchShowAgeVerificationOverlay thunk expects universeId to be a string")
	end

	local v = value2 or ""

	if type(v) ~= "string" then
		error("ApiFetchShowAgeVerificationOverlay thunk expects placeId to be a string")
	end

	return PerformFetch.Single(keyMapper(value), function(object) -- inferred equivalent call
		return GetShowAgeVerificationOverlay(p, value, v):andThen(function(p2)
			local responseBody = p2.responseBody
			local v2

			if responseBody.voiceSettings == nil then
				v2 = false
			else
				v2 = responseBody.voiceSettings.isVoiceEnabled
			end

			if responseBody.showAgeVerificationOverlay then
				mutedError(`showAgeVerificationOverlay is deprecated but was truthy for universe {value}`)
			end

			if
				responseBody == nil
				or responseBody.showAgeVerificationOverlay == nil
				or responseBody.universePlaceVoiceEnabledSettings == nil
			then
				Logging.warn("Response from GetShowAgeVerificationOverlay is malformed!")
				return Promise.reject({ HttpError = Enum.HttpError.OK })
			end

			local isPlaceEnabledForVoice = responseBody.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice
			local isUniverseEnabledForVoice = responseBody.universePlaceVoiceEnabledSettings.isUniverseEnabledForVoice
			local isUniverseEnabledForAvatarVideo = responseBody.universePlaceVoiceEnabledSettings.isUniverseEnabledForAvatarVideo

			object:dispatch(SetShowAgeVerificationOverlay(
				value,
				isPlaceEnabledForVoice,
				isUniverseEnabledForVoice,
				v2,
				responseBody.showVoiceOptInOverlay,
				isUniverseEnabledForAvatarVideo,
				responseBody.elegibleToSeeVoiceUpsell
			))

			return Promise.resolve(p2)
		end)
	end)
end

function ApiFetchShowAgeVerificationOverlay.GetFetchingStatus(p, p2)
	return PerformFetch.GetStatus(p, keyMapper(p2)) -- inferred equivalent call
end

return ApiFetchShowAgeVerificationOverlay
