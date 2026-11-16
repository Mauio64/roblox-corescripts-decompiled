local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local LuaAppNavigationContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LuaAppNavigationContext")
local getDeepValue2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue2")
local memo = React.memo
local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/useAnalytics")
local useCallback = React.useCallback
local useContext = React.useContext
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useEffectOnMount = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.useEffectOnMount
local useIsInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsInExperience")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local useState = React.useState
local useRef = React.useRef
local useIsGuiInChatVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsGuiInChatVisible")
local useRecordModalSeenWithDelay = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useRecordModalSeenWithDelay")

local ChatLandingModalTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLandingModal/ChatLandingModalTelemetry")
local ChatLandingTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLandingTelemetryEvents")
local ChatLandingTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatLandingTelemetryLayer")
local ModalTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ModalTelemetry")
local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")

local enum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").App.Button.Enum

local SocialUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialUpsell")
local accessResponseEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AmpUpsell").AmpEnums.AccessResponseEnum
local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local chatLandingModalVariant = AppChatNetworking.Constants.ChatLandingModalVariant
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppEnums").AppPage
local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/NavigationRodux").Thunks.NavigateBack
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppNavigation").NavigationCommands else nil

local refreshAllUnfilteredThreadsDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/refreshAllUnfilteredThreadsDetails")
local UnfilteredThreadsAMPFeatureName = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/UnfilteredThreadsAMPFeatureName")
local OpenTcLearnMoreLink = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/OpenTcLearnMoreLink")
local ModalConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ModalConfiguration")
local AppChatFAEBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/FaeBanner/AppChatFAEBanner")

local FIntAppChatModalSeenImpressionDelayMs = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntAppChatModalSeenImpressionDelayMs")
local FFlagAppChatLandingModalTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatLandingModalTelemetry")
local FFlagDebugAppChatFae = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatFae")

local fStringCanAccessTrustedContactsAmpFeature = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FStringCanAccessTrustedContactsAmpFeature

local fStringCanAccessTrustedContactsAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FStringCanAccessTrustedContactsAmpNameSpace
local FFlagDebugAEGIS1AppChatBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAEGIS1AppChatBanner")
local SocialExperiments = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments")
local fFlagTestDeviceForFAEUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments").FFlagTestDeviceForFAEUpsell
local deviceMeetsRequirementsForFAE = SocialExperiments.deviceMeetsRequirementsForFAE
local getAgeVerifiedChangedSignal = SocialUpsell.Signals.GetAgeVerifiedChangedSignal

local ChatLandingModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLandingModal/ChatLandingModal")

local v5 = {
	fully_eligible_ftux = true,
	party_only_ftux = true,
	phone_verify = true,
	[chatLandingModalVariant.AgeAssuranceUpsell] = true
}

local v6 = {
	fully_eligible_ftux = "ChatLandingUnfilteredThreadsFtux",
	phone_verify = "ChatLandingPvUpsell"
}

local function ChatLandingModalContainer(p2)
	local v7 = useDispatch()
	local v8 = useAnalytics()
	local v9 = useContext(LuaAppNavigationContext)
	local v10 = useNavigation()
	local state, setState = useState({})
	local v11 = useIsInExperience()

	local v12 = useSelector(function(p3)
		local default = ModalConfiguration.default
		return getDeepValue2(p3, "ChatAppReducer.Modals.chatLandingModal") or default
	end)

	local modal_variant = v12.modal_variant
	local v13 = getDeepValue2(v12, "modal_layout.id")
	local v14 = getDeepValue2(v12, "modal_layout.seen_record_action")
	local v15 = getDeepValue2(v12, "modal_layout.dismissed_record_action")
	local v16 = getDeepValue2(v12, "modal_layout.buttons")
	local v17 = v16 and v16[1]
	local v18 = v6[modal_variant]
	local v19

	if
		v5[modal_variant]
		or modal_variant == chatLandingModalVariant.ChatLandingAgeVerifiedCommsUpsellModal
	then
		v19 = not state[modal_variant]
	else
		v19 = false
	end

	local v20 = useTelemetry(ChatLandingTelemetryLayer.Context)
	useEffectOnMount(function()
		if v8 and v18 and v19 then
			v8.fireAnalyticsEvent(`{v18}Rendered`)
		end

		if FFlagAppChatLandingModalTelemetry and v18 and v19 then
			v20.emit(ChatLandingTelemetryEvents[`{v18}Rendered`], {})
		end
	end)
	useEffect(function()
		if v19 and modal_variant == chatLandingModalVariant.AgeAssuranceUpsell then
			v20.emit(ChatLandingModalTelemetry.Events.FaeModalShown, {})
		end

		if v19 then
			v20.emit(ChatLandingModalTelemetry.Events.ModalRendered, { modalVariant = modal_variant })
		end
	end, { modal_variant, v19 })

	local function fn()
		if v8 and v18 then
			v8.fireAnalyticsEvent(`{v18}ContinueClicked`)
		end

		if FFlagAppChatLandingModalTelemetry and v18 then
			v20.emit(ChatLandingTelemetryEvents[`{v18}ContinueClicked`], {})
		end

		local v22 = {
			name = appPage.AmpWizardContainer,
			extraProps = {
				featureName = UnfilteredThreadsAMPFeatureName,
				completionCallback = function(p3, p4)
					if fFlagSignalsNavP3Dispatch then
						navigationCommands.back(true)
					else
						v7(navigateBack(true))
					end

					if p3 == accessResponseEnum.Granted then
						if v8 and v18 then
							v8.fireAnalyticsEvent(`{v18}Succeeded`)
						end

						if FFlagAppChatLandingModalTelemetry and v18 then
							v20.emit(ChatLandingTelemetryEvents[`{v18}Succeeded`], {})
						end

						v7(refreshAllUnfilteredThreadsDetails(nil, v11))
					else
						if v8 and v18 then
							v8.fireAnalyticsEvent(`{v18}Failed`)
						end

						if FFlagAppChatLandingModalTelemetry and v18 then
							v20.emit(ChatLandingTelemetryEvents[`{v18}Failed`], {})
						end
					end
				end
			}
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v22))
		else
			v7(navigateDown(v22))
		end
	end

	local v24 = useCallback(fn, {
		v7,
		v11,
		v8,
		v18,
		if FFlagAppChatLandingModalTelemetry then v20 else false
	})

	local v25 = useCallback(function()
		local guid = HttpService:GenerateGUID(false)
		v20.emit(ChatLandingModalTelemetry.Events.TelemetryFaeButtonClick, {
			state = guid,
			btn = ChatLandingModalTelemetry.Constants.ConfirmFaeBtn
		})

		local v26 = {
			name = appPage.AmpWizardContainer,
			extraProps = {
				featureName = fStringCanAccessTrustedContactsAmpFeature,
				entryPointEventCtx = ChatLandingModalTelemetry.Constants.EventStreamCtx,
				metadata = { sessionId = guid },
				nameSpace = fStringCanAccessTrustedContactsAmpNameSpace,
				completionCallback = function(p3, p4)
					if fFlagSignalsNavP3Dispatch then
						navigationCommands.back(true)
					else
						v7(navigateBack(true))
					end

					if p3 == accessResponseEnum.Granted then
						v20.emit(ChatLandingModalTelemetry.Events.ModalActionResult, {
							modalVariant = modal_variant,
							action = ModalTelemetry.Enums.ModalActions.PrimaryCta,
							actionResult = ModalTelemetry.Enums.ModalActionResults.Success
						})

						v7(refreshAllUnfilteredThreadsDetails(nil, v11))
					else
						v20.emit(ChatLandingModalTelemetry.Events.ModalActionResult, {
							modalVariant = modal_variant,
							action = ModalTelemetry.Enums.ModalActions.PrimaryCta,
							actionResult = ModalTelemetry.Enums.ModalActionResults.Failure
						})
					end

					if FFlagDebugAppChatFae or FFlagDebugAEGIS1AppChatBanner then
						v7({ type = "DEBUG_DismissChatLandingModal" })
					end
				end
			}
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v26))
		else
			v7(navigateDown(v26))
		end
	end, { v7, v11, v20, modal_variant })

	local function fn2()
		if v8 and v18 then
			v8.fireAnalyticsEvent(`{v18}LearnMoreClicked`)
		end

		if FFlagAppChatLandingModalTelemetry and v18 then
			v20.emit(ChatLandingTelemetryEvents[`{v18}LearnMoreClicked`], {})
		end

		local v27 = if v10 then v10.navigate else nil
		v9.navigateToUnfilteredThreadsLearnMore(v27)
	end

	local v29 = useCallback(fn2, {
		v9,
		v8,
		v10,
		v18,
		if FFlagAppChatLandingModalTelemetry then v20 else false
	})

	local v30 = useCallback(function()
		v7(OpenTcLearnMoreLink())
	end, { v7 })
	local v31 = useCallback(function()
		if v8 and v18 then
			v8.fireAnalyticsEvent(`{v18}Dismissed`)
		end

		if FFlagAppChatLandingModalTelemetry and v18 then
			v20.emit(ChatLandingTelemetryEvents[`{v18}Dismissed`], {})
		end

		if modal_variant == chatLandingModalVariant.AgeAssuranceUpsell then
			v20.emit(ChatLandingModalTelemetry.Events.TelemetryFaeButtonClick, {
				state = HttpService:GenerateGUID(false),
				btn = ChatLandingModalTelemetry.Constants.CancelFaeBtn
			})
		end

		v20.emit(ChatLandingModalTelemetry.Events.ModalAction, {
			modalVariant = modal_variant,
			action = ModalTelemetry.Enums.ModalActions.Dismiss
		})

		v7(AppChatNetworking.rodux.RecordModalSequenceResponse.API(v15, "chat_landing_modal", v13)):catch(function(p3)
			warn(
				"Error in ChatLandingModalContainer -> RecordModalSequenceResponse dismissed: " .. tostring(p3),
				p3
			)
		end)

		if
			FFlagDebugAppChatFae and modal_variant == chatLandingModalVariant.AgeAssuranceUpsell
			or FFlagDebugAEGIS1AppChatBanner and modal_variant == chatLandingModalVariant.ChatLandingAgeVerifiedCommsTimedModal
		then
			v7({ type = "DEBUG_DismissChatLandingModal" })
		else
			setState(Cryo.Dictionary.join(state, { [modal_variant] = true }))
		end
	end, {
		state,
		setState,
		v7,
		v8,
		v18,
		v15,
		modal_variant,
		v13,
		v20
	})

	local v33 = ({ [chatLandingModalVariant.AgeAssuranceUpsell] = v30 })[modal_variant]
	local v34 = useCallback(function(...)
		v20.emit(ChatLandingModalTelemetry.Events.ModalAction, {
			modalVariant = modal_variant,
			action = ModalTelemetry.Enums.ModalActions.InlineCta
		})

		v33(...)
	end, { v33, v20, modal_variant })

	local additional_content = v12
		and v12.modal_layout
		and v12.modal_layout.body
		and v12.modal_layout.body.additional_content
		or {}
	local v35 = React.useMemo(function()
		return Cryo.List.map(additional_content, function(p3)
			local v36 = { type = p3.type, text = p3.text }

			if p3.type == AppChatNetworking.Constants.ModalContentType.Link then
				v36.onActivated = v34
			end

			return v36
		end)
	end, { additional_content, v33, v34 })
	local v37 = ({
		phone_verify = v24,
		fully_eligible_ftux = v29,
		[chatLandingModalVariant.AgeAssuranceUpsell] = v25
	})[modal_variant]
	local v38 = useCallback(function(...)
		v20.emit(ChatLandingModalTelemetry.Events.ModalAction, {
			modalVariant = modal_variant,
			action = ModalTelemetry.Enums.ModalActions.PrimaryCta
		})

		v37(...)
	end, { v37, v20, modal_variant })

	local v39 = useRef(nil)
	useRecordModalSeenWithDelay({
		modalSequence = "chat_landing_modal",
		modalId = v13,
		actionToRecord = v14,
		delayMs = FIntAppChatModalSeenImpressionDelayMs,
		canRecordAction = useIsGuiInChatVisible(v39, { v39.current, v19 }) and v19
	})

	local fn3 = not FFlagDebugAppChatFae and function() end or React.useCallback(function()
		v7({ type = "DEBUG_ShowAppChatFaeUpsell" })
	end, { v7 })
	local v41

	if FFlagDebugAEGIS1AppChatBanner then
		v41 = React.useCallback(function()
			v7({ type = "DEBUG_ShowChatLandingAgeVerifiedTimedModal" })
		end, { v7 })
	end

	if fFlagTestDeviceForFAEUpsell and not deviceMeetsRequirementsForFAE() then
		return nil
	end

	if v19 then
		if modal_variant == chatLandingModalVariant.ChatLandingAgeVerifiedCommsUpsellModal then
			return React.createElement(AppChatFAEBanner, {
				modalConfiguration = v12,
				onDismiss = v31
			})
		end

		local createElement = React.createElement
		local v43 = {
			titleLabelText = getDeepValue2(v12, "modal_layout.label.text"),
			titleText = getDeepValue2(v12, "modal_layout.header.text"),
			bodyText = getDeepValue2(v12, "modal_layout.body.text"),
			additionalContent = v35,
			actionText = v17 and v17.text,
			buttonType = 0,
			onActivated = 0,
			onDismissed = 0,
			hideActionButton = 0,
			ref = 0
		}
		local v44 = if modal_variant == "fully_eligible_ftux" then enum.ButtonType.Secondary else enum.ButtonType.PrimarySystem
		v43.buttonType = v44

		v43.onActivated = v38
		v43.onDismissed = v31

		v43.hideActionButton = not (v17 and v37)
		v43.ref = v39
		return createElement(ChatLandingModal, v43)
	end

	if modal_variant ~= "none" and modal_variant ~= nil and not v5[modal_variant] then
		warn("Unsupported ChatLandingModal variant: " .. modal_variant)
	end

	if FFlagDebugAEGIS1AppChatBanner then
		return React.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 200) },
			{
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
					[React.Event.Activated] = v41
				}),
				Btn2 = React.createElement("TextButton", {
					Text = "DEBUG Fire Age Verified event",
					Size = UDim2.new(0, 200, 0, 50),
					[React.Event.Activated] = function()
						getAgeVerifiedChangedSignal():fire()
					end
				})
			}
		)
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
