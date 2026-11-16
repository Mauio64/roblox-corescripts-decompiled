local HttpService = game:GetService("HttpService")
local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
require(AppChat.types)

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local LuaAppNavigationContext = require(AppChat.LuaAppNavigationContext)
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local memo = React.memo
local useAnalytics = require(AppChat.Analytics.useAnalytics)
local useCallback = React.useCallback
local useContext = React.useContext
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local RoactUtils2 = require(parent.RoactUtils)
local useEffectOnMount = RoactUtils2.Hooks.useEffectOnMount
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RoactUtils3 = require(parent.RoactUtils)
local useSelector = RoactUtils3.Hooks.RoactRodux.useSelector
local useState = React.useState
local useRef = React.useRef
local useIsGuiInChatVisible = require(AppChat.Hooks.useIsGuiInChatVisible)
local useRecordModalSeenWithDelay = require(AppChat.Hooks.useRecordModalSeenWithDelay)

local ChatLandingModalTelemetry = require(script.Parent.ChatLandingModalTelemetry)
local ChatLandingTelemetryEvents = require(AppChat.Components.ChatLanding.ChatLandingTelemetryEvents)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local ModalTelemetry = require(AppChat.Components.ModalTelemetry)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)

local UIBlox = require(parent.UIBlox)
local enum = UIBlox.App.Button.Enum

local SocialUpsell = require(parent.SocialUpsell)
local AmpUpsell = require(parent.AmpUpsell)
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local AppChatNetworking = require(parent.AppChatNetworking)
local ChatLandingModalVariant = AppChatNetworking.Constants.ChatLandingModalVariant
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateBack = NavigationRodux.Thunks.NavigateBack
local NavigationRodux2 = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux2.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local refreshAllUnfilteredThreadsDetails = require(AppChat.Conversations.Thunks.refreshAllUnfilteredThreadsDetails)
local UnfilteredThreadsAMPFeatureName = require(AppChat.Components.UnfilteredThreadsAMPFeatureName)
local OpenTcLearnMoreLink = require(AppChat.Conversations.Thunks.OpenTcLearnMoreLink)
local ModalConfiguration = require(AppChat.Models.ModalConfiguration)
local AppChatFAEBanner = require(AppChat.Components.FaeBanner.AppChatFAEBanner)

local FIntAppChatModalSeenImpressionDelayMs = require(AppChat.Flags.FIntAppChatModalSeenImpressionDelayMs)
local FFlagAppChatLandingModalTelemetry = require(AppChat.Flags.FFlagAppChatLandingModalTelemetry)
local FFlagDebugAppChatFae = require(AppChat.Flags.FFlagDebugAppChatFae)

local SharedFlags2 = require(parent.SharedFlags)
local FStringCanAccessTrustedContactsAmpFeature = SharedFlags2.FStringCanAccessTrustedContactsAmpFeature

local SharedFlags3 = require(parent.SharedFlags)
local FStringCanAccessTrustedContactsAmpNameSpace = SharedFlags3.FStringCanAccessTrustedContactsAmpNameSpace
local FFlagDebugAEGIS1AppChatBanner = require(AppChat.Flags.FFlagDebugAEGIS1AppChatBanner)
local SocialExperiments = require(parent.SocialExperiments)
local SocialExperiments2 = require(parent.SocialExperiments)
local FFlagTestDeviceForFAEUpsell = SocialExperiments2.FFlagTestDeviceForFAEUpsell
local deviceMeetsRequirementsForFAE = SocialExperiments.deviceMeetsRequirementsForFAE
local GetAgeVerifiedChangedSignal = SocialUpsell.Signals.GetAgeVerifiedChangedSignal

local ChatLandingModal = require(script.Parent.ChatLandingModal)

local v = {
	fully_eligible_ftux = true,
	party_only_ftux = true,
	phone_verify = true,
	[ChatLandingModalVariant.AgeAssuranceUpsell] = true
}

local v2 = {
	fully_eligible_ftux = "ChatLandingUnfilteredThreadsFtux",
	phone_verify = "ChatLandingPvUpsell"
}

local function ChatLandingModalContainer(_)
	local v3 = useDispatch()
	local v4 = useAnalytics()
	local v5 = useContext(LuaAppNavigationContext)
	local v6 = useNavigation()
	local state, setState = useState({})
	local v7 = useIsInExperience()

	local modalConfiguration = useSelector(function(p)
		local default = ModalConfiguration.default
		return getDeepValue2(p, "ChatAppReducer.Modals.chatLandingModal") or default
	end)

	local modal_variant = modalConfiguration.modal_variant
	local deepValue2 = getDeepValue2(modalConfiguration, "modal_layout.id")
	local deepValue2_2 = getDeepValue2(modalConfiguration, "modal_layout.seen_record_action")
	local deepValue2_3 = getDeepValue2(modalConfiguration, "modal_layout.dismissed_record_action")
	local deepValue2_4 = getDeepValue2(modalConfiguration, "modal_layout.buttons")
	local v8 = deepValue2_4 and deepValue2_4[1]
	local v9 = v2[modal_variant]
	local v10

	if v[modal_variant] or modal_variant == ChatLandingModalVariant.ChatLandingAgeVerifiedCommsUpsellModal then
		v10 = not state[modal_variant]
	else
		v10 = false
	end

	local v11 = useTelemetry(ChatLandingTelemetryLayer.Context)
	useEffectOnMount(function()
		if v4 and v9 and v10 then
			v4.fireAnalyticsEvent(`{v9}Rendered`)
		end

		if FFlagAppChatLandingModalTelemetry and v9 and v10 then
			v11.emit(ChatLandingTelemetryEvents[`{v9}Rendered`], {})
		end
	end)
	useEffect(function()
		if v10 and modal_variant == ChatLandingModalVariant.AgeAssuranceUpsell then
			v11.emit(ChatLandingModalTelemetry.Events.FaeModalShown, {})
		end

		if v10 then
			v11.emit(ChatLandingModalTelemetry.Events.ModalRendered, {
				modalVariant = modal_variant
			})
		end
	end, { modal_variant, v10 })

	local function fn()
		if v4 and v9 then
			v4.fireAnalyticsEvent(`{v9}ContinueClicked`)
		end

		if FFlagAppChatLandingModalTelemetry and v9 then
			v11.emit(ChatLandingTelemetryEvents[`{v9}ContinueClicked`], {})
		end

		local v12 = {
			name = AppPage.AmpWizardContainer,
			extraProps = {
				featureName = UnfilteredThreadsAMPFeatureName,
				completionCallback = function(p, _)
					if FFlagSignalsNavP3Dispatch then
						navigationCommands.back(true)
					else
						v3(NavigateBack(true))
					end

					if p == AccessResponseEnum.Granted then
						if v4 and v9 then
							v4.fireAnalyticsEvent(`{v9}Succeeded`)
						end

						if FFlagAppChatLandingModalTelemetry and v9 then
							v11.emit(ChatLandingTelemetryEvents[`{v9}Succeeded`], {})
						end

						v3(refreshAllUnfilteredThreadsDetails(nil, v7))
					else
						if v4 and v9 then
							v4.fireAnalyticsEvent(`{v9}Failed`)
						end

						if FFlagAppChatLandingModalTelemetry and v9 then
							v11.emit(ChatLandingTelemetryEvents[`{v9}Failed`], {})
						end
					end
				end
			}
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v12))
		else
			v3(NavigateDown(v12))
		end
	end

	local v12 = if FFlagAppChatLandingModalTelemetry then v11 else false
	local phone_verify = useCallback(fn, { v3, v7, v4, v9, v12 })

	local v13 = useCallback(function()
		local guid = HttpService:GenerateGUID(false)
		v11.emit(ChatLandingModalTelemetry.Events.TelemetryFaeButtonClick, {
			state = guid,
			btn = ChatLandingModalTelemetry.Constants.ConfirmFaeBtn
		})

		local v13 = {
			name = AppPage.AmpWizardContainer,
			extraProps = {
				featureName = FStringCanAccessTrustedContactsAmpFeature,
				entryPointEventCtx = ChatLandingModalTelemetry.Constants.EventStreamCtx,
				metadata = { sessionId = guid },
				nameSpace = FStringCanAccessTrustedContactsAmpNameSpace,
				completionCallback = function(p, _)
					if FFlagSignalsNavP3Dispatch then
						navigationCommands.back(true)
					else
						v3(NavigateBack(true))
					end

					if p == AccessResponseEnum.Granted then
						v11.emit(ChatLandingModalTelemetry.Events.ModalActionResult, {
							modalVariant = modal_variant,
							action = ModalTelemetry.Enums.ModalActions.PrimaryCta,
							actionResult = ModalTelemetry.Enums.ModalActionResults.Success
						})

						v3(refreshAllUnfilteredThreadsDetails(nil, v7))
					else
						v11.emit(ChatLandingModalTelemetry.Events.ModalActionResult, {
							modalVariant = modal_variant,
							action = ModalTelemetry.Enums.ModalActions.PrimaryCta,
							actionResult = ModalTelemetry.Enums.ModalActionResults.Failure
						})
					end

					if FFlagDebugAppChatFae or FFlagDebugAEGIS1AppChatBanner then
						v3({ type = "DEBUG_DismissChatLandingModal" })
					end
				end
			}
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v13))
		else
			v3(NavigateDown(v13))
		end
	end, { v3, v7, v11, modal_variant })

	local function fn2()
		if v4 and v9 then
			v4.fireAnalyticsEvent(`{v9}LearnMoreClicked`)
		end

		if FFlagAppChatLandingModalTelemetry and v9 then
			v11.emit(ChatLandingTelemetryEvents[`{v9}LearnMoreClicked`], {})
		end

		local v14

		if v6 then
			v14 = v6.navigate
		end

		v5.navigateToUnfilteredThreadsLearnMore(v14)
	end

	local v14 = if FFlagAppChatLandingModalTelemetry then v11 else false
	local fully_eligible_ftux = useCallback(fn2, { v5, v4, v6, v9, v14 })

	local v15 = useCallback(function()
		v3(OpenTcLearnMoreLink())
	end, { v3 })
	local v16 = useCallback(function()
		if v4 and v9 then
			v4.fireAnalyticsEvent(`{v9}Dismissed`)
		end

		if FFlagAppChatLandingModalTelemetry and v9 then
			v11.emit(ChatLandingTelemetryEvents[`{v9}Dismissed`], {})
		end

		if modal_variant == ChatLandingModalVariant.AgeAssuranceUpsell then
			v11.emit(ChatLandingModalTelemetry.Events.TelemetryFaeButtonClick, {
				state = HttpService:GenerateGUID(false),
				btn = ChatLandingModalTelemetry.Constants.CancelFaeBtn
			})
		end

		v11.emit(ChatLandingModalTelemetry.Events.ModalAction, {
			modalVariant = modal_variant,
			action = ModalTelemetry.Enums.ModalActions.Dismiss
		})

		v3(AppChatNetworking.rodux.RecordModalSequenceResponse.API(deepValue2_3, "chat_landing_modal", deepValue2)):catch(function(p)
			warn("Error in ChatLandingModalContainer -> RecordModalSequenceResponse dismissed: " .. tostring(p), p)
		end)

		if
			FFlagDebugAppChatFae and modal_variant == ChatLandingModalVariant.AgeAssuranceUpsell
			or FFlagDebugAEGIS1AppChatBanner
			and modal_variant == ChatLandingModalVariant.ChatLandingAgeVerifiedCommsTimedModal
		then
			v3({ type = "DEBUG_DismissChatLandingModal" })
		else
			setState(Cryo.Dictionary.join(state, { [modal_variant] = true }))
		end
	end, {
		state,
		setState,
		v3,
		v4,
		v9,
		deepValue2_3,
		modal_variant,
		deepValue2,
		v11
	})

	local v17 = ({ [ChatLandingModalVariant.AgeAssuranceUpsell] = v15 })[modal_variant]
	local onActivated = useCallback(function(...)
		v11.emit(ChatLandingModalTelemetry.Events.ModalAction, {
			modalVariant = modal_variant,
			action = ModalTelemetry.Enums.ModalActions.InlineCta
		})

		v17(...)
	end, { v17, v11, modal_variant })

	local additional_content = modalConfiguration
		and modalConfiguration.modal_layout
		and modalConfiguration.modal_layout.body
		and modalConfiguration.modal_layout.body.additional_content
		or {}
	local additionalContent = React.useMemo(function()
		return Cryo.List.map(additional_content, function(p)
			local v18 = { type = p.type, text = p.text }

			if p.type == AppChatNetworking.Constants.ModalContentType.Link then
				v18.onActivated = onActivated
			end

			return v18
		end)
	end, { additional_content, v17, onActivated })
	local v18 = ({
		phone_verify = phone_verify,
		fully_eligible_ftux = fully_eligible_ftux,
		[ChatLandingModalVariant.AgeAssuranceUpsell] = v13
	})[modal_variant]
	local onActivated2 = useCallback(function(...)
		v11.emit(ChatLandingModalTelemetry.Events.ModalAction, {
			modalVariant = modal_variant,
			action = ModalTelemetry.Enums.ModalActions.PrimaryCta
		})

		v18(...)
	end, { v18, v11, modal_variant })

	local ref = useRef(nil)
	useRecordModalSeenWithDelay({
		modalSequence = "chat_landing_modal",
		modalId = deepValue2,
		actionToRecord = deepValue2_2,
		delayMs = FIntAppChatModalSeenImpressionDelayMs,
		canRecordAction = useIsGuiInChatVisible(ref, { ref.current, v10 }) and v10
	})

	local fn3 = not FFlagDebugAppChatFae and function() end or React.useCallback(function()
		v3({ type = "DEBUG_ShowAppChatFaeUpsell" })
	end, { v3 })
	local v19

	if FFlagDebugAEGIS1AppChatBanner then
		v19 = React.useCallback(function()
			v3({ type = "DEBUG_ShowChatLandingAgeVerifiedTimedModal" })
		end, { v3 })
	end

	if FFlagTestDeviceForFAEUpsell and not deviceMeetsRequirementsForFAE() then
		return nil
	end

	if v10 then
		if modal_variant == ChatLandingModalVariant.ChatLandingAgeVerifiedCommsUpsellModal then
			return React.createElement(AppChatFAEBanner, {
				modalConfiguration = modalConfiguration,
				onDismiss = v16
			})
		end

		local createElement = React.createElement
		local v20 = {
			titleLabelText = getDeepValue2(modalConfiguration, "modal_layout.label.text"),
			titleText = getDeepValue2(modalConfiguration, "modal_layout.header.text"),
			bodyText = getDeepValue2(modalConfiguration, "modal_layout.body.text"),
			additionalContent = additionalContent,
			actionText = v8 and v8.text,
			buttonType = 0,
			onActivated = 0,
			onDismissed = 0,
			hideActionButton = 0,
			ref = 0
		}
		local buttonType

		if modal_variant == "fully_eligible_ftux" then
			buttonType = enum.ButtonType.Secondary
		else
			buttonType = enum.ButtonType.PrimarySystem
		end

		v20.buttonType = buttonType

		v20.onActivated = onActivated2
		v20.onDismissed = v16

		v20.hideActionButton = not (v8 and v18)
		v20.ref = ref
		return createElement(ChatLandingModal, v20)
	end

	if modal_variant ~= "none" and modal_variant ~= nil and not v[modal_variant] then
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
				[React.Event.Activated] = v19
			}),
			Btn2 = React.createElement("TextButton", {
				Text = "DEBUG Fire Age Verified event",
				Size = UDim2.new(0, 200, 0, 50),
				[React.Event.Activated] = function()
					GetAgeVerifiedChangedSignal():fire()
				end
			})
		})
	end

	if not FFlagDebugAppChatFae then
		return nil
	end

	return React.createElement("TextButton", {
		Text = "DEBUG Show FAE Upsell",
		Size = UDim2.new(0, 200, 0, 50),
		[React.Event.Activated] = fn3
	})
end

return memo(ChatLandingModalContainer)
