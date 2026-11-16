local HttpService = game:GetService("HttpService")

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/CrossExperienceVoice").CrossExperienceVoiceManager.default

local SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants").SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY
local SQUAD_VOICE_EU_MODAL_SEEN_KEY = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants").SQUAD_VOICE_EU_MODAL_SEEN_KEY
local SquadPromptType = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadPromptType")
local setTableAppStorageKey = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Utils/appStorageAccess").setTableAppStorageKey

return function(callback, p2, p3, p4)
	return function(p5)
		callback(p5, {
			promptType = SquadPromptType.EuVoiceConsentPrompt,
			onConfirm = function()
				p3[p2] = true
				p4[p2] = true
				setTableAppStorageKey(SQUAD_VOICE_EU_MODAL_SEEN_KEY, HttpService:JSONEncode(p3))
				setTableAppStorageKey(SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY, HttpService:JSONEncode(p4))

				default.default.VoiceEuModalConsented:Fire()
			end,
			onCancel = function()
				p3[p2] = true
				setTableAppStorageKey(SQUAD_VOICE_EU_MODAL_SEEN_KEY, HttpService:JSONEncode(p3))
				default.default.VoiceEuModalRefused:Fire()
			end
		})
	end
end
