local VoiceChat = script:FindFirstAncestor("VoiceChat")
local GetShowAgeVerificationOverlay = require(VoiceChat.AgeVerificationOverlay.GetShowAgeVerificationOverlay)
local SetShowAgeVerificationOverlay = require(VoiceChat.AgeVerificationOverlay.SetShowAgeVerificationOverlay)
local VoiceChatParent = VoiceChat.Parent
local Promise = require(VoiceChatParent.Promise)
local PerformFetch = require(VoiceChatParent.Http).PerformFetch
local mutedError = require(VoiceChatParent.Loggers).mutedError
local Logging = require(VoiceChatParent.AppCommonLib).Logging
local t1 = {}

local function keyMapper(p1) -- line: 14
	return "luaapp.showageverificationoverlay." .. p1
end

t1.KeyMapper = keyMapper

function t1.Fetch(p2, s1: string, s2: string?) -- line: 20
	-- upvalues: PerformFetch (copy), GetShowAgeVerificationOverlay (copy), mutedError (copy), SetShowAgeVerificationOverlay (copy), Promise (copy), Logging (copy)
	if type(s1) ~= "string" then
		error("ApiFetchShowAgeVerificationOverlay thunk expects universeId to be a string")
	end

	local u15 = s2 or ""

	if type(u15) ~= "string" then
		error("ApiFetchShowAgeVerificationOverlay thunk expects placeId to be a string")
	end

	return PerformFetch.Single("luaapp.showageverificationoverlay." .. s1, function(p3) -- line: 30
		-- upvalues: GetShowAgeVerificationOverlay (copy), p2 (copy), s1 (copy), u15 (ref), mutedError (copy), SetShowAgeVerificationOverlay (copy), Promise (copy), Logging (copy)
		return GetShowAgeVerificationOverlay(p2, s1, u15):andThen(function(p4) -- line: 31
			-- upvalues: mutedError (copy), s1 (copy), p3 (copy), SetShowAgeVerificationOverlay (copy), Promise (copy), Logging (copy)
			local responseBody = p4.responseBody
			local v21 = responseBody.voiceSettings ~= nil and responseBody.voiceSettings.isVoiceEnabled

			if responseBody.showAgeVerificationOverlay then
				mutedError(`showAgeVerificationOverlay is deprecated but was truthy for universe { s1 }`)
			end

			if responseBody ~= nil and responseBody.showAgeVerificationOverlay ~= nil and responseBody.universePlaceVoiceEnabledSettings ~= nil then
				local isPlaceEnabledForVoice = responseBody.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice
				local isUniverseEnabledForVoice = responseBody.universePlaceVoiceEnabledSettings.isUniverseEnabledForVoice
				local isUniverseEnabledForAvatarVideo = responseBody.universePlaceVoiceEnabledSettings.isUniverseEnabledForAvatarVideo

				p3:dispatch(SetShowAgeVerificationOverlay(s1, isPlaceEnabledForVoice, isUniverseEnabledForVoice, v21, responseBody.showVoiceOptInOverlay, isUniverseEnabledForAvatarVideo, responseBody.elegibleToSeeVoiceUpsell))

				return Promise.resolve(p4)
			end

			Logging.warn("Response from GetShowAgeVerificationOverlay is malformed!")

			return Promise.reject({
				HttpError = Enum.HttpError.OK
			})
		end)
	end)
end
function t1.GetFetchingStatus(p5, p6) -- line: 71
	-- upvalues: PerformFetch (copy)
	return PerformFetch.GetStatus(p5, "luaapp.showageverificationoverlay." .. p6)
end

return t1
