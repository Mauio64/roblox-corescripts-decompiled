local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local CrossExperience = require(SquadsParent.CrossExperience)
local CrossExperienceVoice = require(SquadsParent.CrossExperienceVoice)
local useLocalUserId = require(SquadsParent.RobloxAppHooks).useLocalUserId
local VoiceChat = require(SquadsParent.VoiceChat)
local useAppPolicy = require(SquadsParent.UniversalAppPolicy).useAppPolicy
local dependencies = require(Squads.dependencies)
local React = dependencies.React
local Foundation = dependencies.Foundation
local SharedFlags = dependencies.SharedFlags
local default = CrossExperienceVoice.CrossExperienceVoiceManager.default
local VoiceStatus = CrossExperience.Utils.VoiceStatus
local VoiceStatusChanged = CrossExperience.Actions.VoiceStatusChanged
local useVoiceStatus = CrossExperienceVoice.Hooks.useVoiceStatus
local useLocalization = dependencies.Hooks.useLocalization
local useDispatch = dependencies.Hooks.useDispatch
local useTokens = Foundation.Hooks.useTokens
local useNavigation = dependencies.useNavigation
local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local useCurrentSquadId = require(SquadsParent.SquadsCore.Hooks).useCurrentSquadId
local useCurrentSquadParentChannelId = require(SquadsParent.SquadsCore.Hooks).useCurrentSquadParentChannelId
local useStore = dependencies.Hooks.useStore
local SquadPromptType = require(SquadsParent.SquadsCore.Enums).SquadPromptType
local SquadExternalContractContext = require(SquadsParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local getFFlagEnableCrossExpVoiceMemoryCheck = SharedFlags.getFFlagEnableCrossExpVoiceMemoryCheck
local FFlagEnableVoiceEuConsentPrompt = SharedFlags.FFlagEnableVoiceEuConsentPrompt
local useIsAnyOtherUserPartyVoiceEligible = require(Squads.Hooks.useIsAnyOtherUserPartyVoiceEligible)
local useIsLocalPlayerPartyVoiceEligible = require(SquadsParent.SquadsCore.Hooks).useIsLocalPlayerPartyVoiceEligible
local useIsCurrentSquadPartyVoiceEligible = require(SquadsParent.SquadsCore.Hooks).useIsCurrentSquadPartyVoiceEligible
local SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY = require(SquadsParent.SquadsCore.Constants).SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY
local SQUAD_VOICE_EU_MODAL_SEEN_KEY = require(SquadsParent.SquadsCore.Constants).SQUAD_VOICE_EU_MODAL_SEEN_KEY
local getTableAppStorageKey = require(SquadsParent.SquadsCore.appStorageAccess).getTableAppStorageKey
local displayEuConsentPrompt = require(SquadsParent.SquadsCore.displayEuConsentPrompt)
local v37 = game:DefineFastString("PartyVoiceBannerErrorUserNotEligibleURL", "")
local v38 = game:DefineFastFlag("DisallowSquadLobbyBannersInlineButtons", false)
local v39 = game:DefineFastFlag("DisablePartyVoiceEligibilityBanner", false)

function openWebview(s1: string, s2: string) -- line: 67
	-- upvalues: HttpService (copy), GuiService (copy)
	local json = HttpService:JSONEncode({
		presentationStyle = 0,
		visible = true,
		title = if not game:GetEngineFeature("SetWebViewTitle") then nil else s1,
		url = s2
	})

	GuiService:BroadcastNotification(json, 20)
end

local function v40(t1: {[any]: any}) -- line: 80
	-- upvalues: useTokens (copy), v38 (copy), React (copy), Foundation (copy)
	local v50 = useTokens()
	local v51 = t1.isButtonInline and not v38
	local v52 = React.useMemo(function() -- line: 84
		-- upvalues: React (copy), Foundation (copy), v50 (copy), t1 (copy)
		local t2 = { React.createElement(Foundation.Text, {
			LayoutOrder = 1,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = v50.Color.None,
			colorstyle = v50.Color.Content.Emphasis,
			fontStyle = v50.Typography.BodySmall,
			Text = t1.label,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTruncate = Enum.TextTruncate.None
		}) }

		if t1.sublabels then
			for i, v in ipairs(t1.sublabels) do
				if v and v ~= "" then
					table.insert(t2, React.createElement(Foundation.Text, {
						TextWrapped = true,
						RichText = true,
						AutomaticSize = Enum.AutomaticSize.XY,
						backgroundStyle = v50.Color.None,
						colorstyle = v50.Color.Content.Emphasis,
						fontStyle = v50.Typography.BodySmall,
						LayoutOrder = i + 1,
						Text = v,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						TextTruncate = Enum.TextTruncate.None
					}))
				end
			end
		end

		return t2
	end, {
		t1.label,
		t1.sublabels
	})

	return React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundColor3 = v50.Color.Surface.Surface_200.Color3,
		BackgroundTransparency = v50.Color.Surface.Surface_200.Transparency,
		LayoutOrder = t1.LayoutOrder
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v50.Radius.Small)
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v50.Gap.XLarge),
			PaddingRight = UDim.new(0, v50.Gap.XLarge),
			PaddingTop = UDim.new(0, v50.Gap.Medium),
			PaddingBottom = UDim.new(0, v50.Gap.Medium)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = if not v51 then Enum.FillDirection.Vertical else Enum.FillDirection.Horizontal,
			Padding = if not v51 then UDim.new(0, v50.Gap.Medium) else UDim.new(0, v50.Gap.XSmall),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Wraps = not v51,
			HorizontalFlex = if not v51 then Enum.UIFlexAlignment.Fill else Enum.UIFlexAlignment.SpaceBetween,
			VerticalFlex = if not v51 then Enum.UIFlexAlignment.None else Enum.UIFlexAlignment.Fill
		}),
		TextFrame = React.createElement(Foundation.View, {
			tag = "col auto-xy gap-small wrap",
			LayoutOrder = 1
		}, v52),
		InlineButton = if not t1.onActivated or not v51 then nil else React.createElement(Foundation.Button, {
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			text = t1.buttonLabel,
			variant = Foundation.Enums.ButtonVariant.Link,
			onActivated = t1.onActivated
		}),
		BottomButton = if not t1.onActivated or v51 then nil else React.createElement(Foundation.Button, {
			LayoutOrder = 2,
			text = t1.buttonLabel,
			variant = Foundation.Enums.ButtonVariant.Standard,
			size = Foundation.Enums.ButtonSize.Small,
			onActivated = t1.onActivated,
			fillBehavior = Foundation.Enums.FillBehavior.Fill
		})
	})
end
local function v41(t3: {[any]: any}) -- line: 179
	-- upvalues: useLocalUserId (copy), useDispatch (copy), React (copy), SquadExternalContractContext (copy), getTableAppStorageKey (copy), SQUAD_VOICE_EU_MODAL_SEEN_KEY (copy), SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY (copy), HttpService (copy), default (copy), v40 (copy), displayEuConsentPrompt (copy)
	local v54 = useLocalUserId()
	local v55 = useDispatch()
	local v56 = React.useContext(SquadExternalContractContext)
	local v57, v58 = React.useState(false)
	local v59 = getTableAppStorageKey(SQUAD_VOICE_EU_MODAL_SEEN_KEY)
	local v60 = getTableAppStorageKey(SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY)

	React.useEffect(function() -- line: 188
		-- upvalues: v59 (copy), v54 (copy), v60 (copy), v58 (copy)
		if v59[tostring(v54)] and not v60[tostring(v54)] then
			v58(true)
		end
	end, {
		HttpService:JSONEncode(v59),
		HttpService:JSONEncode(v60)
	})
	React.useEffect(function() -- line: 195
		-- upvalues: default (copy), v58 (copy)
		local connection = default.VoiceEuModalConsented.Event:Connect(function() -- line: 196
			-- upvalues: v58 (copy)
			v58(false)
		end)
		local connection2 = default.VoiceEuModalRefused.Event:Connect(function() -- line: 201
			-- upvalues: v58 (copy)
			v58(true)
		end)

		return function() -- line: 205
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, {})

	if v57 then
		return (React.createElement(v40, {
			label = "Give consent to the voice recording policy in order to access voice chat.",
			buttonLabel = "Connect",
			isButtonInline = true,
			LayoutOrder = t3.LayoutOrder,
			onActivated = function() -- line: 217
				-- upvalues: v55 (copy), displayEuConsentPrompt (copy), v56 (copy), v54 (copy), v59 (copy), v60 (copy)
				v55(displayEuConsentPrompt(v56.setSquadPrompt, tostring(v54), v59, v60))
			end
		}))
	end

	return nil
end
local function v42(t4: {[any]: any}) -- line: 231
	-- upvalues: useDispatch (copy), useStore (copy), React (copy), SquadExternalContractContext (copy), useCurrentSquadId (copy), useVoiceStatus (copy), CrossExperience (copy), VoiceStatus (copy), useLocalization (copy), VoiceStatusChanged (copy), default (copy), getFFlagEnableCrossExpVoiceMemoryCheck (copy), SquadPromptType (copy), v40 (copy)
	local v62 = useDispatch()
	local v63 = useStore()
	local v64 = React.useContext(SquadExternalContractContext)
	local v65 = useCurrentSquadId() or ""
	local v66 = useVoiceStatus()
	local v67 = v66 == CrossExperience.Constants.VOICE_STATUS.ERROR_JOIN_FEASIBILITY_CHECK_FAILED
	local v68 = VoiceStatus.isVoiceRetriableErrorByGameJoin(v66) or VoiceStatus.isVoiceRetriableErrorByVoiceJoin(v66)
	local v69 = useLocalization({
		errorText = "Feature.Squads.Label.VoiceErrorGeneral",
		errorButton = "Feature.Squads.Action.VoiceErrorGeneral"
	})
	local v70 = React.useCallback(function() -- line: 246
		-- upvalues: v62 (copy), VoiceStatusChanged (copy), CrossExperience (copy), default (copy), v65 (copy), getFFlagEnableCrossExpVoiceMemoryCheck (copy), v67 (copy), v64 (copy), v63 (copy), SquadPromptType (copy), VoiceStatus (copy), v66 (copy)
		local function v105(b1: boolean?) -- line: 247
			-- upvalues: v62 (copy), VoiceStatusChanged (copy), CrossExperience (copy), default (copy), v65 (copy)
			v62(VoiceStatusChanged({
				status = CrossExperience.Constants.VOICE_STATUS.RCC_CONNECTING
			}))
			default:join({
				force = true,
				partyId = v65,
				shouldIgnoreMemoryWarning = b1
			})
		end

		if getFFlagEnableCrossExpVoiceMemoryCheck() and v67 then
			if default:performJoinFeasibilityCheck() then
				v105()

				return
			end

			v64.setSquadPrompt(v63, {
				hideCancelButton = false,
				promptType = SquadPromptType.ConnectVoiceWithLowMemory,
				onConfirm = function() -- line: 268
				end,
				onCancel = function() -- line: 269
					-- upvalues: v105 (copy)
					v105(true)
				end
			})

			return
		end

		if VoiceStatus.isVoiceRetriableErrorByGameJoin(v66) then
			if getFFlagEnableCrossExpVoiceMemoryCheck() then
				v105()

				return
			end

			v62(VoiceStatusChanged({
				status = CrossExperience.Constants.VOICE_STATUS.RCC_CONNECTING
			}))
			default:join({
				force = true,
				partyId = v65
			})

			return
		end

		if VoiceStatus.isVoiceRetriableErrorByVoiceJoin(v66) then
			default:rejoinVoice()
		end
	end, {
		v66,
		v65,
		v67
	})

	if getFFlagEnableCrossExpVoiceMemoryCheck() and v67 or v68 then
		return (React.createElement(v40, {
			isButtonInline = true,
			LayoutOrder = t4.LayoutOrder,
			label = v69.errorText,
			buttonLabel = v69.errorButton,
			onActivated = if v65 == "" then nil else v70
		}))
	end

	return nil
end
local function v43(t5: {[any]: any}) -- line: 309
	-- upvalues: useIsCurrentSquadPartyVoiceEligible (copy), useIsLocalPlayerPartyVoiceEligible (copy), useIsAnyOtherUserPartyVoiceEligible (copy), useLocalization (copy), useAppPolicy (copy), React (copy), v37 (copy), v40 (copy)
	local v72 = useIsCurrentSquadPartyVoiceEligible()
	local v73 = useIsLocalPlayerPartyVoiceEligible()
	local v74 = useIsAnyOtherUserPartyVoiceEligible()
	local v75 = useLocalization({
		errorText = "Feature.Squads.Label.VoiceErrorUserIneligible",
		errorButton = "Feature.Squads.Action.VoiceErrorUserIneligible"
	})
	local v76 = useAppPolicy(function(p1) -- line: 317
		return p1.getWebViewSupport()
	end)
	local v77 = v72 and (not v73 and v74)
	local v78 = React.useCallback(function() -- line: 325
		-- upvalues: v37 (copy), v75 (copy)
		if v37 ~= "" then
			openWebview(v75.errorButton, v37)
		end
	end, { v75.errorButton })

	if not v77 then
		return nil
	end

	return React.createElement(v40, {
		isButtonInline = false,
		LayoutOrder = t5.LayoutOrder,
		label = v75.errorText,
		buttonLabel = v75.errorButton,
		onActivated = if not v76 or v37 == "" then nil else v78
	})
end
local function v44(t6: {[any]: any}) -- line: 346
	-- upvalues: useVoiceStatus (copy), useCurrentSquadId (copy), React (copy), VoiceChat (copy), useAppPolicy (copy), useLocalization (copy), VoiceStatus (copy), v40 (copy)
	local v80 = useVoiceStatus()
	local v81 = useCurrentSquadId() or ""
	local v82 = React.useMemo(function() -- line: 349
		-- upvalues: VoiceChat (copy)
		return VoiceChat.Utils.GetSettingsAppAvailable()
	end, {})
	local v83 = useAppPolicy(function(p2) -- line: 353
		return p2
	end)
	local v84 = React.useMemo(function() -- line: 357
		-- upvalues: v82 (copy), v83 (copy)
		return ((if not v82 then v83.getMicSettingsDirectionsLocaleKey() else v83.getMicSettingsDeeplinkDirectionsLocaleKey())) or nil
	end, {
		v83,
		v82
	})
	local v85 = React.useMemo(function() -- line: 365
		-- upvalues: v83 (copy)
		if v83.getRequiresAppRestartOnMicAccessChange() then
			return "Feature.SettingsHub.Prompt.RestartOnMicAccessChange"
		end

		return nil
	end, {
		v83,
		v82
	})
	local v86 = useLocalization({
		errorText = "Feature.SettingsHub.Prompt.Subtitle.AllowMicrophoneAccess",
		errorButton = "Feature.SettingsHub.Action.OpenSettings",
		errorSubtext1 = v84,
		errorSubtext2 = v85
	})
	local v87 = VoiceStatus.isMicPermissionsError(v80)
	local v88 = React.useCallback(function() -- line: 383
		-- upvalues: VoiceChat (copy)
		pcall(function() -- line: 384
			-- upvalues: VoiceChat (copy)
			VoiceChat.Utils.SwitchToMicrophoneSettings()
		end)
	end, {})

	if v87 then
		return (React.createElement(v40, {
			isButtonInline = true,
			LayoutOrder = t6.LayoutOrder,
			label = v86.errorText,
			sublabels = {
				v86.errorSubtext1,
				v86.errorSubtext2
			},
			buttonLabel = v86.errorButton,
			onActivated = if v81 == "" or not v82 then nil else v88
		}))
	end

	return nil
end
local function v45(t7: {[any]: any}) -- line: 405
	-- upvalues: useNavigation (copy), useCurrentSquadParentChannelId (copy), useIsCurrentSquadPartyVoiceEligible (copy), useIsLocalPlayerPartyVoiceEligible (copy), useLocalization (copy), React (copy), v40 (copy)
	local v90 = useNavigation()
	local v91 = useCurrentSquadParentChannelId() or ""
	local v92 = useIsCurrentSquadPartyVoiceEligible()
	local v93 = useIsLocalPlayerPartyVoiceEligible()
	local v94 = v92 == false and v93
	local v95 = useLocalization({
		errorText = "Feature.Squads.Label.VoiceErrorPartyNotVoiceEligible",
		errorButton = "Feature.Squads.Action.VoiceErrorPartyNotVoiceEligible"
	})
	local v96 = React.useCallback(function() -- line: 416
		-- upvalues: v91 (copy), v90 (copy)
		if v91 ~= "" then
			pcall(function() -- line: 418
				-- upvalues: v90 (copy), v91 (copy)
				v90.navigate("CreateUnfilteredChatPartialModal", {
					conversationId = v91
				})
			end)
		end
	end, {
		v91,
		v90
	})

	if not v94 then
		return nil
	end

	return React.createElement(v40, {
		isButtonInline = false,
		LayoutOrder = t7.LayoutOrder,
		label = v95.errorText,
		buttonLabel = v95.errorButton,
		onActivated = v96
	})
end

return function(t8: {[any]: any}) -- line: 443
	-- upvalues: useTokens (copy), React (copy), GetFFlagEnableCrossExpVoice (copy), v42 (copy), v39 (copy), v45 (copy), v43 (copy), v44 (copy), FFlagEnableVoiceEuConsentPrompt (copy), v41 (copy)
	local v98 = useTokens()
	local v99 = React.useCallback(function(p3) -- line: 445
		-- upvalues: t8 (copy)
		if p3 then
			t8.onAbsoluteSizeChanged(p3.AbsoluteSize)
		end
	end, { t8.onAbsoluteSizeChanged })

	return React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = v99
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v98.Padding.XLarge),
			PaddingRight = UDim.new(0, v98.Padding.XLarge)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v98.Gap.Medium)
		}),
		VoiceErrorBanner = if not GetFFlagEnableCrossExpVoice() then nil else React.createElement(v42, {
			LayoutOrder = 1
		}),
		PartyVoiceEligibilityBanner = if not GetFFlagEnableCrossExpVoice() or v39 then nil else React.createElement(v45, {
			LayoutOrder = 2
		}),
		PartyVoiceUserEligibilityBanner = if not GetFFlagEnableCrossExpVoice() then nil else React.createElement(v43, {
			LayoutOrder = 3
		}),
		VoiceMicPermissionsBanner = if not GetFFlagEnableCrossExpVoice() then nil else React.createElement(v44, {
			LayoutOrder = 4
		}),
		VoiceEuModalConnectBanner = if not GetFFlagEnableCrossExpVoice() or not FFlagEnableVoiceEuConsentPrompt then nil else React.createElement(v41, {
			LayoutOrder = 5
		})
	})
end
