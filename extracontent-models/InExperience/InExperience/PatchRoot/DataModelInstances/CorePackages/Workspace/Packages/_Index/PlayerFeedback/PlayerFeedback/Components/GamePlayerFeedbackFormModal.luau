local PlayerFeedback = script:FindFirstAncestor("PlayerFeedback")
local PlayerFeedbackParent = PlayerFeedback.Parent
local React = require(PlayerFeedbackParent.React)
local UIBlox = require(PlayerFeedbackParent.UIBlox)
local Checkbox = require(PlayerFeedbackParent.Foundation).Checkbox
local useStyle = UIBlox.Core.Style.useStyle
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local VerticalScrollView = UIBlox.App.Container.VerticalScrollView
local ButtonStack = UIBlox.App.Button.ButtonStack
local Cryo = require(PlayerFeedbackParent.Cryo)
local ArgCheck = require(PlayerFeedbackParent.ArgCheck)
local t = require(PlayerFeedbackParent.t)
local CloseCentralOverlay = require(PlayerFeedbackParent.CentralOverlay).Thunks.CloseCentralOverlay
local useSelector = require(PlayerFeedbackParent.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(PlayerFeedbackParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(PlayerFeedbackParent.Localization).Hooks.useLocalization
local useRoactService = require(PlayerFeedbackParent.RobloxAppHooks).useRoactService
local RoactServiceTags = require(PlayerFeedbackParent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local RoactNetworking = RoactServiceTags.RoactNetworking
local ToastRodux = require(PlayerFeedbackParent.ToastRodux)
local SetNetworkingErrorToast = require(PlayerFeedbackParent.RobloxAppToastsRodux).Thunks.SetNetworkingErrorToast
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local NavigateDown = require(PlayerFeedbackParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(PlayerFeedbackParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v27 = if not FFlagSignalsNavP3Dispatch then nil else require(PlayerFeedbackParent.RobloxAppNavigation).NavigationCommands
local AppPage = require(PlayerFeedbackParent.RobloxAppEnums).AppPage
local UrlBuilder = require(PlayerFeedbackParent.UrlBuilder).UrlBuilder
local GetFFlagEdpPlayerFeedbackCommentsOnly = require(PlayerFeedbackParent.SharedFlags).GetFFlagEdpPlayerFeedbackCommentsOnly
local UserInputService = game:GetService("UserInputService")
local SubmitGamePlayerFeedback = require(PlayerFeedback.Thunks.SubmitGamePlayerFeedback)

require(PlayerFeedback.Types)

local PlayerFeedbackEvents = require(PlayerFeedback.Analytics.Events.PlayerFeedbackEvents)
local AbuseVector = require(PlayerFeedbackParent.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(PlayerFeedbackParent.GenericAbuseReporting.OpenDynamicAbuseReport)
local FFlagEnableAbuseReportRevampFlow = require(PlayerFeedbackParent.SharedFlags).FFlagEnableAbuseReportRevampFlow
local v37 = game:DefineFastFlag("EnableAbuseReportRevampFeedback", false)
local FFlagAddThumbnailSelectorReport = require(PlayerFeedbackParent.SharedFlags).FFlagAddThumbnailSelectorReport
local v39 = game:DefineFastFlag("AddThumbnailReportToPlayerFeedback", false)
local useState = React.useState
local useEffect = React.useEffect

local function CategoryCheckboxes(t1: {[any]: any}) -- line: 70
	-- upvalues: React (copy), Cryo (copy), Checkbox (copy)
	local category = t1.category
	local selectedCategoryIds = t1.selectedCategoryIds
	local onOptionSelected = t1.onOptionSelected
	local t2 = {
		layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, -8)
		})
	}
	local v51 = React.useCallback(function(p1) -- line: 82
		-- upvalues: Cryo (copy), selectedCategoryIds (copy), onOptionSelected (copy)
		return function(p2) -- line: 83
			-- upvalues: Cryo (copy), selectedCategoryIds (copy), p1 (copy), onOptionSelected (copy)
			local v119 = if not p2 then Cryo.List.filter(selectedCategoryIds, function(p3) -- line: 88
				-- upvalues: p1 (copy)
				return p3 ~= p1
			end) else Cryo.List.join(selectedCategoryIds, { p1 })

			onOptionSelected(v119)
		end
	end, { selectedCategoryIds })

	for i, v in ipairs(category.options) do
		t2["Checkbox" .. i] = React.createElement(Checkbox, {
			label = v.label,
			isChecked = Cryo.List.find(selectedCategoryIds, v.id) ~= nil,
			onActivated = v51(v.id),
			LayoutOrder = i
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0)
	}, t2)
end
local function getTextLength(s1: string) -- line: 118
	if utf8.len(s1) then
		return (utf8.len(utf8.nfcnormalize(s1)))
	end

	return (string.len(s1))
end

local v44 = ArgCheck.wrap(t.interface({
	closeCentralOverlayThunk = t.callback,
	universeId = t.string,
	playerFeedbackMetadata = t.strictInterface({
		rootPlaceId = t.string,
		canSubmitReview = t.boolean,
		canSubmitComment = t.boolean,
		categoryType = t.string,
		category = t.interface({
			type = t.string,
			label = t.string,
			allows_multiple_selections = t.boolean,
			options = t.array(t.interface({
				id = t.string,
				label = t.string
			}))
		}),
		comment = t.interface({
			label = t.string,
			placeholder_text = t.string,
			minimum_length = t.number,
			maximum_length = t.number
		}),
		metadata = t.interface({
			disclaimer_label = t.string,
			submit_button_label = t.string,
			form_title_label = t.string
		})
	}),
	onSubmitted = t.optional(t.callback)
}))

local function GamePlayerFeedbackFormModal(t3: {[any]: any}) -- line: 154
	-- upvalues: v44 (copy), useStyle (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), AppEventIngestService (copy), useSelector (copy), useState (copy), React (copy), GetFFlagEdpPlayerFeedbackCommentsOnly (copy), useLocalization (copy), useEffect (copy), PlayerFeedbackEvents (copy), SubmitGamePlayerFeedback (copy), SetCurrentToastMessage (copy), SetNetworkingErrorToast (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), FFlagAddThumbnailSelectorReport (copy), v39 (copy), CloseCentralOverlay (copy), AppPage (copy), UrlBuilder (copy), FFlagSignalsNavP3Dispatch (copy), v27 (copy), NavigateDown (copy), UserInputService (copy), PartialPageModal (copy), VerticalScrollView (copy), CategoryCheckboxes (copy), ButtonStack (copy), ButtonType (copy), FFlagEnableAbuseReportRevampFlow (copy), v37 (copy)
	assert(v44(t3))

	local v56 = useStyle()
	local v57 = useDispatch()
	local v58 = useRoactService(RoactNetworking)
	local v59 = useRoactService(AppEventIngestService)
	local Tokens = v56.Tokens
	local v61 = useSelector(function(p4) -- line: 163
		return p4.ScreenSize
	end)
	local v62 = useSelector(function(p5) -- line: 166
		local GlobalGuiInset = p5.GlobalGuiInset

		return GlobalGuiInset and GlobalGuiInset.bottom or 0
	end)
	local v63, v64 = useState(false)
	local v65, v66 = useState(0)
	local v67 = v63 and -v65 + v62 or 0
	local v68 = not v63 and 48 or 0
	local v69, v70 = useState(0)
	local v71 = React.useRef(nil)
	local v72 = React.useRef(nil)
	local v73 = v61.Y - v65 - 48 - 48 - 48 - v68
	local playerFeedbackMetadata = t3.playerFeedbackMetadata
	local categoryType = playerFeedbackMetadata.categoryType
	local category = playerFeedbackMetadata.category
	local metadata = playerFeedbackMetadata.metadata
	local comment = playerFeedbackMetadata.comment
	local rootPlaceId = playerFeedbackMetadata.rootPlaceId
	local v80, v81 = useState("")
	local v82 = if not GetFFlagEdpPlayerFeedbackCommentsOnly() then {} else { "Other" }
	local v83, v84 = useState(v82)
	local v85 = playerFeedbackMetadata.canSubmitComment and #v83 > 0
	local v86, v87 = useState(nil)
	local v88 = useLocalization({
		abuseReportPromptText = "PlayerFeedbacks.VoteForm.Message.ReportAbuseInsteadLong",
		reportFlowPageTitle = "PlayerFeedbacks.VoteForm.Message.Action.Report",
		commentTooLongMessage = {
			"PlayerFeedbacks.VoteForm.Message.MaxLengthCharacters",
			count = comment.maximum_length
		},
		commentTooShortMessage = {
			"PlayerFeedbacks.VoteForm.Message.MinLengthCharacters",
			count = comment.minimum_length
		}
	})
	local v89 = #v83 > 0 and v86 == nil

	if GetFFlagEdpPlayerFeedbackCommentsOnly() then
		v89 = #v83 > 0 and (((if not utf8.len(v80) then string.len(v80) else utf8.len(utf8.nfcnormalize(v80)))) > 0 and v86 == nil)

		local v90, v91 = useState(false)

		useEffect(function() -- line: 214
			-- upvalues: v90 (copy), v72 (copy), v91 (copy)
			task.defer(function() -- line: 216
				-- upvalues: v90 (copy), v72 (copy), v91 (copy)
				if not v90 and v72.current then
					v91(true)
					v72.current:CaptureFocus()
				end
			end)
		end, {
			v72,
			v90
		})
	end

	local v92 = React.useCallback(function() -- line: 225
		-- upvalues: v57 (copy), t3 (copy)
		v57(t3.closeCentralOverlayThunk())
	end, { t3.closeCentralOverlayThunk })
	local v93 = React.useCallback(function() -- line: 229
		-- upvalues: PlayerFeedbackEvents (copy), v59 (copy), rootPlaceId (copy), categoryType (copy), v92 (copy)
		PlayerFeedbackEvents.DismissPlayerFeedbackFormModal(v59, rootPlaceId, {
			categoryType = categoryType
		})
		v92()
	end, {
		v92,
		categoryType,
		rootPlaceId,
		v59
	})
	local v94 = React.useCallback(function(p6) -- line: 234
		-- upvalues: PlayerFeedbackEvents (copy), v59 (copy), rootPlaceId (copy), categoryType (copy), v84 (copy)
		PlayerFeedbackEvents.TogglePlayerFeedbackFormModalReason(v59, rootPlaceId, {
			categoryType = categoryType
		})
		v84(p6)
	end, {})
	local v95 = React.useCallback(function() -- line: 244
		-- upvalues: PlayerFeedbackEvents (copy), v59 (copy), rootPlaceId (copy), categoryType (copy), v83 (copy), GetFFlagEdpPlayerFeedbackCommentsOnly (copy), v80 (copy), v87 (copy), v88 (copy), comment (copy), v57 (copy), SubmitGamePlayerFeedback (copy), v58 (copy), SetCurrentToastMessage (copy), t3 (copy), v92 (copy), SetNetworkingErrorToast (copy)
		PlayerFeedbackEvents.ClickPlayerFeedbackFormModalSubmit(v59, rootPlaceId, {
			categoryType = categoryType
		})

		if #v83 == 0 then
			return
		end

		if GetFFlagEdpPlayerFeedbackCommentsOnly() then
			local v106 = v80

			if ((if not utf8.len(v106) then string.len(v106) else utf8.len(utf8.nfcnormalize(v106)))) == 0 then
				PlayerFeedbackEvents.SubmitPlayerFeedbackFailCommentValidation(v59, rootPlaceId, {
					value = "CommentTooShort",
					categoryType = categoryType
				})
				v87(v88.commentTooShortMessage)

				return
			end
		end

		local v107 = v80

		if ((if not utf8.len(v107) then string.len(v107) else utf8.len(utf8.nfcnormalize(v107)))) > 0 then
			local v108 = v80

			if ((if not utf8.len(v108) then string.len(v108) else utf8.len(utf8.nfcnormalize(v108)))) < comment.minimum_length then
				PlayerFeedbackEvents.SubmitPlayerFeedbackFailCommentValidation(v59, rootPlaceId, {
					value = "CommentTooShort",
					categoryType = categoryType
				})
				v87(v88.commentTooShortMessage)

				return
			end
		end

		local v109 = v80

		if ((if not utf8.len(v109) then string.len(v109) else utf8.len(utf8.nfcnormalize(v109)))) > comment.maximum_length then
			PlayerFeedbackEvents.SubmitPlayerFeedbackFailCommentValidation(v59, rootPlaceId, {
				value = "CommentTooLong",
				categoryType = categoryType
			})
			v87(v88.commentTooLongMessage)

			return
		end

		v57(SubmitGamePlayerFeedback.Post(v58, rootPlaceId, categoryType, v83, v80)):andThen(function(_) -- line: 284
			-- upvalues: v57 (copy), SetCurrentToastMessage (copy), t3 (copy), v92 (copy)
			v57(SetCurrentToastMessage({
				toastMessage = "PlayerFeedbacks.VoteForm.Message.SubmitSuccess"
			}))

			if t3.onSubmitted then
				t3.onSubmitted()
			end

			v92()
		end, function(p8) -- line: 292
			-- upvalues: v57 (copy), SetNetworkingErrorToast (copy)
			v57(SetNetworkingErrorToast(p8))
		end)
	end, {
		v58,
		v59,
		comment.maximum_length,
		comment.minimum_length,
		v88.commentTooShortMessage,
		v88.commentTooLongMessage,
		rootPlaceId,
		categoryType,
		v83,
		v80,
		t3.onSubmitted,
		v92
	})

	useEffect(function() -- line: 312
		-- upvalues: PlayerFeedbackEvents (copy), v59 (copy), rootPlaceId (copy), categoryType (copy)
		PlayerFeedbackEvents.PlayerFeedbackFormModalMounted(v59, rootPlaceId, {
			categoryType = categoryType
		})
	end, {
		v59,
		rootPlaceId,
		categoryType
	})

	local v96 = React.useCallback(function() -- line: 316
		-- upvalues: PlayerFeedbackEvents (copy), v59 (copy), rootPlaceId (copy), categoryType (copy)
		PlayerFeedbackEvents.FocusPlayerFeedbackFormModalComment(v59, rootPlaceId, {
			categoryType = categoryType
		})
	end, {
		v59,
		rootPlaceId,
		categoryType
	})
	local v97 = React.useCallback(function() -- line: 324
		-- upvalues: PlayerFeedbackEvents (copy), v59 (copy), rootPlaceId (copy), categoryType (copy), v57 (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), FFlagAddThumbnailSelectorReport (copy), v39 (copy), t3 (copy), CloseCentralOverlay (copy)
		PlayerFeedbackEvents.ClickPlayerFeedbackFormAbuseReportPrompt(v59, rootPlaceId, {
			categoryType = categoryType
		})
		v57(OpenDynamicAbuseReport({
			abuseVector = AbuseVector.Place,
			targetId = rootPlaceId,
			custom = if not FFlagAddThumbnailSelectorReport or not v39 then nil else {
				universeId = t3.universeId
			},
			onClose = function() -- line: 338
				-- upvalues: v57 (copy), CloseCentralOverlay (copy)
				v57(CloseCentralOverlay())
			end
		}))
	end, {
		v59,
		rootPlaceId,
		categoryType,
		rootPlaceId
	})
	local v98 = React.useCallback(function() -- line: 344
		-- upvalues: PlayerFeedbackEvents (copy), v59 (copy), rootPlaceId (copy), categoryType (copy), AppPage (copy), UrlBuilder (copy), v88 (copy), FFlagSignalsNavP3Dispatch (copy), v27 (copy), v57 (copy), NavigateDown (copy), v92 (copy)
		PlayerFeedbackEvents.ClickPlayerFeedbackFormAbuseReportPrompt(v59, rootPlaceId, {
			categoryType = categoryType
		})

		local t4 = {
			name = AppPage.GenericWebPage,
			detail = UrlBuilder.game.report({
				placeId = rootPlaceId
			}),
			extraProps = {
				title = v88.reportFlowPageTitle
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v27.down(v27.fromLegacyPage(t4))
		else
			v57(NavigateDown(t4))
		end

		v92()
	end, {
		v59,
		rootPlaceId,
		categoryType,
		v92
	})
	local v99 = React.useCallback(function() -- line: 366
		-- upvalues: PlayerFeedbackEvents (copy), v59 (copy), rootPlaceId (copy), categoryType (copy), AppPage (copy), UrlBuilder (copy), FFlagSignalsNavP3Dispatch (copy), v27 (copy), v57 (copy), NavigateDown (copy), v92 (copy)
		PlayerFeedbackEvents.ClickPlayerFeedbackFormModalDisclaimer(v59, rootPlaceId, {
			categoryType = categoryType
		})

		local t5 = {
			name = AppPage.GenericWebPage,
			detail = UrlBuilder.static.about.terms()
		}

		if FFlagSignalsNavP3Dispatch then
			v27.down(v27.fromLegacyPage(t5))
		else
			v57(NavigateDown(t5))
		end

		v92()
	end, {
		v59,
		rootPlaceId,
		categoryType,
		v92
	})
	local v100 = React.useCallback(function(p9) -- line: 384
		-- upvalues: v81 (copy), comment (copy), v86 (copy), v87 (copy)
		local p9Text = p9.Text

		v81(p9Text)

		local v114 = if not utf8.len(p9Text) then string.len(p9Text) else utf8.len(utf8.nfcnormalize(p9Text))
		local v115 = v114 == 0 or v114 >= comment.minimum_length and v114 <= comment.maximum_length

		if v86 and v115 then
			v87(nil)
		end
	end, {
		v86,
		comment.minimum_length,
		comment.maximum_length
	})

	useEffect(function() -- line: 396
		-- upvalues: v71 (copy), v65 (copy)
		if not v71 or (not v71.current or v65 == 0) then
			return
		end

		v71.current.CanvasPosition = Vector2.new(0, v71.current.AbsoluteCanvasSize.Y)
	end, {
		v71,
		v65
	})
	useEffect(function() -- line: 404
		-- upvalues: UserInputService (copy), v64 (copy), v66 (copy)
		local connection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function() -- line: 407
			-- upvalues: v64 (copy), UserInputService (copy), v66 (copy)
			v64(UserInputService.OnScreenKeyboardVisible)
			v66(UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0)
		end)

		return function() -- line: 414
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end

			connection = nil
		end
	end, {})

	return React.createElement(PartialPageModal, {
		marginSize = 0,
		title = metadata.form_title_label,
		screenSize = v61,
		onCloseClicked = v93,
		position = v63 and UDim2.new(0.5, 0, 1, v67) or nil,
		anchorPoint = v63 and Vector2.new(0.5, 1) or nil
	}, {
		Content = React.createElement(VerticalScrollView, {
			useAutomaticCanvasSize = true,
			size = UDim2.new(1, 0, 0, (math.min(v69 + 25, v73))),
			canvasSizeY = UDim.new(),
			elasticBehavior = Enum.ElasticBehavior.Never,
			scrollingFrameRef = v71,
			ref = v71
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, 16),
				[React.Change.AbsoluteContentSize] = function(p10) -- line: 448
					-- upvalues: v70 (copy)
					v70(p10.AbsoluteContentSize.Y)
				end
			}),
			ContentPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 24),
				PaddingLeft = UDim.new(0, 24),
				PaddingRight = UDim.new(0, 24)
			}),
			CheckboxesLabel = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				LayoutOrder = 0,
				Text = category.label,
				TextSize = v56.Font.BaseSize,
				TextColor3 = Tokens.Color.Content.Emphasis.Color3,
				TextTransparency = Tokens.Color.Content.Emphasis.Transparency,
				Font = Tokens.Typography.TitleLarge.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}),
			CategoryCheckboxes = if not GetFFlagEdpPlayerFeedbackCommentsOnly() then React.createElement(CategoryCheckboxes, {
				layoutOrder = 1,
				category = category,
				selectedCategoryIds = v83,
				onOptionSelected = v94
			}) else nil,
			CommmentLabel = if not GetFFlagEdpPlayerFeedbackCommentsOnly() then v85 and React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				LayoutOrder = 2,
				Text = comment.label,
				TextSize = v56.Font.BaseSize,
				TextColor3 = Tokens.Color.Content.Emphasis.Color3,
				TextTransparency = Tokens.Color.Content.Emphasis.Transparency,
				Font = Tokens.Typography.TitleLarge.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}) else nil,
			Commment = v85 and React.createElement("Frame", {
				BorderSizePixel = 1,
				LayoutOrder = 3,
				BackgroundColor3 = Tokens.Color.Surface.Surface_200.Color3,
				BackgroundTransparency = Tokens.Color.Surface.Surface_200.Transparency,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, Tokens.Radius.Small)
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 8),
					PaddingBottom = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8)
				}),
				TextBox = React.createElement("TextBox", {
					Text = v80,
					PlaceholderText = comment.placeholder_text,
					PlaceholderColor3 = v56.Theme.TextMuted.Color,
					Size = UDim2.new(1, 0, 0, 100),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					ClearTextOnFocus = false,
					MultiLine = true,
					TextWrapped = true,
					ClipsDescendants = true,
					OverlayNativeInput = true,
					TextColor3 = Tokens.Color.Content.Emphasis.Color3,
					TextTransparency = Tokens.Color.Content.Emphasis.Transparency,
					BackgroundColor3 = Tokens.Color.Surface.Surface_200.Color3,
					BackgroundTransparency = Tokens.Color.Surface.Surface_200.Transparency,
					Font = Tokens.Typography.BodyLarge.Font,
					TextSize = Tokens.Typography.BodyLarge.FontSize,
					AutomaticSize = Enum.AutomaticSize.Y,
					BorderSizePixel = 0,
					ref = v72,
					[React.Change.Text] = v100,
					[React.Event.Focused] = v96
				})
			}),
			HelperText = if not v85 or v86 == nil then nil else React.createElement("TextLabel", {
				TextWrapped = true,
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				Text = v86,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextColor3 = v56.Theme.Alert.Color,
				Font = Tokens.Typography.CaptionSmall.Font,
				TextSize = Tokens.Typography.CaptionLarge.FontSize,
				LineHeight = Tokens.Typography.CaptionSmall.LineHeight,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}),
			Buttons = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 5,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				ButtonStack = React.createElement(ButtonStack, {
					buttons = {{
						buttonType = ButtonType.PrimaryContextual,
						props = {
							onActivated = v95,
							isDisabled = v89 == false,
							text = metadata.submit_button_label
						}
					}}
				})
			}),
			DisclaimerText = React.createElement("TextButton", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				Font = v56.Font.CaptionHeader.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				Text = metadata.disclaimer_label,
				[React.Event.Activated] = v99,
				RichText = true,
				TextSize = Tokens.Typography.CaptionLarge.FontSize,
				TextColor3 = v56.Theme.TextMuted.Color,
				TextTransparency = v56.Theme.TextMuted.Transparency,
				LineHeight = Tokens.LineHeight.LineHeight_140,
				LayoutOrder = 6
			}),
			AbuseReportPromptText = categoryType == "Downvote" and React.createElement("TextButton", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				Text = v88.abuseReportPromptText,
				[React.Event.Activated] = if not FFlagEnableAbuseReportRevampFlow or not v37 then v98 else v97,
				RichText = true,
				TextSize = Tokens.Typography.CaptionLarge.FontSize,
				TextColor3 = v56.Theme.TextMuted.Color,
				TextTransparency = v56.Theme.TextMuted.Transparency,
				Font = Tokens.Typography.BodyLarge.Font,
				LineHeight = Tokens.LineHeight.LineHeight_140,
				LayoutOrder = 7
			})
		})
	})
end

return GamePlayerFeedbackFormModal
