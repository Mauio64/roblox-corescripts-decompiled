local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local Players = game:GetService("Players")
local ChatLineReportingParent = ChatLineReporting.Parent
local FocusNavigationUtils = require(ChatLineReportingParent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FocusRoot = FocusNavigationUtils.FocusRoot
local InputHandlers = require(ChatLineReportingParent.InputHandlers)
local React = require(ChatLineReportingParent.React)
local Cryo = require(ChatLineReportingParent.Cryo)
local ReactOtter = require(ChatLineReportingParent.ReactOtter)
local GuiService = game:GetService("GuiService")
local DefaultReportDialog = require(ChatLineReportingParent.GenericAbuseReporting.DefaultReportDialog)
local NotificationModalsManager = require(ChatLineReportingParent.NotificationModalsManager)
local useTokens = require(ChatLineReportingParent.Foundation).Hooks.useTokens
local Images = require(ChatLineReportingParent.UIBlox).App.ImageSet.Images
local useLocalization = require(ChatLineReportingParent.Localization).Hooks.useLocalization
local Constants = require(ChatLineReporting.Common.Constants)
local AnalyticsReducer = require(ChatLineReporting.Common.AnalyticsReducer)
local ChatLineReportAnalytics = require(ChatLineReporting.Common.ChatLineReportAnalytics)
local buildReport = require(ChatLineReporting.Common.buildReport)
local isSystemMessage = require(ChatLineReporting.Common.isSystemMessage)
local ChatLineReportSelectionModal = require(ChatLineReporting.Components.ChatLineReportSelectionModal)
local ChatLineReportSelectionModalOld = require(ChatLineReporting.Components.ChatLineReportSelectionModalOld)
local ChatLineReportVerbatim = require(ChatLineReporting.Components.ChatLineReportVerbatim)
local ChatLineReportCompleteModal = require(ChatLineReporting.Components.ChatLineReportCompleteModal)
local ReportCategories = require(ChatLineReporting.Common.ReportCategories)
local ChatLineSelectionMode = require(ChatLineReporting.Enums.ChatLineSelectionMode)
local FFlagChatLineReportingFocusFixesEnabled = require(ChatLineReportingParent.SharedFlags).FFlagChatLineReportingFocusFixesEnabled
local FFlagChatLineReportingReworkEnabled = require(ChatLineReporting.Flags.FFlagChatLineReportingReworkEnabled)
local EngineFeature = game:GetEngineFeature("SSUIMetaLua")
local FFlagEnableGlobalChatAbuseReporting = require(ChatLineReportingParent.SharedFlags).FFlagEnableGlobalChatAbuseReporting
local FFlagGenericAbuseReportingGranularExports = require(ChatLineReportingParent.SharedFlags).FFlagGenericAbuseReportingGranularExports
local FFlagEnableChatReportingTextChannelTag = require(ChatLineReportingParent.SharedFlags).FFlagEnableChatReportingTextChannelTag
local t1 = {
	stiffness = 400,
	damping = 40,
	mass = 1
}
local t2 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function ChatLineReportStepHandler(t3: {[any]: any}) -- line: 59
	-- upvalues: React (copy), Constants (copy), AnalyticsReducer (copy), GuiService (copy), useLocalization (copy), useTokens (copy), isSystemMessage (copy), FFlagEnableGlobalChatAbuseReporting (copy), EngineFeature (copy), ReactOtter (copy), NotificationModalsManager (copy), Images (copy), t1 (copy), ChatLineReportAnalytics (copy), FFlagEnableChatReportingTextChannelTag (copy), buildReport (copy), Players (copy), Cryo (copy), FFlagChatLineReportingFocusFixesEnabled (copy), FFlagChatLineReportingReworkEnabled (copy), ChatLineReportSelectionModal (copy), ChatLineReportSelectionModalOld (copy), ChatLineSelectionMode (copy), DefaultReportDialog (copy), ChatLineReportVerbatim (copy), FFlagGenericAbuseReportingGranularExports (copy), ReportCategories (copy), ChatLineReportCompleteModal (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), FocusRoot (copy), t2 (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v39, v40 = React.useState(Constants.ReportSteps.SELECT)
	local v41, v42 = React.useState(nil)
	local v43, v44 = React.useReducer(AnalyticsReducer, Constants.AnalyticsInitialState)
	local v45, v46 = React.useState(not GuiService.MenuIsOpen)
	local v47, v48 = React.useState(GuiService.MenuIsOpen)
	local v49, v50 = React.useState(false)
	local v51, v52 = React.useState(nil)
	local v53, v54 = React.useState("")
	local v55 = useLocalization(Constants.ChatLineLocalizationKeys)
	local v56 = useLocalization({
		ChatToastTitleSuccess = {
			"Feature.ReportAbuse.Label.UserTextMuted",
			name = v53
		},
		ChatToastTitleError = {
			"Feature.ReportAbuse.Label.UserTextMutedError",
			name = v53
		},
		ChatToastDescriptionErrorDoesNotExist = {
			"Feature.ReportAbuse.Message.UserTextMutedErrorDoesNotExist",
			name = v53
		}
	})
	local v57 = useTokens()

	React.useEffect(function() -- line: 83
		-- upvalues: v44 (copy), Constants (copy), t3 (copy), isSystemMessage (copy), FFlagEnableGlobalChatAbuseReporting (copy), GuiService (copy), v48 (copy), v46 (copy)
		v44({
			type = Constants.AnalyticsActions.AccumulateForTimeSpent,
			accumulated_time_ms = workspace:GetServerTimeNow() * 1000
		})
		v44({
			type = Constants.AnalyticsActions.SetPlaceId,
			place_id = game.PlaceId
		})

		local ViewportSize = game.Workspace.CurrentCamera.ViewportSize

		v44({
			type = Constants.AnalyticsActions.SetViewportInformation,
			viewport_size_x = ViewportSize.X,
			viewport_size_y = ViewportSize.Y,
			is_portrait_mode = ViewportSize.X < ViewportSize.Y and ViewportSize.X < 800
		})

		local n1 = 0
		local n2 = 0

		for _, v in ipairs(t3.messages) do
			if not isSystemMessage(v) then
				n1 += 1

				if (not FFlagEnableGlobalChatAbuseReporting or v.textChannel) and v.textChannel.Name ~= Constants.ChannelTypes.General then
					n2 += 1
				end
			end
		end

		v44({
			type = Constants.AnalyticsActions.SetChatHistoryInformation,
			selectable_chat_history_size = n1,
			total_chat_history_size = #t3.messages,
			num_non_general_channel_chats = n2
		})

		local connection = GuiService.MenuOpened:Connect(function() -- line: 125
			-- upvalues: v48 (copy), v46 (copy)
			v48(true)
			v46(false)
		end)
		local connection2 = GuiService.MenuClosed:Connect(function() -- line: 129
			-- upvalues: v48 (copy), v46 (copy)
			v48(false)
			v46(true)
		end)

		return function() -- line: 133
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, {})
	React.useEffect(function() -- line: 140
		-- upvalues: EngineFeature (copy), v45 (copy)
		if EngineFeature then
			pcall(function() -- line: 142
				-- upvalues: v45 (copy)
				local SafetyService = game:GetService("SafetyService")

				if v45 then
					SafetyService:ReportChatLineReportingOpen()

					return
				end

				SafetyService:ReportChatLineReportingClose()
			end)
		end
	end, { v45 })

	local v58, v59 = ReactOtter.useAnimatedBinding(1, function() -- line: 153
		-- upvalues: v45 (copy), v49 (copy), v51 (copy), Constants (copy), NotificationModalsManager (copy), Images (copy), v56 (copy), v55 (copy), v57 (copy), t3 (copy)
		if not v45 then
			if v49 then
				if v51 and v51.key == Constants.SuccessfulMuteKey then
					NotificationModalsManager.SetUIBloxToast({
						iconImage = Images[Constants.ToastIconImageSuccess],
						toastTitle = v56.ChatToastTitleSuccess,
						toastSubtitle = v55.ChatToastDescriptionSuccess,
						sequenceNumber = DateTime.now().UnixTimestamp,
						iconColorStyle = {
							Transparency = 0,
							Color = v57.Color.System.Success.Color3
						}
					})
				elseif v51 then
					NotificationModalsManager.SetUIBloxToast({
						iconImage = Images[Constants.ToastIconImageError],
						toastTitle = v56.ChatToastTitleError,
						toastSubtitle = if v51.key ~= Constants.ErrorSelfMuteKey then v56.ChatToastDescriptionErrorDoesNotExist else v55.ChatToastDescriptionErrorSelf,
						sequenceNumber = DateTime.now().UnixTimestamp,
						iconColorStyle = {
							Transparency = 0,
							Color = v57.Color.System.Warning.Color3
						}
					})
				end
			end

			t3.unmount()
		end
	end)
	local v60 = React.useMemo(function() -- line: 189
		-- upvalues: v45 (copy)
		if v45 then
			return 0
		end

		return 1
	end, { v45 })

	React.useEffect(function() -- line: 193
		-- upvalues: v59 (copy), ReactOtter (copy), v60 (copy), t1 (copy)
		v59(ReactOtter.spring(v60, t1))
	end, { v60 })

	local v61 = React.useCallback(function() -- line: 198
		-- upvalues: v41 (copy), v40 (copy), Constants (copy)
		if v41 ~= nil then
			v40(Constants.ReportSteps.SUBMIT)
		end
	end)
	local v62 = React.useCallback(function() -- line: 204
		-- upvalues: ChatLineReportAnalytics (copy), v43 (copy), v46 (copy)
		ChatLineReportAnalytics(v43, 2, false)
		v46(false)
	end, { v43 })
	local v63 = React.useCallback(function() -- line: 211
		-- upvalues: v40 (copy), Constants (copy), v42 (copy)
		v40(Constants.ReportSteps.SELECT)
		v42(nil)
	end)
	local v64 = React.useCallback(function(p1, p2) -- line: 216
		-- upvalues: FFlagEnableChatReportingTextChannelTag (copy), buildReport (copy), Players (copy), v41 (copy), Cryo (copy), t3 (copy), isSystemMessage (copy), v44 (copy), Constants (copy), v40 (copy)
		local t4 = {}
		local v80 = if not FFlagEnableChatReportingTextChannelTag then buildReport(Players.LocalPlayer.UserId, v41.userId, p1, p2, v41.messageId, v41.presetId, v41.presetChatVersion) else buildReport(Players.LocalPlayer.UserId, v41.userId, p1, p2, v41.messageId, v41.presetId, v41.presetChatVersion, if not v41.textChannel then nil else v41.textChannel.Name)

		Cryo.Dictionary.map(t3.messages, function(p3) -- line: 243
			-- upvalues: isSystemMessage (copy), t4 (copy)
			if not isSystemMessage(p3) then
				t4[#t4 + 1] = {
					channel = p3.textChannel,
					messageId = p3.messageId
				}
			end
		end)

		local t5 = {{
			channel = v41.textChannel,
			messageId = v41.messageId
		}}

		v44({
			type = Constants.AnalyticsActions.SetReasonSelection,
			reason_selection = p1
		})
		v44({
			type = Constants.AnalyticsActions.SetCommentAdded,
			comment_added = #p2 > 0
		})
		Players:ReportChatAbuse(t4, t5, v80)
		v40(Constants.ReportSteps.COMPLETE)

		return true
	end, {
		t3.messages,
		v41
	})
	local v65 = React.useCallback(function(p4) -- line: 275
		-- upvalues: ChatLineReportAnalytics (copy), v43 (copy), v52 (copy), v54 (copy), v50 (copy), v46 (copy)
		if p4 then
			ChatLineReportAnalytics(v43, 1, true)
			v52(p4)
			v54(p4.args.RBX_NAME)
			v50(true)
			v46(false)

			return
		end

		ChatLineReportAnalytics(v43, 1, false)
		v46(false)
	end, { v43 })
	local v66 = React.useCallback(function() -- line: 289
		-- upvalues: ChatLineReportAnalytics (copy), v43 (copy), v46 (copy)
		ChatLineReportAnalytics(v43, 1, false)
		v46(false)
	end, { v43 })
	local v67 = if v39 ~= Constants.ReportSteps.COMPLETE then v62 else v66
	local v68 = React.createElement("TextButton", {
		Active = v58:map(function(p5) -- line: 299
			return p5 == 0
		end),
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundTransparency = v58:map(function(n3: number) -- line: 304
			return n3 + 0.3
		end),
		BackgroundColor3 = Color3.fromHex("#000000"),
		Text = "",
		Selectable = not FFlagChatLineReportingFocusFixesEnabled and nil,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		[React.Event.Activated] = v67,
		ZIndex = 10
	}, {
		Frame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Position = v58:map(function(n4: number) -- line: 319
				-- upvalues: v47 (copy)
				if v47 then
					return UDim2.new(0, 0, -n4, 0)
				end

				return UDim2.new(0, 0, n4, 0)
			end)
		}, {
			ChatLineReportStep = if v39 ~= Constants.ReportSteps.SELECT then if v39 ~= Constants.ReportSteps.SUBMIT then if v39 ~= Constants.ReportSteps.COMPLETE then nil else React.createElement(ChatLineReportCompleteModal, {
				localizationKeys = if not FFlagGenericAbuseReportingGranularExports then Constants.GenericAbuseReportingLocalizationKeys else Constants.CompleteDialogLocalizationKeys,
				onDismiss = v65,
				selectedMessage = v41
			}) else React.createElement(DefaultReportDialog, {
				analyticsContext = "ReportViaChatLine",
				topCustomComponent = React.createElement(ChatLineReportVerbatim, {
					selectedMessage = v41
				}),
				onSubmitProps = {
					hasNextSteps = true,
					onProceedToNextStep = v64
				},
				localizationKeys = if not FFlagGenericAbuseReportingGranularExports then Constants.GenericAbuseReportingLocalizationKeys else Constants.SubmitDialogLocalizationKeys,
				onCloseProps = {
					hasPreviousSteps = true,
					onBackToPreviousStep = v63
				},
				reportCategories = ReportCategories,
				onBeforeSubmitAnalytics = function(p6) -- line: 359
					return p6
				end
			}) else React.createElement(if not FFlagChatLineReportingReworkEnabled then ChatLineReportSelectionModalOld else ChatLineReportSelectionModal, {
				onContinue = v61,
				onBack = v62,
				messages = t3.messages,
				selectedMessage = v41,
				setSelectedMessage = v42,
				analyticsDispatch = v44,
				mode = ChatLineSelectionMode.Radio
			})
		})
	})

	if FFlagChatLineReportingFocusFixesEnabled then
		local v69 = React.useMemo(function() -- line: 378
			-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v67 (copy)
			return {
				[FocusNavigationEventNameEnum.NavigateBack] = {
					handler = InputHandlers.onRelease(function(p7) -- line: 381
						-- upvalues: v67 (copy)
						v67()
						p7:cancel()
					end)
				}
			}
		end, { v67 })

		return React.createElement(FocusRoot, {
			isAutoFocusRoot = true,
			isIsolated = true,
			eventHandlers = v69,
			eventMap = t2,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
		}, {
			ChatLineReportStepHandler = v68
		})
	end

	return v68
end

return ChatLineReportStepHandler
