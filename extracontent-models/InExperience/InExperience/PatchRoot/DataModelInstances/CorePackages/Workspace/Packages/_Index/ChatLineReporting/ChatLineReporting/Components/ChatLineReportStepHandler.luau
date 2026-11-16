local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local Players = game:GetService("Players")
local parent = ChatLineReporting.Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FocusRoot = FocusNavigationUtils.FocusRoot
local InputHandlers = require(parent.InputHandlers)
local React = require(parent.React)
local Cryo = require(parent.Cryo)
local ReactOtter = require(parent.ReactOtter)
local GuiService = game:GetService("GuiService")
local DefaultReportDialog = require(parent.GenericAbuseReporting.DefaultReportDialog)
local NotificationModalsManager = require(parent.NotificationModalsManager)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Constants = require(ChatLineReporting.Common.Constants)
local AnalyticsReducer = require(ChatLineReporting.Common.AnalyticsReducer)
local ChatLineReportAnalytics = require(ChatLineReporting.Common.ChatLineReportAnalytics)
local buildReport = require(ChatLineReporting.Common.buildReport)
local isSystemMessage = require(ChatLineReporting.Common.isSystemMessage)
local ChatLineReportSelectionModalOld = require(ChatLineReporting.Components.ChatLineReportSelectionModalOld)
local ChatLineReportVerbatim = require(ChatLineReporting.Components.ChatLineReportVerbatim)
local ChatLineReportCompleteModal = require(ChatLineReporting.Components.ChatLineReportCompleteModal)
local ReportCategories = require(ChatLineReporting.Common.ReportCategories)
local engineFeature = game:GetEngineFeature("SSUIMetaLua")
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableGlobalChatAbuseReporting = SharedFlags.FFlagEnableGlobalChatAbuseReporting

local SharedFlags2 = require(parent.SharedFlags)
local FFlagGenericAbuseReportingGranularExports = SharedFlags2.FFlagGenericAbuseReportingGranularExports
local SharedFlags3 = require(parent.SharedFlags)
local FFlagEnableChatReportingTextChannelTag = SharedFlags3.FFlagEnableChatReportingTextChannelTag

local v = { stiffness = 400, damping = 40, mass = 1 }

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function ChatLineReportStepHandler(p)
	local state, setState = React.useState(Constants.ReportSteps.SELECT)
	local state2, setState2 = React.useState(nil)
	local v2, analyticsDispatch = React.useReducer(AnalyticsReducer, Constants.AnalyticsInitialState)
	local state3, setState3 = React.useState(not GuiService.MenuIsOpen)
	local state4, setState4 = React.useState(GuiService.MenuIsOpen)
	local state5, setState5 = React.useState(false)
	local state6, setState6 = React.useState(nil)
	local state7, setState7 = React.useState("")

	local v3 = useLocalization(Constants.ChatLineLocalizationKeys)
	local v4 = useLocalization({
		ChatToastTitleSuccess = {
			"Feature.ReportAbuse.Label.UserTextMuted",
			name = state7
		},
		ChatToastTitleError = {
			"Feature.ReportAbuse.Label.UserTextMutedError",
			name = state7
		},
		ChatToastDescriptionErrorDoesNotExist = {
			"Feature.ReportAbuse.Message.UserTextMutedErrorDoesNotExist",
			name = state7
		}
	})

	local v5 = useTokens()

	React.useEffect(function()
		analyticsDispatch({
			type = Constants.AnalyticsActions.AccumulateForTimeSpent,
			accumulated_time_ms = workspace:GetServerTimeNow() * 1000
		})

		analyticsDispatch({ type = Constants.AnalyticsActions.SetPlaceId, place_id = game.PlaceId })

		local viewportSize = game.Workspace.CurrentCamera.ViewportSize
		analyticsDispatch({
			type = Constants.AnalyticsActions.SetViewportInformation,
			viewport_size_x = viewportSize.X,
			viewport_size_y = viewportSize.Y,
			is_portrait_mode = viewportSize.X < viewportSize.Y and viewportSize.X < 800
		})
		local count = 0
		local count2 = 0

		for _, message in ipairs(p.messages) do
			if isSystemMessage(message) then
				continue
			end

			count += 1

			if
				(not FFlagEnableGlobalChatAbuseReporting or message.textChannel)
				and message.textChannel.Name ~= Constants.ChannelTypes.General
			then
				count2 += 1
			end
		end

		analyticsDispatch({
			type = Constants.AnalyticsActions.SetChatHistoryInformation,
			selectable_chat_history_size = count,
			total_chat_history_size = #p.messages,
			num_non_general_channel_chats = count2
		})

		local menuOpenedConnection = GuiService.MenuOpened:Connect(function()
			setState4(true)
			setState3(false)
		end)
		local menuClosedConnection = GuiService.MenuClosed:Connect(function()
			setState4(false)
			setState3(true)
		end)
		return function()
			menuOpenedConnection:Disconnect()
			menuClosedConnection:Disconnect()
		end
	end, {})

	React.useEffect(function()
		if engineFeature then
			pcall(function()
				local SafetyService = game:GetService("SafetyService")

				if state3 then
					SafetyService:ReportChatLineReportingOpen()
				else
					SafetyService:ReportChatLineReportingClose()
				end
			end)
		end
	end, { state3 })

	local v6, v7 = ReactOtter.useAnimatedBinding(1, function()
		if not state3 then
			if state5 then
				if state6 and state6.key == Constants.SuccessfulMuteKey then
					NotificationModalsManager.SetUIBloxToast({
						iconImage = Images[Constants.ToastIconImageSuccess],
						toastTitle = v4.ChatToastTitleSuccess,
						toastSubtitle = v3.ChatToastDescriptionSuccess,
						sequenceNumber = DateTime.now().UnixTimestamp,
						iconColorStyle = {
							Color = v5.Color.System.Success.Color3,
							Transparency = 0
						}
					})
				elseif state6 then
					local setUIBloxToast = NotificationModalsManager.SetUIBloxToast
					local v6 = {
						iconImage = Images[Constants.ToastIconImageError],
						toastTitle = v4.ChatToastTitleError,
						toastSubtitle = 0,
						sequenceNumber = 0,
						iconColorStyle = 0
					}
					local toastSubtitle

					if state6.key == Constants.ErrorSelfMuteKey then
						toastSubtitle = v3.ChatToastDescriptionErrorSelf
					else
						toastSubtitle = v4.ChatToastDescriptionErrorDoesNotExist
					end

					v6.toastSubtitle = toastSubtitle

					v6.sequenceNumber = DateTime.now().UnixTimestamp
					v6.iconColorStyle = { Color = v5.Color.System.Warning.Color3, Transparency = 0 }
					setUIBloxToast(v6)
				end
			end

			p.unmount()
		end
	end)

	local v8 = React.useMemo(function(): number
		return if state3 then 0 else 1
	end, { state3 })

	React.useEffect(function()
		v7(ReactOtter.spring(v8, v))
	end, { v8 })

	local onContinue = React.useCallback(function()
		if state2 ~= nil then
			setState(Constants.ReportSteps.SUBMIT)
		end
	end)

	local onBack = React.useCallback(function()
		ChatLineReportAnalytics(v2, 2, false)
		setState3(false)
	end, { v2 })

	local onBackToPreviousStep = React.useCallback(function()
		setState(Constants.ReportSteps.SELECT)
		setState2(nil)
	end)

	local onProceedToNextStep = React.useCallback(function(reason_selection, list): boolean
		local v9 = {}
		local v10

		if FFlagEnableChatReportingTextChannelTag then
			local userId = Players.LocalPlayer.UserId
			local userId2 = state2.userId

			local messageId = state2.messageId
			local presetId = state2.presetId
			local presetChatVersion = state2.presetChatVersion
			local v11

			if state2.textChannel then
				v11 = state2.textChannel.Name
			end

			v10 = buildReport(userId, userId2, reason_selection, list, messageId, presetId, presetChatVersion, v11)
		else
			v10 = buildReport(
				Players.LocalPlayer.UserId,
				state2.userId,
				reason_selection,
				list,
				state2.messageId,
				state2.presetId,
				state2.presetChatVersion
			)
		end

		Cryo.Dictionary.map(p.messages, function(p2)
			if not isSystemMessage(p2) then
				v9[#v9 + 1] = { channel = p2.textChannel, messageId = p2.messageId }
			end
		end)

		local v11 = {
			{ channel = state2.textChannel, messageId = state2.messageId }
		}

		analyticsDispatch({
			type = Constants.AnalyticsActions.SetReasonSelection,
			reason_selection = reason_selection
		})

		analyticsDispatch({
			type = Constants.AnalyticsActions.SetCommentAdded,
			comment_added = #list > 0
		})

		Players:ReportChatAbuse(v9, v11, v10)
		setState(Constants.ReportSteps.COMPLETE)
		return true
	end, { p.messages, state2 })

	local onDismiss = React.useCallback(function(p2)
		if p2 then
			ChatLineReportAnalytics(v2, 1, true)
			setState6(p2)
			setState7(p2.args.RBX_NAME)
			setState5(true)
		else
			ChatLineReportAnalytics(v2, 1, false)
		end

		setState3(false)
	end, { v2 })

	local v9 = React.useCallback(function()
		ChatLineReportAnalytics(v2, 1, false)
		setState3(false)
	end, { v2 })

	if state ~= Constants.ReportSteps.COMPLETE then
		v9 = onBack
	end

	local createElement = React.createElement
	local v10 = {
		Active = v6:map(function(p2): boolean
			return p2 == 0
		end),
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundTransparency = v6:map(function(p2: number)
			return p2 + 0.3
		end),
		BackgroundColor3 = Color3.fromHex("#000000"),
		Text = "",
		Selectable = false,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		[React.Event.Activated] = v9,
		ZIndex = 10
	}

	local createElement2 = React.createElement
	local v11 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Position = v6:map(function(p2: number)
			if state4 then
				return UDim2.new(0, 0, -p2, 0)
			end

			return UDim2.new(0, 0, p2, 0)
		end)
	}
	local chatLineReportStep

	if state == Constants.ReportSteps.SELECT then
		chatLineReportStep = React.createElement(ChatLineReportSelectionModalOld, {
			onContinue = onContinue,
			onBack = onBack,
			messages = p.messages,
			selectedMessage = state2,
			setSelectedMessage = setState2,
			analyticsDispatch = analyticsDispatch
		})
	elseif state == Constants.ReportSteps.SUBMIT then
		local createElement3 = React.createElement
		local v12 = {
			analyticsContext = "ReportViaChatLine",
			topCustomComponent = React.createElement(ChatLineReportVerbatim, {
				selectedMessage = state2
			}),
			onSubmitProps = { hasNextSteps = true, onProceedToNextStep = onProceedToNextStep },
			localizationKeys = 0,
			onCloseProps = 0,
			reportCategories = 0,
			onBeforeSubmitAnalytics = 0
		}
		local localizationKeys

		if FFlagGenericAbuseReportingGranularExports then
			localizationKeys = Constants.SubmitDialogLocalizationKeys
		else
			localizationKeys = Constants.GenericAbuseReportingLocalizationKeys
		end

		v12.localizationKeys = localizationKeys

		v12.onCloseProps = { hasPreviousSteps = true, onBackToPreviousStep = onBackToPreviousStep }

		v12.reportCategories = ReportCategories
		function v12.onBeforeSubmitAnalytics(p2)
			return p2
		end

		chatLineReportStep = createElement3(DefaultReportDialog, v12)
	elseif state == Constants.ReportSteps.COMPLETE then
		local createElement3 = React.createElement
		local localizationKeys

		if FFlagGenericAbuseReportingGranularExports then
			localizationKeys = Constants.CompleteDialogLocalizationKeys
		else
			localizationKeys = Constants.GenericAbuseReportingLocalizationKeys
		end

		chatLineReportStep = createElement3(ChatLineReportCompleteModal, {
			localizationKeys = localizationKeys,
			onDismiss = onDismiss,
			selectedMessage = state2
		})
	end

	local element = createElement("TextButton", v10, {
		Frame = createElement2("Frame", v11, { ChatLineReportStep = chatLineReportStep })
	})

	local eventHandlers = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					v9()
					object:cancel()
				end)
			}
		}
	end, { v9 })

	return React.createElement(FocusRoot, {
		eventHandlers = eventHandlers,
		eventMap = navigateBacks,
		isAutoFocusRoot = true,
		isIsolated = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
	}, { ChatLineReportStepHandler = element })
end

return ChatLineReportStepHandler
