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
local t1 = {
	stiffness = 400,
	damping = 40,
	mass = 1
}
local t2 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function ChatLineReportStepHandler(t3: {[any]: any}) -- line: 58
	-- upvalues: React (copy), Constants (copy), AnalyticsReducer (copy), GuiService (copy), useLocalization (copy), useTokens (copy), isSystemMessage (copy), FFlagEnableGlobalChatAbuseReporting (copy), EngineFeature (copy), ReactOtter (copy), NotificationModalsManager (copy), Images (copy), t1 (copy), ChatLineReportAnalytics (copy), buildReport (copy), Players (copy), Cryo (copy), FFlagChatLineReportingFocusFixesEnabled (copy), FFlagChatLineReportingReworkEnabled (copy), ChatLineReportSelectionModal (copy), ChatLineReportSelectionModalOld (copy), ChatLineSelectionMode (copy), DefaultReportDialog (copy), ChatLineReportVerbatim (copy), FFlagGenericAbuseReportingGranularExports (copy), ReportCategories (copy), ChatLineReportCompleteModal (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), FocusRoot (copy), t2 (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v38, v39 = React.useState(Constants.ReportSteps.SELECT)
	local v40, v41 = React.useState(nil)
	local v42, v43 = React.useReducer(AnalyticsReducer, Constants.AnalyticsInitialState)
	local v44, v45 = React.useState(not GuiService.MenuIsOpen)
	local v46, v47 = React.useState(GuiService.MenuIsOpen)
	local v48, v49 = React.useState(false)
	local v50, v51 = React.useState(nil)
	local v52, v53 = React.useState("")
	local v54 = useLocalization(Constants.ChatLineLocalizationKeys)
	local v55 = useLocalization({
		ChatToastTitleSuccess = {
			"Feature.ReportAbuse.Label.UserTextMuted",
			name = v52
		},
		ChatToastTitleError = {
			"Feature.ReportAbuse.Label.UserTextMutedError",
			name = v52
		},
		ChatToastDescriptionErrorDoesNotExist = {
			"Feature.ReportAbuse.Message.UserTextMutedErrorDoesNotExist",
			name = v52
		}
	})
	local v56 = useTokens()

	React.useEffect(function() -- line: 82
		-- upvalues: v43 (copy), Constants (copy), t3 (copy), isSystemMessage (copy), FFlagEnableGlobalChatAbuseReporting (copy), GuiService (copy), v47 (copy), v45 (copy)
		v43({
			type = Constants.AnalyticsActions.AccumulateForTimeSpent,
			accumulated_time_ms = workspace:GetServerTimeNow() * 1000
		})
		v43({
			type = Constants.AnalyticsActions.SetPlaceId,
			place_id = game.PlaceId
		})

		local ViewportSize = game.Workspace.CurrentCamera.ViewportSize

		v43({
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

		v43({
			type = Constants.AnalyticsActions.SetChatHistoryInformation,
			selectable_chat_history_size = n1,
			total_chat_history_size = #t3.messages,
			num_non_general_channel_chats = n2
		})

		local connection = GuiService.MenuOpened:Connect(function() -- line: 124
			-- upvalues: v47 (copy), v45 (copy)
			v47(true)
			v45(false)
		end)
		local connection2 = GuiService.MenuClosed:Connect(function() -- line: 128
			-- upvalues: v47 (copy), v45 (copy)
			v47(false)
			v45(true)
		end)

		return function() -- line: 132
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, {})
	React.useEffect(function() -- line: 139
		-- upvalues: EngineFeature (copy), v44 (copy)
		if EngineFeature then
			pcall(function() -- line: 141
				-- upvalues: v44 (copy)
				local SafetyService = game:GetService("SafetyService")

				if v44 then
					SafetyService:ReportChatLineReportingOpen()

					return
				end

				SafetyService:ReportChatLineReportingClose()
			end)
		end
	end, { v44 })

	local v57, v58 = ReactOtter.useAnimatedBinding(1, function() -- line: 152
		-- upvalues: v44 (copy), v48 (copy), v50 (copy), Constants (copy), NotificationModalsManager (copy), Images (copy), v55 (copy), v54 (copy), v56 (copy), t3 (copy)
		if not v44 then
			if v48 then
				if v50 and v50.key == Constants.SuccessfulMuteKey then
					NotificationModalsManager.SetUIBloxToast({
						iconImage = Images[Constants.ToastIconImageSuccess],
						toastTitle = v55.ChatToastTitleSuccess,
						toastSubtitle = v54.ChatToastDescriptionSuccess,
						sequenceNumber = DateTime.now().UnixTimestamp,
						iconColorStyle = {
							Transparency = 0,
							Color = v56.Color.System.Success.Color3
						}
					})
				elseif v50 then
					NotificationModalsManager.SetUIBloxToast({
						iconImage = Images[Constants.ToastIconImageError],
						toastTitle = v55.ChatToastTitleError,
						toastSubtitle = if v50.key ~= Constants.ErrorSelfMuteKey then v55.ChatToastDescriptionErrorDoesNotExist else v54.ChatToastDescriptionErrorSelf,
						sequenceNumber = DateTime.now().UnixTimestamp,
						iconColorStyle = {
							Transparency = 0,
							Color = v56.Color.System.Warning.Color3
						}
					})
				end
			end

			t3.unmount()
		end
	end)
	local v59 = React.useMemo(function() -- line: 188
		-- upvalues: v44 (copy)
		if v44 then
			return 0
		end

		return 1
	end, { v44 })

	React.useEffect(function() -- line: 192
		-- upvalues: v58 (copy), ReactOtter (copy), v59 (copy), t1 (copy)
		v58(ReactOtter.spring(v59, t1))
	end, { v59 })

	local v60 = React.useCallback(function() -- line: 197
		-- upvalues: v40 (copy), v39 (copy), Constants (copy)
		if v40 ~= nil then
			v39(Constants.ReportSteps.SUBMIT)
		end
	end)
	local v61 = React.useCallback(function() -- line: 203
		-- upvalues: ChatLineReportAnalytics (copy), v42 (copy), v45 (copy)
		ChatLineReportAnalytics(v42, 2, false)
		v45(false)
	end, { v42 })
	local v62 = React.useCallback(function() -- line: 210
		-- upvalues: v39 (copy), Constants (copy), v41 (copy)
		v39(Constants.ReportSteps.SELECT)
		v41(nil)
	end)
	local v63 = React.useCallback(function(p1, p2) -- line: 215
		-- upvalues: buildReport (copy), Players (copy), v40 (copy), Cryo (copy), t3 (copy), isSystemMessage (copy), v43 (copy), Constants (copy), v39 (copy)
		local t4 = {}
		local v79 = buildReport(Players.LocalPlayer.UserId, v40.userId, p1, p2, v40.messageId, v40.presetId, v40.presetChatVersion)

		Cryo.Dictionary.map(t3.messages, function(p3) -- line: 228
			-- upvalues: isSystemMessage (copy), t4 (copy)
			if not isSystemMessage(p3) then
				t4[#t4 + 1] = {
					channel = p3.textChannel,
					messageId = p3.messageId
				}
			end
		end)

		local t5 = {{
			channel = v40.textChannel,
			messageId = v40.messageId
		}}

		v43({
			type = Constants.AnalyticsActions.SetReasonSelection,
			reason_selection = p1
		})
		v43({
			type = Constants.AnalyticsActions.SetCommentAdded,
			comment_added = #p2 > 0
		})
		Players:ReportChatAbuse(t4, t5, v79)
		v39(Constants.ReportSteps.COMPLETE)

		return true
	end, {
		t3.messages,
		v40
	})
	local v64 = React.useCallback(function(p4) -- line: 260
		-- upvalues: ChatLineReportAnalytics (copy), v42 (copy), v51 (copy), v53 (copy), v49 (copy), v45 (copy)
		if p4 then
			ChatLineReportAnalytics(v42, 1, true)
			v51(p4)
			v53(p4.args.RBX_NAME)
			v49(true)
			v45(false)

			return
		end

		ChatLineReportAnalytics(v42, 1, false)
		v45(false)
	end, { v42 })
	local v65 = React.useCallback(function() -- line: 274
		-- upvalues: ChatLineReportAnalytics (copy), v42 (copy), v45 (copy)
		ChatLineReportAnalytics(v42, 1, false)
		v45(false)
	end, { v42 })
	local v66 = if v38 ~= Constants.ReportSteps.COMPLETE then v61 else v65
	local v67 = React.createElement("TextButton", {
		Active = v57:map(function(p5) -- line: 284
			return p5 == 0
		end),
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundTransparency = v57:map(function(n3: number) -- line: 289
			return n3 + 0.3
		end),
		BackgroundColor3 = Color3.fromHex("#000000"),
		Text = "",
		Selectable = not FFlagChatLineReportingFocusFixesEnabled and nil,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		[React.Event.Activated] = v66,
		ZIndex = 10
	}, {
		Frame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Position = v57:map(function(n4: number) -- line: 304
				-- upvalues: v46 (copy)
				if v46 then
					return UDim2.new(0, 0, -n4, 0)
				end

				return UDim2.new(0, 0, n4, 0)
			end)
		}, {
			ChatLineReportStep = if v38 ~= Constants.ReportSteps.SELECT then if v38 ~= Constants.ReportSteps.SUBMIT then if v38 ~= Constants.ReportSteps.COMPLETE then nil else React.createElement(ChatLineReportCompleteModal, {
				localizationKeys = if not FFlagGenericAbuseReportingGranularExports then Constants.GenericAbuseReportingLocalizationKeys else Constants.CompleteDialogLocalizationKeys,
				onDismiss = v64,
				selectedMessage = v40
			}) else React.createElement(DefaultReportDialog, {
				analyticsContext = "ReportViaChatLine",
				topCustomComponent = React.createElement(ChatLineReportVerbatim, {
					selectedMessage = v40
				}),
				onSubmitProps = {
					hasNextSteps = true,
					onProceedToNextStep = v63
				},
				localizationKeys = if not FFlagGenericAbuseReportingGranularExports then Constants.GenericAbuseReportingLocalizationKeys else Constants.SubmitDialogLocalizationKeys,
				onCloseProps = {
					hasPreviousSteps = true,
					onBackToPreviousStep = v62
				},
				reportCategories = ReportCategories,
				onBeforeSubmitAnalytics = function(p6) -- line: 344
					return p6
				end
			}) else React.createElement(if not FFlagChatLineReportingReworkEnabled then ChatLineReportSelectionModalOld else ChatLineReportSelectionModal, {
				onContinue = v60,
				onBack = v61,
				messages = t3.messages,
				selectedMessage = v40,
				setSelectedMessage = v41,
				analyticsDispatch = v43,
				mode = ChatLineSelectionMode.Radio
			})
		})
	})

	if FFlagChatLineReportingFocusFixesEnabled then
		local v68 = React.useMemo(function() -- line: 363
			-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v66 (copy)
			return {
				[FocusNavigationEventNameEnum.NavigateBack] = {
					handler = InputHandlers.onRelease(function(p7) -- line: 366
						-- upvalues: v66 (copy)
						v66()
						p7:cancel()
					end)
				}
			}
		end, { v66 })

		return React.createElement(FocusRoot, {
			isAutoFocusRoot = true,
			isIsolated = true,
			eventHandlers = v68,
			eventMap = t2,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
		}, {
			ChatLineReportStepHandler = v67
		})
	end

	return v67
end

return ChatLineReportStepHandler
