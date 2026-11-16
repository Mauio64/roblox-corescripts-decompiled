local Players = game:GetService("Players")
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local useCurrentSquadMember = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Hooks/useCurrentSquadMember")
local useIsLocalPlayerPartyVoiceEligible = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Hooks/useIsLocalPlayerPartyVoiceEligible")
local useIsCurrentSquadPartyVoiceEligible = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Hooks/useIsCurrentSquadPartyVoiceEligible")

local SquadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadExternalContractContext")
local SquadPromptType = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadPromptType")
local displayEuConsentPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Utils/displayEuConsentPrompt")
local getTableAppStorageKey = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Utils/appStorageAccess").getTableAppStorageKey
local useCurrentSquadId = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Hooks/useCurrentSquadId")

local CrossExperienceVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/CrossExperienceVoice")
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/LuauPolyfill")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useDispatch
local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useStore
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SharedFlags")
local getFFlagEnableCrossExpVoiceMemoryCheck = SharedFlags.getFFlagEnableCrossExpVoiceMemoryCheck
local fFlagEnableVoiceEuConsentPrompt = SharedFlags.FFlagEnableVoiceEuConsentPrompt

local clearInterval = LuauPolyfill.clearInterval
local setInterval = LuauPolyfill.setInterval

local default = CrossExperienceVoice.CrossExperienceVoiceManager.default
local useIsBackgroundDMActive = CrossExperienceVoice.Hooks.useIsBackgroundDMActive
local useIsVoiceRetriableError = CrossExperienceVoice.Hooks.useIsVoiceRetriableError

local SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants").SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY
local SQUAD_VOICE_EU_MODAL_SEEN_KEY = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants").SQUAD_VOICE_EU_MODAL_SEEN_KEY

local defineFastFlag = game:DefineFastFlag("EnableDisconnectPartyVoiceIfNeeded", false)
local defineFastFlag2 = game:DefineFastFlag("EnablePartyVoiceRestrictionStatus", false)
local defineFastInt = game:DefineFastInt("PartyVoiceRestrictionStatusMaxAttempts", 10)

function LUAUFORGE_MODULE_GLOBALS_hbb_useCrossExperienceVoiceConnector()
	local userId = Players and Players.LocalPlayer and Players.LocalPlayer.UserId or 0
	local v5 = useCurrentSquadId() or ""
	local v6 = useCurrentSquadMember(userId)
	local v7 = useDispatch()
	local v8 = React.useContext(SquadExternalContractContext)
	local v9 = useStore()
	local ref = React.useRef(nil)

	local v10 = useIsCurrentSquadPartyVoiceEligible()
	local v11 = useIsBackgroundDMActive()

	local v12, v13 = useIsLocalPlayerPartyVoiceEligible()

	local v14 = useIsVoiceRetriableError()
	local state, setState

	if defineFastFlag2 then
		local useState = React.useState
		local v15

		if ThirdPartyUserService and ThirdPartyUserService:IsChatRestrictionSupported() then
			v15 = ThirdPartyUserService:GetVoiceChatRestrictionStatus()
		else
			v15 = Enum.ChatRestrictionStatus.NotRestricted
		end

		state, setState = useState(v15)
	else
		state = nil
		setState = nil
	end

	local state2, setState2 = React.useState(false)
	local v15

	if v5 then
		if v5 == "" then
			v15 = false
		else
			v15 = v6
				and not v11
				and v10
				and v12
				and not v14
				and (not defineFastFlag2 or state == Enum.ChatRestrictionStatus.NotRestricted)
		end
	else
		v15 = v5
	end

	if defineFastFlag then
		if not v5 or v5 == "" or not v6 or v10 == false or not (v13 or v12) or v14 then
			v14 = v11
		end
	else
		v14 = false
	end

	if defineFastFlag2 then
		React.useEffect(function()
			if state ~= Enum.ChatRestrictionStatus.Unknown then
				return
			end

			if not (ThirdPartyUserService and ThirdPartyUserService:IsChatRestrictionSupported()) then
				setState(Enum.ChatRestrictionStatus.NotRestricted)
				return
			end

			local count = 0
			local v16 = setInterval(function()
				count += 1
				local voiceChatRestrictionStatus = ThirdPartyUserService:GetVoiceChatRestrictionStatus()

				if
					voiceChatRestrictionStatus == Enum.ChatRestrictionStatus.NotRestricted
					or voiceChatRestrictionStatus == Enum.ChatRestrictionStatus.Restricted
				then
					setState(voiceChatRestrictionStatus)
				elseif defineFastInt <= count then
					setState(Enum.ChatRestrictionStatus.Restricted)
				end
			end, 4000)
			count += 1
			local voiceChatRestrictionStatus = ThirdPartyUserService:GetVoiceChatRestrictionStatus()

			if
				voiceChatRestrictionStatus == Enum.ChatRestrictionStatus.NotRestricted
				or voiceChatRestrictionStatus == Enum.ChatRestrictionStatus.Restricted
			then
				setState(voiceChatRestrictionStatus)
			elseif defineFastInt <= count then
				setState(Enum.ChatRestrictionStatus.Restricted)
			end

			return function()
				clearInterval(v16)
			end
		end, { state })
	end

	React.useEffect(function()
		if
			fFlagEnableVoiceEuConsentPrompt
			and v15
			and getTableAppStorageKey(SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY)[tostring(userId)]
		then
			setState2(true)
		end
	end, { userId, v15 })

	React.useEffect(function()
		if fFlagEnableVoiceEuConsentPrompt and v15 then
			local v16 = tostring(userId)
			local tableAppStorageKey = getTableAppStorageKey(SQUAD_VOICE_EU_MODAL_SEEN_KEY)

			if not tableAppStorageKey[v16] then
				local tableAppStorageKey2 = getTableAppStorageKey(SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY)
				v7(displayEuConsentPrompt(v8.setSquadPrompt, v16, tableAppStorageKey, tableAppStorageKey2))
			end
		end
	end, { userId, displayEuConsentPrompt, v15, v8.setSquadPrompt })

	React.useEffect(function()
		if not fFlagEnableVoiceEuConsentPrompt then
			return function() end
		end

		local eventConnection = default.VoiceEuModalConsented.Event:Connect(function()
			setState2(true)
		end)

		return function()
			eventConnection:Disconnect()
		end
	end, {})

	React.useEffect(function()
		if v11 then
			default:setAsConnected()
		else
			default:setAsDisconnected()
		end
	end, { v11 })

	local v16 = React.useCallback(function(p2, p3, p4)
		default:join({ partyId = p2, force = p3, shouldIgnoreMemoryWarning = p4 })
	end, {})

	local function fn()
		if not v15 or fFlagEnableVoiceEuConsentPrompt and not state2 then
			return
		end

		if default:performJoinFeasibilityCheck() then
			v16(v5)
		else
			v8.setSquadPrompt(v9, {
				hideCancelButton = false,
				promptType = SquadPromptType.JoinWithLowMemory,
				onConfirm = function() end,
				onCancel = function()
					v16(v5, true, true)
				end
			})
		end
	end

	React.useEffect(fn, { v15, if fFlagEnableVoiceEuConsentPrompt then state2 else nil })

	local v19 = React.useCallback(function()
		default:leave()
	end, {})

	React.useEffect(function()
		if defineFastFlag and v14 then
			v19()
		end
	end, { v14, v19 })

	React.useEffect(function()
		if not getFFlagEnableCrossExpVoiceMemoryCheck() then
			return function() end
		end

		ref.current = default.MemoryLow.Event:Connect(function()
			if ref.current then
				ref.current:Disconnect()
				ref.current = nil
			end

			v8.setSquadPrompt(v9, {
				hideCancelButton = false,
				promptType = SquadPromptType.DisconnectVoiceDueToLowMemory,
				onConfirm = function()
					v19()
				end
			})
		end)
		return function()
			if ref.current then
				ref.current:Disconnect()
				ref.current = nil
			end
		end
	end)

	return v19
end

return LUAUFORGE_MODULE_GLOBALS_hbb_useCrossExperienceVoiceConnector
