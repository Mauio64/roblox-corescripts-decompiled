local HttpService = game:GetService("HttpService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local LuaAppNavigationContext = require(AppChat.LuaAppNavigationContext)
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local memo = React.memo
local useAnalytics = require(AppChat.Analytics.useAnalytics)
local useCallback = React.useCallback
local useContext = React.useContext
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useEffectOnMount = require(AppChatParent.RoactUtils).Hooks.useEffectOnMount
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local useNavigation = require(AppChatParent.Navigation).useNavigation
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local useState = React.useState
local useRef = React.useRef
local useIsGuiInChatVisible = require(AppChat.Hooks.useIsGuiInChatVisible)
local useRecordModalSeenWithDelay = require(AppChat.Hooks.useRecordModalSeenWithDelay)
local ChatLandingModalTelemetry = require(script.Parent.ChatLandingModalTelemetry)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local ModalTelemetry = require(AppChat.Components.ModalTelemetry)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local Enum2 = require(AppChatParent.UIBlox).App.Button.Enum
local SocialUpsell = require(AppChatParent.SocialUpsell)
local AccessResponseEnum = require(AppChatParent.AmpUpsell).AmpEnums.AccessResponseEnum
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local ChatLandingModalVariant = AppChatNetworking.Constants.ChatLandingModalVariant
local AppPage = require(AppChatParent.RobloxAppEnums).AppPage
local NavigateBack = require(AppChatParent.NavigationRodux).Thunks.NavigateBack
local NavigateDown = require(AppChatParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(AppChatParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v35 = if not FFlagSignalsNavP3Dispatch then nil else require(AppChatParent.RobloxAppNavigation).NavigationCommands
local refreshAllUnfilteredThreadsDetails = require(AppChat.Conversations.Thunks.refreshAllUnfilteredThreadsDetails)
local UnfilteredThreadsAMPFeatureName = require(AppChat.Components.UnfilteredThreadsAMPFeatureName)
local OpenTcLearnMoreLink = require(AppChat.Conversations.Thunks.OpenTcLearnMoreLink)
local ModalConfiguration = require(AppChat.Models.ModalConfiguration)
local AppChatFAEBanner = require(AppChat.Components.FaeBanner.AppChatFAEBanner)
local FIntAppChatModalSeenImpressionDelayMs = require(AppChat.Flags.FIntAppChatModalSeenImpressionDelayMs)
local FFlagDebugAppChatFae = require(AppChat.Flags.FFlagDebugAppChatFae)
local FStringCanAccessTrustedContactsAmpFeature = require(AppChatParent.SharedFlags).FStringCanAccessTrustedContactsAmpFeature
local FStringCanAccessTrustedContactsAmpNameSpace = require(AppChatParent.SharedFlags).FStringCanAccessTrustedContactsAmpNameSpace
local FFlagDebugAEGIS1AppChatBanner = require(AppChat.Flags.FFlagDebugAEGIS1AppChatBanner)
local SocialExperiments = require(AppChatParent.SocialExperiments)
local FFlagTestDeviceForFAEUpsell = require(AppChatParent.SocialExperiments).FFlagTestDeviceForFAEUpsell
local deviceMeetsRequirementsForFAE = SocialExperiments.deviceMeetsRequirementsForFAE
local GetAgeVerifiedChangedSignal = SocialUpsell.Signals.GetAgeVerifiedChangedSignal
local ChatLandingModal = require(script.Parent.ChatLandingModal)
local t1 = {
	fully_eligible_ftux = true,
	party_only_ftux = true,
	phone_verify = true,
	[ChatLandingModalVariant.AgeAssuranceUpsell] = true
}
local t2 = {
	fully_eligible_ftux = "ChatLandingUnfilteredThreadsFtux",
	phone_verify = "ChatLandingPvUpsell"
}

local function ChatLandingModalContainer(_) -- line: 77
	-- upvalues: useDispatch (copy), useAnalytics (copy), useContext (copy), LuaAppNavigationContext (copy), useNavigation (copy), useState (copy), useIsInExperience (copy), useSelector (copy), ModalConfiguration (copy), getDeepValue2 (copy), t2 (copy), t1 (copy), ChatLandingModalVariant (copy), useTelemetry (copy), ChatLandingTelemetryLayer (copy), useEffectOnMount (copy), useEffect (copy), ChatLandingModalTelemetry (copy), useCallback (copy), AppPage (copy), UnfilteredThreadsAMPFeatureName (copy), FFlagSignalsNavP3Dispatch (copy), v35 (copy), NavigateBack (copy), AccessResponseEnum (copy), refreshAllUnfilteredThreadsDetails (copy), NavigateDown (copy), HttpService (copy), FStringCanAccessTrustedContactsAmpFeature (copy), FStringCanAccessTrustedContactsAmpNameSpace (copy), ModalTelemetry (copy), FFlagDebugAppChatFae (copy), FFlagDebugAEGIS1AppChatBanner (copy), OpenTcLearnMoreLink (copy), AppChatNetworking (copy), Cryo (copy), React (copy), useRef (copy), useIsGuiInChatVisible (copy), useRecordModalSeenWithDelay (copy), FIntAppChatModalSeenImpressionDelayMs (copy), FFlagTestDeviceForFAEUpsell (copy), deviceMeetsRequirementsForFAE (copy), AppChatFAEBanner (copy), ChatLandingModal (copy), Enum2 (copy), GetAgeVerifiedChangedSignal (copy)
	local v55 = useDispatch()
	local v56 = useAnalytics()
	local v57 = useContext(LuaAppNavigationContext)
	local v58 = useNavigation()
	local v59, v60 = useState({})
	local v61 = useIsInExperience()
	local v62 = useSelector(function(p2) -- line: 86
		-- upvalues: ModalConfiguration (copy), getDeepValue2 (copy)
		local default = ModalConfiguration.default

		return getDeepValue2(p2, "ChatAppReducer.Modals.chatLandingModal") or default
	end)
	local modal_variant = v62.modal_variant
	local v64 = getDeepValue2(v62, "modal_layout.id")
	local v65 = getDeepValue2(v62, "modal_layout.seen_record_action")
	local v66 = getDeepValue2(v62, "modal_layout.dismissed_record_action")
	local v67 = getDeepValue2(v62, "modal_layout.buttons")
	local v68 = v67 and v67[1]
	local v69 = t2[modal_variant]
	local v70 = (t1[modal_variant] or modal_variant == ChatLandingModalVariant.ChatLandingAgeVerifiedCommsUpsellModal) and not v59[modal_variant]
	local v71 = useTelemetry(ChatLandingTelemetryLayer.Context)

	useEffectOnMount(function() -- line: 104
		-- upvalues: v56 (copy), v69 (copy), v70 (copy)
		if v56 and (v69 and v70) then
			v56.fireAnalyticsEvent(`{ v69 }Rendered`)
		end
	end)
	useEffect(function() -- line: 109
		-- upvalues: v70 (copy), modal_variant (copy), ChatLandingModalVariant (copy), v71 (copy), ChatLandingModalTelemetry (copy)
		if v70 and modal_variant == ChatLandingModalVariant.AgeAssuranceUpsell then
			v71.emit(ChatLandingModalTelemetry.Events.FaeModalShown, {})
		end

		if v70 then
			v71.emit(ChatLandingModalTelemetry.Events.ModalRendered, {
				modalVariant = modal_variant
			})
		end
	end, {
		modal_variant,
		v70
	})

	local v72 = useCallback(function() -- line: 120
		-- upvalues: v56 (copy), v69 (copy), AppPage (copy), UnfilteredThreadsAMPFeatureName (copy), FFlagSignalsNavP3Dispatch (copy), v35 (copy), v55 (copy), NavigateBack (copy), AccessResponseEnum (copy), refreshAllUnfilteredThreadsDetails (copy), v61 (copy), NavigateDown (copy)
		if v56 and v69 then
			v56.fireAnalyticsEvent(`{ v69 }ContinueClicked`)
		end

		local t3 = {
			name = AppPage.AmpWizardContainer,
			extraProps = {
				featureName = UnfilteredThreadsAMPFeatureName,
				completionCallback = function(p3, _) -- line: 128
					-- upvalues: FFlagSignalsNavP3Dispatch (copy), v35 (copy), v55 (copy), NavigateBack (copy), AccessResponseEnum (copy), v56 (copy), v69 (copy), refreshAllUnfilteredThreadsDetails (copy), v61 (copy)
					if FFlagSignalsNavP3Dispatch then
						v35.back(true)
					else
						v55(NavigateBack(true))
					end

					if p3 == AccessResponseEnum.Granted then
						if v56 and v69 then
							v56.fireAnalyticsEvent(`{ v69 }Succeeded`)
						end

						v55(refreshAllUnfilteredThreadsDetails(nil, v61))

						return
					end

					if v56 and v69 then
						v56.fireAnalyticsEvent(`{ v69 }Failed`)
					end
				end
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v35.down(v35.fromLegacyPage(t3))

			return
		end

		v55(NavigateDown(t3))
	end, {
		v55,
		v56,
		v69
	})
	local v73 = useCallback(function() -- line: 155
		-- upvalues: HttpService (copy), v71 (copy), ChatLandingModalTelemetry (copy), AppPage (copy), FStringCanAccessTrustedContactsAmpFeature (copy), FStringCanAccessTrustedContactsAmpNameSpace (copy), FFlagSignalsNavP3Dispatch (copy), v35 (copy), v55 (copy), NavigateBack (copy), AccessResponseEnum (copy), modal_variant (copy), ModalTelemetry (copy), refreshAllUnfilteredThreadsDetails (copy), v61 (copy), FFlagDebugAppChatFae (copy), FFlagDebugAEGIS1AppChatBanner (copy), NavigateDown (copy)
		local guid = HttpService:GenerateGUID(false)

		v71.emit(ChatLandingModalTelemetry.Events.TelemetryFaeButtonClick, {
			state = guid,
			btn = ChatLandingModalTelemetry.Constants.ConfirmFaeBtn
		})

		local t4 = {
			name = AppPage.AmpWizardContainer,
			extraProps = {
				featureName = FStringCanAccessTrustedContactsAmpFeature,
				entryPointEventCtx = ChatLandingModalTelemetry.Constants.EventStreamCtx,
				metadata = {
					sessionId = guid
				},
				nameSpace = FStringCanAccessTrustedContactsAmpNameSpace,
				completionCallback = function(p5, _) -- line: 170
					-- upvalues: FFlagSignalsNavP3Dispatch (copy), v35 (copy), v55 (copy), NavigateBack (copy), AccessResponseEnum (copy), v71 (copy), ChatLandingModalTelemetry (copy), modal_variant (copy), ModalTelemetry (copy), refreshAllUnfilteredThreadsDetails (copy), v61 (copy), FFlagDebugAppChatFae (copy), FFlagDebugAEGIS1AppChatBanner (copy)
					if FFlagSignalsNavP3Dispatch then
						v35.back(true)
					else
						v55(NavigateBack(true))
					end

					if p5 == AccessResponseEnum.Granted then
						v71.emit(ChatLandingModalTelemetry.Events.ModalActionResult, {
							modalVariant = modal_variant,
							action = ModalTelemetry.Enums.ModalActions.PrimaryCta,
							actionResult = ModalTelemetry.Enums.ModalActionResults.Success
						})
						v55(refreshAllUnfilteredThreadsDetails(nil, v61))
					else
						v71.emit(ChatLandingModalTelemetry.Events.ModalActionResult, {
							modalVariant = modal_variant,
							action = ModalTelemetry.Enums.ModalActions.PrimaryCta,
							actionResult = ModalTelemetry.Enums.ModalActionResults.Failure
						})
					end

					if FFlagDebugAppChatFae or FFlagDebugAEGIS1AppChatBanner then
						v55({
							type = "DEBUG_DismissChatLandingModal"
						})
					end
				end
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v35.down(v35.fromLegacyPage(t4))

			return
		end

		v55(NavigateDown(t4))
	end, {
		v55,
		v61,
		v71,
		modal_variant
	})
	local v74 = useCallback(function() -- line: 213
		-- upvalues: v56 (copy), v69 (copy), v58 (copy), v57 (copy)
		if v56 and v69 then
			v56.fireAnalyticsEvent(`{ v69 }LearnMoreClicked`)
		end

		local v92 = if not v58 then nil else v58.navigate

		v57.navigateToUnfilteredThreadsLearnMore(v92)
	end, {
		v57,
		v56,
		v58,
		v69
	})
	local v75 = useCallback(function() -- line: 227
		-- upvalues: v55 (copy), OpenTcLearnMoreLink (copy)
		v55(OpenTcLearnMoreLink())
	end, { v55 })
	local v76 = useCallback(function() -- line: 231
		-- upvalues: v56 (copy), v69 (copy), modal_variant (copy), ChatLandingModalVariant (copy), v71 (copy), ChatLandingModalTelemetry (copy), HttpService (copy), ModalTelemetry (copy), v55 (copy), AppChatNetworking (copy), v66 (copy), v64 (copy), FFlagDebugAppChatFae (copy), FFlagDebugAEGIS1AppChatBanner (copy), v60 (copy), Cryo (copy), v59 (copy)
		if v56 and v69 then
			v56.fireAnalyticsEvent(`{ v69 }Dismissed`)
		end

		if modal_variant == ChatLandingModalVariant.AgeAssuranceUpsell then
			v71.emit(ChatLandingModalTelemetry.Events.TelemetryFaeButtonClick, {
				state = HttpService:GenerateGUID(false),
				btn = ChatLandingModalTelemetry.Constants.CancelFaeBtn
			})
		end

		v71.emit(ChatLandingModalTelemetry.Events.ModalAction, {
			modalVariant = modal_variant,
			action = ModalTelemetry.Enums.ModalActions.Dismiss
		})
		v55(AppChatNetworking.rodux.RecordModalSequenceResponse.API(v66, "chat_landing_modal", v64)):catch(function(p7) -- line: 251
			warn("Error in ChatLandingModalContainer -> RecordModalSequenceResponse dismissed: " .. tostring(p7), p7)
		end)

		if FFlagDebugAppChatFae and modal_variant == ChatLandingModalVariant.AgeAssuranceUpsell or FFlagDebugAEGIS1AppChatBanner and modal_variant == ChatLandingModalVariant.ChatLandingAgeVerifiedCommsTimedModal then
			v55({
				type = "DEBUG_DismissChatLandingModal"
			})

			return
		end

		v60(Cryo.Dictionary.join(v59, {
			[modal_variant] = true
		}))
	end, {
		v59,
		v60,
		v55,
		v56,
		v69,
		v66,
		modal_variant,
		v64,
		v71
	})
	local v77 = ({
		[ChatLandingModalVariant.AgeAssuranceUpsell] = v75
	})[modal_variant]
	local v78 = useCallback(function(...) -- line: 291
		-- upvalues: v71 (copy), ChatLandingModalTelemetry (copy), modal_variant (copy), ModalTelemetry (copy), v77 (copy)
		v71.emit(ChatLandingModalTelemetry.Events.ModalAction, {
			modalVariant = modal_variant,
			action = ModalTelemetry.Enums.ModalActions.InlineCta
		})
		v77(...)
	end, {
		v77,
		v71,
		modal_variant
	})
	local v79 = v62 and (not not v62.modal_layout and (not not v62.modal_layout.body and v62.modal_layout.body.additional_content)) or {}
	local v80 = React.useMemo(function() -- line: 304
		-- upvalues: Cryo (copy), v79 (copy), AppChatNetworking (copy), v78 (copy)
		return Cryo.List.map(v79, function(p8) -- line: 305
			-- upvalues: AppChatNetworking (copy), v78 (copy)
			local t5 = {
				type = p8.type,
				text = p8.text
			}

			if p8.type == AppChatNetworking.Constants.ModalContentType.Link then
				t5.onActivated = v78
			end

			return t5
		end)
	end, {
		v79,
		v77,
		v78
	})
	local v81 = ({
		phone_verify = v72,
		fully_eligible_ftux = v74,
		[ChatLandingModalVariant.AgeAssuranceUpsell] = v73
	})[modal_variant]
	local v82 = useCallback(function(...) -- line: 323
		-- upvalues: v71 (copy), ChatLandingModalTelemetry (copy), modal_variant (copy), ModalTelemetry (copy), v81 (copy)
		v71.emit(ChatLandingModalTelemetry.Events.ModalAction, {
			modalVariant = modal_variant,
			action = ModalTelemetry.Enums.ModalActions.PrimaryCta
		})
		v81(...)
	end, {
		v81,
		v71,
		modal_variant
	})
	local v83 = useRef(nil)
	local v84 = useIsGuiInChatVisible(v83, {
		v83.current,
		v70
	})

	useRecordModalSeenWithDelay({
		modalSequence = "chat_landing_modal",
		modalId = v64,
		actionToRecord = v65,
		delayMs = FIntAppChatModalSeenImpressionDelayMs,
		canRecordAction = v84 and v70
	})

	local v85 = not FFlagDebugAppChatFae and function() -- line: 347
	end or React.useCallback(function() -- line: 342
		-- upvalues: v55 (copy)
		v55({
			type = "DEBUG_ShowAppChatFaeUpsell"
		})
	end, { v55 })
	local v86 = if not FFlagDebugAEGIS1AppChatBanner then nil else React.useCallback(function() -- line: 350
		-- upvalues: v55 (copy)
		v55({
			type = "DEBUG_ShowChatLandingAgeVerifiedTimedModal"
		})
	end, { v55 })

	if FFlagTestDeviceForFAEUpsell and not deviceMeetsRequirementsForFAE() then
		return nil
	end

	if v70 then
		if modal_variant == ChatLandingModalVariant.ChatLandingAgeVerifiedCommsUpsellModal then
			return React.createElement(AppChatFAEBanner, {
				modalConfiguration = v62,
				onDismiss = v76
			})
		end

		return React.createElement(ChatLandingModal, {
			titleLabelText = getDeepValue2(v62, "modal_layout.label.text"),
			titleText = getDeepValue2(v62, "modal_layout.header.text"),
			bodyText = getDeepValue2(v62, "modal_layout.body.text"),
			additionalContent = v80,
			actionText = v68 and v68.text,
			buttonType = if modal_variant ~= "fully_eligible_ftux" then Enum2.ButtonType.PrimarySystem else Enum2.ButtonType.Secondary,
			onActivated = v82,
			onDismissed = v76,
			hideActionButton = not v68 or not v81,
			ref = v83
		})
	end

	if modal_variant ~= "none" and modal_variant ~= nil and not t1[modal_variant] then
		warn("Unsupported ChatLandingModal variant: " .. modal_variant)
	end

	if FFlagDebugAEGIS1AppChatBanner then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 200)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.Name,
				Padding = UDim.new(0, 10)
			}),
			Btn1 = React.createElement("TextButton", {
				Text = "DEBUG Show Chat Landing Age Verfication Timed Modal",
				Size = UDim2.new(0, 200, 0, 50),
				[React.Event.Activated] = v86
			}),
			Btn2 = React.createElement("TextButton", {
				Text = "DEBUG Fire Age Verified event",
				Size = UDim2.new(0, 200, 0, 50),
				[React.Event.Activated] = function() -- line: 409
					-- upvalues: GetAgeVerifiedChangedSignal (copy)
					GetAgeVerifiedChangedSignal():fire()
				end
			})
		})
	end

	if FFlagDebugAppChatFae then
		return React.createElement("TextButton", {
			Text = "DEBUG Show FAE Upsell",
			Size = UDim2.new(0, 200, 0, 50),
			[React.Event.Activated] = v85
		})
	end

	return nil
end

return memo(ChatLandingModalContainer)
