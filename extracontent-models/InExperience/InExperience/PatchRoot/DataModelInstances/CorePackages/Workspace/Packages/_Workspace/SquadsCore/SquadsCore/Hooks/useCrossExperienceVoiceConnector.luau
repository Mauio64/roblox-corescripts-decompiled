local Players = game:GetService("Players")
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local useCurrentSquadMember = require(script.Parent.useCurrentSquadMember)
local useIsLocalPlayerPartyVoiceEligible = require(script.Parent.useIsLocalPlayerPartyVoiceEligible)
local useIsCurrentSquadPartyVoiceEligible = require(script.Parent.useIsCurrentSquadPartyVoiceEligible)

local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local SquadPromptType = require(SquadsCore.Enums.SquadPromptType)
local displayEuConsentPrompt = require(SquadsCore.Utils.displayEuConsentPrompt)
local appStorageAccess = require(SquadsCore.Utils.appStorageAccess)
local getTableAppStorageKey = appStorageAccess.getTableAppStorageKey
local useCurrentSquadId = require(SquadsCore.Hooks.useCurrentSquadId)

local CrossExperienceVoice = require(parent.CrossExperienceVoice)
local LuauPolyfill = require(parent.LuauPolyfill)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useStore = RoactUtils2.Hooks.RoactRodux.useStore
local SharedFlags = require(parent.SharedFlags)
local getFFlagEnableCrossExpVoiceMemoryCheck = SharedFlags.getFFlagEnableCrossExpVoiceMemoryCheck
local FFlagEnableVoiceEuConsentPrompt = SharedFlags.FFlagEnableVoiceEuConsentPrompt

local clearInterval = LuauPolyfill.clearInterval
local setInterval = LuauPolyfill.setInterval

local default = CrossExperienceVoice.CrossExperienceVoiceManager.default
local useIsBackgroundDMActive = CrossExperienceVoice.Hooks.useIsBackgroundDMActive
local useIsVoiceRetriableError = CrossExperienceVoice.Hooks.useIsVoiceRetriableError

local Constants = require(SquadsCore.Common.Constants)
local SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY = Constants.SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY
local Constants2 = require(SquadsCore.Common.Constants)
local SQUAD_VOICE_EU_MODAL_SEEN_KEY = Constants2.SQUAD_VOICE_EU_MODAL_SEEN_KEY

local defineFastFlag = game:DefineFastFlag("EnableDisconnectPartyVoiceIfNeeded", false)
local defineFastFlag2 = game:DefineFastFlag("EnablePartyVoiceRestrictionStatus", false)
local defineFastInt = game:DefineFastInt("PartyVoiceRestrictionStatusMaxAttempts", 10)

function useCrossExperienceVoiceConnector()
	local userId = Players and Players.LocalPlayer and Players.LocalPlayer.UserId or 0
	local v = useCurrentSquadId() or ""
	local v2 = useCurrentSquadMember(userId)
	local v3 = useDispatch()
	local v4 = React.useContext(SquadExternalContractContext)
	local v5 = useStore()
	local ref = React.useRef(nil)

	local v6 = useIsCurrentSquadPartyVoiceEligible()
	local v7 = useIsBackgroundDMActive()

	local v8, v9 = useIsLocalPlayerPartyVoiceEligible()

	local v10 = useIsVoiceRetriableError()
	local state, setState

	if defineFastFlag2 then
		local useState = React.useState
		local v11

		if ThirdPartyUserService and ThirdPartyUserService:IsChatRestrictionSupported() then
			v11 = ThirdPartyUserService:GetVoiceChatRestrictionStatus()
		else
			v11 = Enum.ChatRestrictionStatus.NotRestricted
		end

		state, setState = useState(v11)
	else
		state = nil
		setState = nil
	end

	local state2, setState2 = React.useState(false)
	local v11

	if v then
		if v == "" then
			v11 = false
		else
			v11 = v2
				and not v7
				and v6
				and v8
				and not v10
				and (not defineFastFlag2 or state == Enum.ChatRestrictionStatus.NotRestricted)
		end
	else
		v11 = v
	end

	if defineFastFlag then
		if not v or v == "" or not v2 or v6 == false or not (v9 or v8) or v10 then
			v10 = v7
		end
	else
		v10 = false
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
			local v12 = setInterval(function()
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
				clearInterval(v12)
			end
		end, { state })
	end

	React.useEffect(function()
		if
			FFlagEnableVoiceEuConsentPrompt
			and v11
			and getTableAppStorageKey(SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY)[tostring(userId)]
		then
			setState2(true)
		end
	end, { userId, v11 })

	React.useEffect(function()
		if FFlagEnableVoiceEuConsentPrompt and v11 then
			local v12 = tostring(userId)
			local tableAppStorageKey = getTableAppStorageKey(SQUAD_VOICE_EU_MODAL_SEEN_KEY)

			if not tableAppStorageKey[v12] then
				local tableAppStorageKey2 = getTableAppStorageKey(SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY)
				v3(displayEuConsentPrompt(v4.setSquadPrompt, v12, tableAppStorageKey, tableAppStorageKey2))
			end
		end
	end, { userId, displayEuConsentPrompt, v11, v4.setSquadPrompt })

	React.useEffect(function()
		if not FFlagEnableVoiceEuConsentPrompt then
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
		if v7 then
			default:setAsConnected()
		else
			default:setAsDisconnected()
		end
	end, { v7 })

	local v12 = React.useCallback(function(partyId: string, force: boolean?, shouldIgnoreMemoryWarning: boolean?)
		default:join({
			partyId = partyId,
			force = force,
			shouldIgnoreMemoryWarning = shouldIgnoreMemoryWarning
		})
	end, {})

	local useEffect = React.useEffect
	local function fn()
		if not v11 or FFlagEnableVoiceEuConsentPrompt and not state2 then
			return
		end

		if default:performJoinFeasibilityCheck() then
			v12(v)
		else
			v4.setSquadPrompt(v5, {
				hideCancelButton = false,
				promptType = SquadPromptType.JoinWithLowMemory,
				onConfirm = function() end,
				onCancel = function()
					v12(v, true, true)
				end
			})
		end
	end

	local v13

	if FFlagEnableVoiceEuConsentPrompt then
		v13 = state2
	end

	useEffect(fn, { v11, v13 })

	local v14 = React.useCallback(function()
		default:leave()
	end, {})

	React.useEffect(function()
		if defineFastFlag and v10 then
			v14()
		end
	end, { v10, v14 })

	React.useEffect(function()
		if not getFFlagEnableCrossExpVoiceMemoryCheck() then
			return function() end
		end

		local function fn2() -- 2 equivalent calls inferred from this helper
			if ref.current then
				ref.current:Disconnect()
				ref.current = nil
			end
		end

		ref.current = default.MemoryLow.Event:Connect(function()
			fn2() -- inferred equivalent call
			v4.setSquadPrompt(v5, {
				hideCancelButton = false,
				promptType = SquadPromptType.DisconnectVoiceDueToLowMemory,
				onConfirm = function()
					v14()
				end
			})
		end)
		return function()
			fn2() -- inferred equivalent call
		end
	end)

	return v14
end

return useCrossExperienceVoiceConnector
