local PlayerFeedback = script:FindFirstAncestor("PlayerFeedback")
local parent = PlayerFeedback.Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Checkbox = Foundation.Checkbox
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local useStyle = UIBlox.Core.Style.useStyle
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local VerticalScrollView = UIBlox.App.Container.VerticalScrollView

local ButtonStack = UIBlox.App.Button.ButtonStack
local Cryo = require(parent.Cryo)
local ArgCheck = require(parent.ArgCheck)
local t = require(parent.t)
local CentralOverlay = require(parent.CentralOverlay)
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local RoactUtils2 = require(parent.RoactUtils)
local useDispatch = RoactUtils2.Hooks.RoactRodux.useDispatch
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local RoactNetworking = RoactServiceTags.RoactNetworking
local ToastRodux = require(parent.ToastRodux)
local RobloxAppToastsRodux = require(parent.RobloxAppToastsRodux)
local SetNetworkingErrorToast = RobloxAppToastsRodux.Thunks.SetNetworkingErrorToast
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagEdpPlayerFeedbackCommentsOnly = SharedFlags2.GetFFlagEdpPlayerFeedbackCommentsOnly
local UserInputService = game:GetService("UserInputService")
local SubmitGamePlayerFeedback = require(PlayerFeedback.Thunks.SubmitGamePlayerFeedback)
require(PlayerFeedback.Types)
local PlayerFeedbackEvents = require(PlayerFeedback.Analytics.Events.PlayerFeedbackEvents)

local AbuseVector = require(parent.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(parent.GenericAbuseReporting.OpenDynamicAbuseReport)

local SharedFlags3 = require(parent.SharedFlags)
local FFlagEnableAbuseReportRevampFlow = SharedFlags3.FFlagEnableAbuseReportRevampFlow
local defineFastFlag = game:DefineFastFlag("EnableAbuseReportRevampFeedback", false)
local SharedFlags4 = require(parent.SharedFlags)
local FFlagAddThumbnailSelectorReport = SharedFlags4.FFlagAddThumbnailSelectorReport
local defineFastFlag2 = game:DefineFastFlag("AddThumbnailReportToPlayerFeedback", false)

local useState = React.useState
local useEffect = React.useEffect

local function CategoryCheckboxes(props)
	local category = props.category
	local selectedCategoryIds = props.selectedCategoryIds
	local onOptionSelected = props.onOptionSelected

	local children = {
		layout = React.createElement("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
		padding = React.createElement("UIPadding", { PaddingLeft = UDim.new(0, -8) })
	}

	local v = React.useCallback(function(p)
		return function(p2)
			local v

			if p2 then
				v = Cryo.List.join(selectedCategoryIds, { p })
			else
				v = Cryo.List.filter(selectedCategoryIds, function(p3): boolean
					return p3 ~= p
				end)
			end

			onOptionSelected(v)
		end
	end, { selectedCategoryIds })

	for i, option in ipairs(category.options) do
		children["Checkbox" .. i] = React.createElement(Checkbox, {
			label = option.label,
			isChecked = Cryo.List.find(selectedCategoryIds, option.id) ~= nil,
			onActivated = v(option.id),
			LayoutOrder = i
		})
	end

	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = props.layoutOrder,
			Size = UDim2.new(1, 0, 0, 0)
		},
		children
	)
end

local function getTextLength(value: string) -- 6 equivalent calls inferred from this helper
	if utf8.len(value) then
		return (utf8.len(utf8.nfcnormalize(value)))
	end

	return (string.len(value))
end

local wrapped = ArgCheck.wrap(t.interface({
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
			options = t.array(t.interface({ id = t.string, label = t.string }))
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

local function GamePlayerFeedbackFormModal(props)
	assert(wrapped(props))

	local v = useStyle()
	local v2 = useDispatch()
	local v3 = useRoactService(RoactNetworking)
	local v4 = useRoactService(AppEventIngestService)
	local tokens = v.Tokens

	local screenSize = useSelector(function(p)
		return p.ScreenSize
	end)

	local v5 = useSelector(function(p)
		local globalGuiInset = p.GlobalGuiInset
		return globalGuiInset and globalGuiInset.bottom or 0
	end)

	local state, setState = useState(false)
	local state2, setState2 = useState(0)
	local v6 = state and -state2 + v5 or 0

	local state3, setState3 = useState(0)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v7 = screenSize.Y - state2 - 48 - 48 - 48 - (state and 0 or 48)

	local playerFeedbackMetadata = props.playerFeedbackMetadata
	local categoryType = playerFeedbackMetadata.categoryType
	local category = playerFeedbackMetadata.category
	local metadata = playerFeedbackMetadata.metadata
	local comment = playerFeedbackMetadata.comment
	local rootPlaceId = playerFeedbackMetadata.rootPlaceId

	local state4, setState4 = useState("")
	local state5, setState5 = useState(GetFFlagEdpPlayerFeedbackCommentsOnly() and { "Other" } or {})
	local v8 = playerFeedbackMetadata.canSubmitComment and #state5 > 0
	local state6, setState6 = useState(nil)

	local v9 = useLocalization({
		commentTooLongMessage = {
			"PlayerFeedbacks.VoteForm.Message.MaxLengthCharacters",
			count = comment.maximum_length
		},
		commentTooShortMessage = {
			"PlayerFeedbacks.VoteForm.Message.MinLengthCharacters",
			count = comment.minimum_length
		},
		abuseReportPromptText = "PlayerFeedbacks.VoteForm.Message.ReportAbuseInsteadLong",
		reportFlowPageTitle = "PlayerFeedbacks.VoteForm.Message.Action.Report"
	})
	local v10

	if #state5 > 0 then
		v10 = state6 == nil
	else
		v10 = false
	end

	if GetFFlagEdpPlayerFeedbackCommentsOnly() then
		if #state5 > 0 then
			v10 = false

			if getTextLength(state4) > 0 then -- inferred equivalent call
				v10 = state6 == nil
			end
		else
			v10 = false
		end

		local state7, setState7 = useState(false)
		useEffect(function()
			task.defer(function()
				if not state7 and ref2.current then
					setState7(true)
					ref2.current:CaptureFocus()
				end
			end)
		end, { ref2, state7 })
	end

	local v11 = React.useCallback(function()
		v2(props.closeCentralOverlayThunk())
	end, { props.closeCentralOverlayThunk })

	local onCloseClicked = React.useCallback(function()
		PlayerFeedbackEvents.DismissPlayerFeedbackFormModal(v4, rootPlaceId, {
			categoryType = categoryType
		})
		v11()
	end, { v11, categoryType, rootPlaceId, v4 })

	local onOptionSelected = React.useCallback(function(p)
		PlayerFeedbackEvents.TogglePlayerFeedbackFormModalReason(v4, rootPlaceId, {
			categoryType = categoryType
		})

		setState5(p)
	end, {})

	local onActivated = React.useCallback(function()
		PlayerFeedbackEvents.ClickPlayerFeedbackFormModalSubmit(v4, rootPlaceId, {
			categoryType = categoryType
		})

		if #state5 == 0 then
			return
		end

		if GetFFlagEdpPlayerFeedbackCommentsOnly() and getTextLength(state4) == 0 then -- inferred equivalent call
			PlayerFeedbackEvents.SubmitPlayerFeedbackFailCommentValidation(v4, rootPlaceId, {
				categoryType = categoryType,
				value = "CommentTooShort"
			})

			setState6(v9.commentTooShortMessage)
			return
		end

		if getTextLength(state4) > 0 and getTextLength(state4) < comment.minimum_length then -- inferred equivalent call
			PlayerFeedbackEvents.SubmitPlayerFeedbackFailCommentValidation(v4, rootPlaceId, {
				categoryType = categoryType,
				value = "CommentTooShort"
			})

			setState6(v9.commentTooShortMessage)
			return
		end

		local textLength = getTextLength(state4) -- inferred equivalent call

		if comment.maximum_length < textLength then
			PlayerFeedbackEvents.SubmitPlayerFeedbackFailCommentValidation(v4, rootPlaceId, {
				categoryType = categoryType,
				value = "CommentTooLong"
			})

			setState6(v9.commentTooLongMessage)
		else
			v2(SubmitGamePlayerFeedback.Post(v3, rootPlaceId, categoryType, state5, state4)):andThen(function(_)
				v2(SetCurrentToastMessage({
					toastMessage = "PlayerFeedbacks.VoteForm.Message.SubmitSuccess"
				}))

				if props.onSubmitted then
					props.onSubmitted()
				end

				v11()
			end, function(p)
				v2(SetNetworkingErrorToast(p))
			end)
		end
	end, {
		v3,
		v4,
		comment.maximum_length,
		comment.minimum_length,
		v9.commentTooShortMessage,
		v9.commentTooLongMessage,
		rootPlaceId,
		categoryType,
		state5,
		state4,
		props.onSubmitted,
		v11
	})

	useEffect(function()
		PlayerFeedbackEvents.PlayerFeedbackFormModalMounted(v4, rootPlaceId, {
			categoryType = categoryType
		})
	end, { v4, rootPlaceId, categoryType })

	local v12 = React.useCallback(function()
		PlayerFeedbackEvents.FocusPlayerFeedbackFormModalComment(v4, rootPlaceId, {
			categoryType = categoryType
		})
	end, { v4, rootPlaceId, categoryType })

	local v13 = React.useCallback(function()
		PlayerFeedbackEvents.ClickPlayerFeedbackFormAbuseReportPrompt(v4, rootPlaceId, {
			categoryType = categoryType
		})

		v2(OpenDynamicAbuseReport({
			abuseVector = AbuseVector.Place,
			targetId = rootPlaceId,
			custom = FFlagAddThumbnailSelectorReport and defineFastFlag2 and {
				universeId = props.universeId
			} or nil,
			onClose = function()
				v2(CloseCentralOverlay())
			end
		}))
	end, { v4, rootPlaceId, categoryType, rootPlaceId })

	local v14 = React.useCallback(function()
		PlayerFeedbackEvents.ClickPlayerFeedbackFormAbuseReportPrompt(v4, rootPlaceId, {
			categoryType = categoryType
		})

		local v14 = {
			name = AppPage.GenericWebPage,
			detail = urlBuilder.game.report({ placeId = rootPlaceId }),
			extraProps = { title = v9.reportFlowPageTitle }
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v14))
		else
			v2(NavigateDown(v14))
		end

		v11()
	end, { v4, rootPlaceId, categoryType, v11 })
	local v15 = React.useCallback(function()
		PlayerFeedbackEvents.ClickPlayerFeedbackFormModalDisclaimer(v4, rootPlaceId, {
			categoryType = categoryType
		})

		local v15 = {
			name = AppPage.GenericWebPage,
			detail = urlBuilder.static.about.terms()
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v15))
		else
			v2(NavigateDown(v15))
		end

		v11()
	end, { v4, rootPlaceId, categoryType, v11 })

	local v16 = React.useCallback(function(p)
		local text = p.Text
		setState4(text)
		local textLength = getTextLength(text) -- inferred equivalent call
		local v16

		if textLength == 0 then
			v16 = true
		elseif comment.minimum_length <= textLength then
			v16 = textLength <= comment.maximum_length
		else
			v16 = false
		end

		if state6 and v16 then
			setState6(nil)
		end
	end, { state6, comment.minimum_length, comment.maximum_length })

	useEffect(function()
		if not ref or not ref.current or state2 == 0 then
			return
		end

		ref.current.CanvasPosition = Vector2.new(0, ref.current.AbsoluteCanvasSize.Y)
	end, { ref, state2 })

	useEffect(function()
		local onScreenKeyboardVisibleChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function()
			setState(UserInputService.OnScreenKeyboardVisible)
			setState2(UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0)
		end)

		return function()
			if onScreenKeyboardVisibleChangedConnection then
				onScreenKeyboardVisibleChangedConnection:Disconnect()
			end

			onScreenKeyboardVisibleChangedConnection = nil
		end
	end, {})

	local createElement = React.createElement
	local v17 = {
		title = metadata.form_title_label,
		screenSize = screenSize,
		onCloseClicked = onCloseClicked,
		position = state and UDim2.new(0.5, 0, 1, v6) or nil,
		anchorPoint = state and Vector2.new(0.5, 1) or nil,
		marginSize = 0
	}

	local createElement2 = React.createElement
	local v18 = {
		size = UDim2.new(1, 0, 0, (math.min(state3 + 25, v7))),
		useAutomaticCanvasSize = true,
		canvasSizeY = UDim.new(),
		elasticBehavior = Enum.ElasticBehavior.Never,
		scrollingFrameRef = ref,
		ref = ref
	}

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 16),
			[React.Change.AbsoluteContentSize] = function(p)
				setState3(p.AbsoluteContentSize.Y)
			end
		}),
		ContentPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 24),
			PaddingLeft = UDim.new(0, 24),
			PaddingRight = UDim.new(0, 24)
		}),
		CheckboxesLabel = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = category.label,
			TextSize = v.Font.BaseSize,
			TextColor3 = tokens.Color.Content.Emphasis.Color3,
			TextTransparency = tokens.Color.Content.Emphasis.Transparency,
			FontFace = normalizeFontFace(tokens.Typography.TitleLarge.Font),
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = 0
		}),
		CategoryCheckboxes = 0,
		CommmentLabel = 0,
		Commment = 0,
		HelperText = 0,
		Buttons = 0,
		DisclaimerText = 0,
		AbuseReportPromptText = 0
	}
	local categoryCheckboxes

	if not GetFFlagEdpPlayerFeedbackCommentsOnly() then
		categoryCheckboxes = React.createElement(CategoryCheckboxes, {
			category = category,
			selectedCategoryIds = state5,
			onOptionSelected = onOptionSelected,
			layoutOrder = 1
		})
	end

	children.CategoryCheckboxes = categoryCheckboxes
	local commmentLabel

	if not GetFFlagEdpPlayerFeedbackCommentsOnly() then
		commmentLabel = v8 and React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = comment.label,
			TextSize = v.Font.BaseSize,
			TextColor3 = tokens.Color.Content.Emphasis.Color3,
			TextTransparency = tokens.Color.Content.Emphasis.Transparency,
			FontFace = normalizeFontFace(tokens.Typography.TitleLarge.Font),
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = 2
		})
	end

	children.CommmentLabel = commmentLabel
	local commment

	if v8 then
		commment = React.createElement("Frame", {
			BorderSizePixel = 1,
			BackgroundColor3 = tokens.Color.Surface.Surface_200.Color3,
			BackgroundTransparency = tokens.Color.Surface.Surface_200.Transparency,
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, tokens.Radius.Small)
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 8),
				PaddingBottom = UDim.new(0, 8),
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8)
			}),
			TextBox = React.createElement("TextBox", {
				Text = state4,
				PlaceholderText = comment.placeholder_text,
				PlaceholderColor3 = v.Theme.TextMuted.Color,
				Size = UDim2.new(1, 0, 0, 100),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				ClearTextOnFocus = false,
				MultiLine = true,
				TextWrapped = true,
				ClipsDescendants = true,
				OverlayNativeInput = true,
				TextColor3 = tokens.Color.Content.Emphasis.Color3,
				TextTransparency = tokens.Color.Content.Emphasis.Transparency,
				BackgroundColor3 = tokens.Color.Surface.Surface_200.Color3,
				BackgroundTransparency = tokens.Color.Surface.Surface_200.Transparency,
				FontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font),
				TextSize = tokens.Typography.BodyLarge.FontSize,
				AutomaticSize = Enum.AutomaticSize.Y,
				BorderSizePixel = 0,
				ref = ref2,
				[React.Change.Text] = v16,
				[React.Event.Focused] = v12
			})
		})
	else
		commment = v8
	end

	children.Commment = commment
	local helperText

	if v8 and state6 ~= nil then
		helperText = React.createElement("TextLabel", {
			Text = state6,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			BackgroundTransparency = 1,
			TextColor3 = v.Theme.Alert.Color,
			FontFace = normalizeFontFace(tokens.Typography.CaptionSmall.Font),
			TextSize = tokens.Typography.CaptionLarge.FontSize,
			LineHeight = tokens.Typography.CaptionSmall.LineHeight,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 4
		})
	end

	children.HelperText = helperText

	children.Buttons = React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 5,
			Size = UDim2.new(1, 0, 0, 0)
		},
		{
			ButtonStack = React.createElement(ButtonStack, {
				buttons = {
					{
						buttonType = ButtonType.PrimaryContextual,
						props = {
							onActivated = onActivated,
							isDisabled = v10 == false,
							text = metadata.submit_button_label
						}
					}
				}
			})
		}
	)

	children.DisclaimerText = React.createElement("TextButton", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		FontFace = normalizeFontFace(tokens.Typography.CaptionLarge.Font),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		Text = metadata.disclaimer_label,
		[React.Event.Activated] = v15,
		RichText = true,
		TextSize = tokens.Typography.CaptionLarge.FontSize,
		TextColor3 = v.Theme.TextMuted.Color,
		TextTransparency = v.Theme.TextMuted.Transparency,
		LineHeight = tokens.LineHeight.LineHeight_140,
		LayoutOrder = 6
	})
	local abuseReportPromptText

	if categoryType == "Downvote" then
		local createElement3 = React.createElement
		local v19 = {}
		v19.BackgroundTransparency = 1
		v19.AutomaticSize = Enum.AutomaticSize.XY
		v19.TextXAlignment = Enum.TextXAlignment.Left
		v19.TextWrapped = true
		v19.Text = v9.abuseReportPromptText
		local activated = React.Event.Activated

		if FFlagEnableAbuseReportRevampFlow then
			if not defineFastFlag then
				v13 = v14
			end
		else
			v13 = v14
		end

		v19[activated] = v13

		v19.RichText = true
		v19.TextSize = tokens.Typography.CaptionLarge.FontSize
		v19.TextColor3 = v.Theme.TextMuted.Color
		v19.TextTransparency = v.Theme.TextMuted.Transparency
		v19.FontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font)
		v19.LineHeight = tokens.LineHeight.LineHeight_140
		v19.LayoutOrder = 7
		abuseReportPromptText = createElement3("TextButton", v19)
	else
		abuseReportPromptText = false
	end

	children.AbuseReportPromptText = abuseReportPromptText
	return createElement(PartialPageModal, v17, {
		Content = createElement2(VerticalScrollView, v18, children)
	})
end

return GamePlayerFeedbackFormModal
