local GetShowAgeVerificationOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChat/AgeVerificationOverlay/GetShowAgeVerificationOverlay")
local SetShowAgeVerificationOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChat/AgeVerificationOverlay/SetShowAgeVerificationOverlay")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/Promise")
local performFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/Http").PerformFetch
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/Loggers").mutedError

local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/AppCommonLib").Logging

local function keyMapper(p2)
	return "luaapp.showageverificationoverlay." .. p2
end

return {
	["KeyMapper"] = keyMapper,
	Fetch = function(p2, value, value2)
		if type(value) ~= "string" then
			error("ApiFetchShowAgeVerificationOverlay thunk expects universeId to be a string")
		end

		local v6 = value2 or ""

		if type(v6) ~= "string" then
			error("ApiFetchShowAgeVerificationOverlay thunk expects placeId to be a string")
		end

		return performFetch.Single("luaapp.showageverificationoverlay." .. value, function(object)
			return GetShowAgeVerificationOverlay(p2, value, v6):andThen(function(p3)
				local responseBody = p3.responseBody

				local v7 = not (responseBody.voiceSettings == nil)
					and responseBody.voiceSettings.isVoiceEnabled

				if responseBody.showAgeVerificationOverlay then
					mutedError(`showAgeVerificationOverlay is deprecated but was truthy for universe {value}`)
				end

				if
					responseBody == nil
					or responseBody.showAgeVerificationOverlay == nil
					or responseBody.universePlaceVoiceEnabledSettings == nil
				then
					logging.warn("Response from GetShowAgeVerificationOverlay is malformed!")
					return Promise.reject({ HttpError = Enum.HttpError.OK })
				end

				local isPlaceEnabledForVoice = responseBody.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice
				local isUniverseEnabledForVoice = responseBody.universePlaceVoiceEnabledSettings.isUniverseEnabledForVoice
				local isUniverseEnabledForAvatarVideo = responseBody.universePlaceVoiceEnabledSettings.isUniverseEnabledForAvatarVideo

				object:dispatch(SetShowAgeVerificationOverlay(
					value,
					isPlaceEnabledForVoice,
					isUniverseEnabledForVoice,
					v7,
					responseBody.showVoiceOptInOverlay,
					isUniverseEnabledForAvatarVideo,
					responseBody.elegibleToSeeVoiceUpsell
				))

				return Promise.resolve(p3)
			end)
		end)
	end,
	GetFetchingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, "luaapp.showageverificationoverlay." .. p3)
	end
}
