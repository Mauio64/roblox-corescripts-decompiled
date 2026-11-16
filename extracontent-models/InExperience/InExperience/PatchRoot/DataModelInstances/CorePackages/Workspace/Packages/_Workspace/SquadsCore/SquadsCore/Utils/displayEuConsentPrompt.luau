local HttpService = game:GetService("HttpService")
local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local CrossExperienceVoice = require(parent.CrossExperienceVoice)
local default = CrossExperienceVoice.CrossExperienceVoiceManager.default

local Constants = require(SquadsCore.Common.Constants)
local SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY = Constants.SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY
local Constants2 = require(SquadsCore.Common.Constants)
local SQUAD_VOICE_EU_MODAL_SEEN_KEY = Constants2.SQUAD_VOICE_EU_MODAL_SEEN_KEY
local SquadPromptType = require(SquadsCore.Enums.SquadPromptType)
local appStorageAccess = require(SquadsCore.Utils.appStorageAccess)
local setTableAppStorageKey = appStorageAccess.setTableAppStorageKey

return function(callback, p: string, p2, p3)
	return function(p4)
		callback(p4, {
			promptType = SquadPromptType.EuVoiceConsentPrompt,
			onConfirm = function()
				p2[p] = true
				p3[p] = true
				setTableAppStorageKey(SQUAD_VOICE_EU_MODAL_SEEN_KEY, HttpService:JSONEncode(p2))
				setTableAppStorageKey(SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY, HttpService:JSONEncode(p3))

				default.default.VoiceEuModalConsented:Fire()
			end,
			onCancel = function()
				p2[p] = true
				setTableAppStorageKey(SQUAD_VOICE_EU_MODAL_SEEN_KEY, HttpService:JSONEncode(p2))
				default.default.VoiceEuModalRefused:Fire()
			end
		})
	end
end
