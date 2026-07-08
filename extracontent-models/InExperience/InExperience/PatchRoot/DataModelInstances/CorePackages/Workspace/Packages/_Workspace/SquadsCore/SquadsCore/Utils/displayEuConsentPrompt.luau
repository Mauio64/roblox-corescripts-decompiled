local HttpService = game:GetService("HttpService")
local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local default = require(SquadsCoreParent.CrossExperienceVoice).CrossExperienceVoiceManager.default
local SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY = require(SquadsCore.Common.Constants).SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY
local SQUAD_VOICE_EU_MODAL_SEEN_KEY = require(SquadsCore.Common.Constants).SQUAD_VOICE_EU_MODAL_SEEN_KEY
local SquadPromptType = require(SquadsCore.Enums.SquadPromptType)
local setTableAppStorageKey = require(SquadsCore.Utils.appStorageAccess).setTableAppStorageKey

return function(p1: ((...any) -> ...any), s1: string, t1: {[any]: any}, t2: {[any]: any}) -- line: 13
	-- upvalues: SquadPromptType (copy), setTableAppStorageKey (copy), SQUAD_VOICE_EU_MODAL_SEEN_KEY (copy), HttpService (copy), SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY (copy), default (copy)
	return function(p2) -- line: 19
		-- upvalues: p1 (copy), SquadPromptType (copy), t1 (copy), s1 (copy), t2 (copy), setTableAppStorageKey (copy), SQUAD_VOICE_EU_MODAL_SEEN_KEY (copy), HttpService (copy), SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY (copy), default (copy)
		p1(p2, {
			promptType = SquadPromptType.EuVoiceConsentPrompt,
			onConfirm = function() -- line: 22
				-- upvalues: t1 (copy), s1 (copy), t2 (copy), setTableAppStorageKey (copy), SQUAD_VOICE_EU_MODAL_SEEN_KEY (copy), HttpService (copy), SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY (copy), default (copy)
				t1[s1] = true
				t2[s1] = true
				setTableAppStorageKey(SQUAD_VOICE_EU_MODAL_SEEN_KEY, HttpService:JSONEncode(t1))
				setTableAppStorageKey(SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY, HttpService:JSONEncode(t2))
				default.default.VoiceEuModalConsented:Fire()
			end,
			onCancel = function() -- line: 32
				-- upvalues: t1 (copy), s1 (copy), setTableAppStorageKey (copy), SQUAD_VOICE_EU_MODAL_SEEN_KEY (copy), HttpService (copy), default (copy)
				t1[s1] = true
				setTableAppStorageKey(SQUAD_VOICE_EU_MODAL_SEEN_KEY, HttpService:JSONEncode(t1))
				default.default.VoiceEuModalRefused:Fire()
			end
		})
	end
end
