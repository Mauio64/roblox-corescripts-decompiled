local Players = game:GetService("Players")
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local useCurrentSquadMember = require(script.Parent.useCurrentSquadMember)
local useIsLocalPlayerPartyVoiceEligible = require(script.Parent.useIsLocalPlayerPartyVoiceEligible)
local useIsCurrentSquadPartyVoiceEligible = require(script.Parent.useIsCurrentSquadPartyVoiceEligible)
local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local SquadPromptType = require(SquadsCore.Enums.SquadPromptType)
local displayEuConsentPrompt = require(SquadsCore.Utils.displayEuConsentPrompt)
local getTableAppStorageKey = require(SquadsCore.Utils.appStorageAccess).getTableAppStorageKey
local useCurrentSquadId = require(SquadsCore.Hooks.useCurrentSquadId)
local CrossExperienceVoice = require(SquadsCoreParent.CrossExperienceVoice)
local LuauPolyfill = require(SquadsCoreParent.LuauPolyfill)
local React = require(SquadsCoreParent.React)
local useDispatch = require(SquadsCoreParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useStore = require(SquadsCoreParent.RoactUtils).Hooks.RoactRodux.useStore
local SharedFlags = require(SquadsCoreParent.SharedFlags)
local getFFlagEnableCrossExpVoiceMemoryCheck = SharedFlags.getFFlagEnableCrossExpVoiceMemoryCheck
local FFlagEnableVoiceEuConsentPrompt = SharedFlags.FFlagEnableVoiceEuConsentPrompt
local clearInterval = LuauPolyfill.clearInterval
local setInterval = LuauPolyfill.setInterval
local default = CrossExperienceVoice.CrossExperienceVoiceManager.default
local useIsBackgroundDMActive = CrossExperienceVoice.Hooks.useIsBackgroundDMActive
local useIsVoiceRetriableError = CrossExperienceVoice.Hooks.useIsVoiceRetriableError
local SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY = require(SquadsCore.Common.Constants).SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY
local SQUAD_VOICE_EU_MODAL_SEEN_KEY = require(SquadsCore.Common.Constants).SQUAD_VOICE_EU_MODAL_SEEN_KEY
local v28 = game:DefineFastFlag("EnableDisconnectPartyVoiceIfNeeded", false)
local v29 = game:DefineFastFlag("EnablePartyVoiceRestrictionStatus", false)
local v30 = game:DefineFastInt("PartyVoiceRestrictionStatusMaxAttempts", 10)

function useCrossExperienceVoiceConnector() -- line: 43
	-- upvalues: Players (copy), useCurrentSquadId (copy), useCurrentSquadMember (copy), useDispatch (copy), React (copy), SquadExternalContractContext (copy), useStore (copy), useIsCurrentSquadPartyVoiceEligible (copy), useIsBackgroundDMActive (copy), useIsLocalPlayerPartyVoiceEligible (copy), useIsVoiceRetriableError (copy), v29 (copy), ThirdPartyUserService (copy), v28 (copy), v30 (copy), setInterval (copy), clearInterval (copy), FFlagEnableVoiceEuConsentPrompt (copy), getTableAppStorageKey (copy), SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY (copy), SQUAD_VOICE_EU_MODAL_SEEN_KEY (copy), displayEuConsentPrompt (copy), default (copy), SquadPromptType (copy), getFFlagEnableCrossExpVoiceMemoryCheck (copy)
	local v31 = Players and (not not Players.LocalPlayer and Players.LocalPlayer.UserId) or 0
	local v32 = useCurrentSquadId() or ""
	local v33 = useCurrentSquadMember(v31)
	local v34 = useDispatch()
	local v35 = React.useContext(SquadExternalContractContext)
	local v36 = useStore()
	local v37 = React.useRef(nil)
	local v38 = useIsCurrentSquadPartyVoiceEligible()
	local v39 = useIsBackgroundDMActive()
	local v40, v41 = useIsLocalPlayerPartyVoiceEligible()
	local v42 = useIsVoiceRetriableError()
	local u43 = nil
	local u44 = nil

	if v29 then
		local v45, v46 = React.useState(if not ThirdPartyUserService or not ThirdPartyUserService:IsChatRestrictionSupported() then Enum.ChatRestrictionStatus.NotRestricted else ThirdPartyUserService:GetVoiceChatRestrictionStatus())

		u43 = v45
		u44 = v46
	end

	local v47, v48 = React.useState(false)
	local v49 = v32 and (v32 ~= "" and (v33 and (not v39 and (v38 and (v40 and (not v42 and (not v29 or u43 == Enum.ChatRestrictionStatus.NotRestricted)))))))
	local v50 = not not v28 and ((not v32 or (v32 == "" or (not v33 or (v38 == false or (not v41 and not v40 or v42))))) and v39)

	if v29 then
		React.useEffect(function() -- line: 92
			-- upvalues: u43 (ref), ThirdPartyUserService (copy), u44 (ref), v30 (copy), setInterval (copy), clearInterval (copy)
			if u43 ~= Enum.ChatRestrictionStatus.Unknown then
				return
			end

			if not ThirdPartyUserService or not ThirdPartyUserService:IsChatRestrictionSupported() then
				u44(Enum.ChatRestrictionStatus.NotRestricted)

				return
			end

			local n1 = 0
			local v54 = setInterval(function() -- line: 103
				-- upvalues: n1 (ref), ThirdPartyUserService (copy), u44 (ref), v30 (copy)
				n1 += 1

				local VoiceChatRestrictionStatus = ThirdPartyUserService:GetVoiceChatRestrictionStatus()

				if VoiceChatRestrictionStatus == Enum.ChatRestrictionStatus.NotRestricted or VoiceChatRestrictionStatus == Enum.ChatRestrictionStatus.Restricted then
					u44(VoiceChatRestrictionStatus)

					return
				end

				if n1 >= v30 then
					u44(Enum.ChatRestrictionStatus.Restricted)
				end
			end, 4000)

			n1 += 1

			local VoiceChatRestrictionStatus = ThirdPartyUserService:GetVoiceChatRestrictionStatus()

			if VoiceChatRestrictionStatus == Enum.ChatRestrictionStatus.NotRestricted or VoiceChatRestrictionStatus == Enum.ChatRestrictionStatus.Restricted then
				u44(VoiceChatRestrictionStatus)
			elseif v30 <= n1 then
				u44(Enum.ChatRestrictionStatus.Restricted)
			end

			return function() -- line: 120
				-- upvalues: clearInterval (copy), v54 (copy)
				clearInterval(v54)
			end
		end, { u43 })
	end

	React.useEffect(function() -- line: 127
		-- upvalues: FFlagEnableVoiceEuConsentPrompt (copy), v49 (copy), getTableAppStorageKey (copy), SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY (copy), v31 (copy), v48 (copy)
		if FFlagEnableVoiceEuConsentPrompt and (v49 and getTableAppStorageKey(SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY)[tostring(v31)]) then
			v48(true)
		end
	end, {
		v31,
		v49
	})
	React.useEffect(function() -- line: 138
		-- upvalues: FFlagEnableVoiceEuConsentPrompt (copy), v49 (copy), v31 (copy), getTableAppStorageKey (copy), SQUAD_VOICE_EU_MODAL_SEEN_KEY (copy), SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY (copy), v34 (copy), displayEuConsentPrompt (copy), v35 (copy)
		if FFlagEnableVoiceEuConsentPrompt and v49 then
			local str = tostring(v31)
			local v57 = getTableAppStorageKey(SQUAD_VOICE_EU_MODAL_SEEN_KEY)

			if not v57[str] then
				local v58 = getTableAppStorageKey(SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY)

				v34(displayEuConsentPrompt(v35.setSquadPrompt, str, v57, v58))
			end
		end
	end, {
		v31,
		displayEuConsentPrompt,
		v49,
		v35.setSquadPrompt
	})
	React.useEffect(function() -- line: 161
		-- upvalues: FFlagEnableVoiceEuConsentPrompt (copy), default (copy), v48 (copy)
		if FFlagEnableVoiceEuConsentPrompt then
			local connection = default.VoiceEuModalConsented.Event:Connect(function() -- line: 164
				-- upvalues: v48 (copy)
				v48(true)
			end)

			return function() -- line: 168
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end

		return function() -- line: 172
		end
	end, {})
	React.useEffect(function() -- line: 175
		-- upvalues: v39 (copy), default (copy)
		if v39 then
			default:setAsConnected()

			return
		end

		default:setAsDisconnected()
	end, { v39 })

	local v51 = React.useCallback(function(s1: string, b1: boolean?, b2: boolean?) -- line: 183
		-- upvalues: default (copy)
		default:join({
			partyId = s1,
			force = b1,
			shouldIgnoreMemoryWarning = b2
		})
	end, {})

	React.useEffect(function() -- line: 192
		-- upvalues: v49 (copy), FFlagEnableVoiceEuConsentPrompt (copy), v47 (copy), default (copy), v51 (copy), v32 (copy), v35 (copy), v36 (copy), SquadPromptType (copy)
		if not v49 or FFlagEnableVoiceEuConsentPrompt and not v47 then
			return
		end

		if default:performJoinFeasibilityCheck() then
			v51(v32)

			return
		end

		v35.setSquadPrompt(v36, {
			hideCancelButton = false,
			promptType = SquadPromptType.JoinWithLowMemory,
			onConfirm = function() -- line: 205
			end,
			onCancel = function() -- line: 206
				-- upvalues: v51 (copy), v32 (copy)
				v51(v32, true, true)
			end
		})
	end, {
		v49,
		if not FFlagEnableVoiceEuConsentPrompt then nil else v47
	})

	local v52 = React.useCallback(function() -- line: 215
		-- upvalues: default (copy)
		default:leave()
	end, {})

	React.useEffect(function() -- line: 219
		-- upvalues: v28 (copy), v50 (copy), v52 (copy)
		if v28 and v50 then
			v52()
		end
	end, {
		v50,
		v52
	})
	React.useEffect(function() -- line: 226
		-- upvalues: getFFlagEnableCrossExpVoiceMemoryCheck (copy), v37 (copy), default (copy), v35 (copy), v36 (copy), SquadPromptType (copy), v52 (copy)
		if not getFFlagEnableCrossExpVoiceMemoryCheck() then
			return function() -- line: 228
			end
		end

		v37.current = default.MemoryLow.Event:Connect(function() -- line: 238
			-- upvalues: v37 (copy), v35 (copy), v36 (copy), SquadPromptType (copy), v52 (copy)
			if v37.current then
				v37.current:Disconnect()
				v37.current = nil
			end

			v35.setSquadPrompt(v36, {
				hideCancelButton = false,
				promptType = SquadPromptType.DisconnectVoiceDueToLowMemory,
				onConfirm = function() -- line: 245
					-- upvalues: v52 (copy)
					v52()
				end
			})
		end)

		return function() -- line: 250
			-- upvalues: v37 (copy)
			if v37.current then
				v37.current:Disconnect()
				v37.current = nil
			end
		end
	end)

	return v52
end

return useCrossExperienceVoiceConnector
