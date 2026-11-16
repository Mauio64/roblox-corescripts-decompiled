local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/Foundation")
local checkbox = Foundation.Checkbox
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local useStyle = UIBlox.Core.Style.useStyle
local buttonType = UIBlox.App.Button.Enum.ButtonType
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local verticalScrollView = UIBlox.App.Container.VerticalScrollView

local buttonStack = UIBlox.App.Button.ButtonStack
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/Cryo")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/PlayerFeedback/ArgCheck")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/t")
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/CentralOverlay").Thunks.CloseCentralOverlay
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/Localization").Hooks.useLocalization
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/RobloxAppHooks").useRoactService
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/RoactServiceTags")
local appEventIngestService = RoactServiceTags.AppEventIngestService
local roactNetworking = RoactServiceTags.RoactNetworking
local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Index/PlayerFeedback/ToastRodux")
local setNetworkingErrorToast = require("@game/CorePackages/Workspace/Packages/_Index/PlayerFeedback/RobloxAppToastsRodux").Thunks.SetNetworkingErrorToast
local setCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/SharedFlags").FFlagSignalsNavP3Dispatch
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/RobloxAppNavigation").NavigationCommands else nil

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/RobloxAppEnums").AppPage
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/UrlBuilder").UrlBuilder
local getFFlagEdpPlayerFeedbackCommentsOnly = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/SharedFlags").GetFFlagEdpPlayerFeedbackCommentsOnly
local UserInputService = game:GetService("UserInputService")
local SubmitGamePlayerFeedback = require("@game/CorePackages/Workspace/Packages/_Index/PlayerFeedback/PlayerFeedback/Thunks/SubmitGamePlayerFeedback")
require("@game/CorePackages/Workspace/Packages/_Index/PlayerFeedback/PlayerFeedback/Types")
local PlayerFeedbackEvents = require("@game/CorePackages/Workspace/Packages/_Index/PlayerFeedback/PlayerFeedback/Analytics/Events/PlayerFeedbackEvents")

local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Index/PlayerFeedback/GenericAbuseReporting/AbuseVector")
local OpenDynamicAbuseReport = require("@game/CorePackages/Workspace/Packages/_Index/PlayerFeedback/GenericAbuseReporting/OpenDynamicAbuseReport")

local fFlagEnableAbuseReportRevampFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/SharedFlags").FFlagEnableAbuseReportRevampFlow
local defineFastFlag = game:DefineFastFlag("EnableAbuseReportRevampFeedback", false)
local fFlagAddThumbnailSelectorReport = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/SharedFlags").FFlagAddThumbnailSelectorReport
local defineFastFlag2 = game:DefineFastFlag("AddThumbnailReportToPlayerFeedback", false)

local useState = React.useState
local useEffect = React.useEffect

local function CategoryCheckboxes(props)
	local category = props.category
	local selectedCategoryIds = props.selectedCategoryIds
	local onOptionSelected = props.onOptionSelected

	local children = {
		layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		padding = React.createElement("UIPadding", { PaddingLeft = UDim.new(0, -8) })
	}

	local v5 = React.useCallback(function(p2)
		return function(p3)
			local v6

			if p3 then
				v6 = Cryo.List.join(selectedCategoryIds, { p2 })
			else
				v6 = Cryo.List.filter(selectedCategoryIds, function(p4): boolean
					return p4 ~= p2
				end)
			end

			onOptionSelected(v6)
		end
	end, { selectedCategoryIds })

	for i, option in ipairs(category.options) do
		children["Checkbox" .. i] = React.createElement(checkbox, {
			label = option.label,
			isChecked = Cryo.List.find(selectedCategoryIds, option.id) ~= nil,
			onActivated = v5(option.id),
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

local function getTextLength(value)
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

local function GamePlayerFeedbackFormModal(props)
	assert(wrapped(props))

	local v5 = useStyle()
	local v6 = useDispatch()
	local v7 = useRoactService(roactNetworking)
	local v8 = useRoactService(appEventIngestService)
	local tokens = v5.Tokens

	local v9 = useSelector(function(p2)
		return p2.ScreenSize
	end)

	local v10 = useSelector(function(p2)
		local globalGuiInset = p2.GlobalGuiInset
		return globalGuiInset and globalGuiInset.bottom or 0
	end)

	local state, setState = useState(false)
	local state2, setState2 = useState(0)
	local v11 = state and -state2 + v10 or 0

	local state3, setState3 = useState(0)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v12 = v9.Y - state2 - 48 - 48 - 48 - (state and 0 or 48)

	local playerFeedbackMetadata = props.playerFeedbackMetadata
	local categoryType = playerFeedbackMetadata.categoryType
	local category = playerFeedbackMetadata.category
	local metadata = playerFeedbackMetadata.metadata
	local comment = playerFeedbackMetadata.comment
	local rootPlaceId = playerFeedbackMetadata.rootPlaceId

	local state4, setState4 = useState("")
	local state5, setState5 = useState(getFFlagEdpPlayerFeedbackCommentsOnly() and { "Other" } or {})
	local v14 = playerFeedbackMetadata.canSubmitComment and #state5 > 0
	local state6, setState6 = useState(nil)

	local v15 = useLocalization({
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

	local v16 = #state5 > 0 and state6 == nil

	if getFFlagEdpPlayerFeedbackCommentsOnly() then
		if #state5 > 0 then
			v16 = false
			local v17 = if utf8.len(state4) then utf8.len(utf8.nfcnormalize(state4)) else string.len(state4)

			if v17 > 0 then
				v16 = state6 == nil
			end
		else
			v16 = false
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

	local v17 = React.useCallback(function()
		v6(props.closeCentralOverlayThunk())
	end, { props.closeCentralOverlayThunk })

	local v18 = React.useCallback(function()
		PlayerFeedbackEvents.DismissPlayerFeedbackFormModal(v8, rootPlaceId, {
			categoryType = categoryType
		})
		v17()
	end, { v17, categoryType, rootPlaceId, v8 })

	local v19 = React.useCallback(function(p2)
		PlayerFeedbackEvents.TogglePlayerFeedbackFormModalReason(v8, rootPlaceId, {
			categoryType = categoryType
		})

		setState5(p2)
	end, {})

	local v20 = React.useCallback(function()
		PlayerFeedbackEvents.ClickPlayerFeedbackFormModalSubmit(v8, rootPlaceId, {
			categoryType = categoryType
		})

		if #state5 == 0 then
			return
		end

		if getFFlagEdpPlayerFeedbackCommentsOnly() then
			local v21 = state4
			local v22 = if utf8.len(v21) then utf8.len(utf8.nfcnormalize(v21)) else string.len(v21)

			if v22 == 0 then
				PlayerFeedbackEvents.SubmitPlayerFeedbackFailCommentValidation(v8, rootPlaceId, {
					categoryType = categoryType,
					value = "CommentTooShort"
				})

				setState6(v15.commentTooShortMessage)
				return
			end
		end

		local v21 = state4
		local v22 = if utf8.len(v21) then utf8.len(utf8.nfcnormalize(v21)) else string.len(v21)

		if v22 > 0 then
			local v23 = state4
			local v24 = if utf8.len(v23) then utf8.len(utf8.nfcnormalize(v23)) else string.len(v23)

			if v24 < comment.minimum_length then
				PlayerFeedbackEvents.SubmitPlayerFeedbackFailCommentValidation(v8, rootPlaceId, {
					categoryType = categoryType,
					value = "CommentTooShort"
				})

				setState6(v15.commentTooShortMessage)
				return
			end
		end

		local v23 = state4
		local v24 = if utf8.len(v23) then utf8.len(utf8.nfcnormalize(v23)) else string.len(v23)

		if comment.maximum_length < v24 then
			PlayerFeedbackEvents.SubmitPlayerFeedbackFailCommentValidation(v8, rootPlaceId, {
				categoryType = categoryType,
				value = "CommentTooLong"
			})

			setState6(v15.commentTooLongMessage)
		else
			v6(SubmitGamePlayerFeedback.Post(v7, rootPlaceId, categoryType, state5, state4)):andThen(function(p2)
				v6(setCurrentToastMessage({
					toastMessage = "PlayerFeedbacks.VoteForm.Message.SubmitSuccess"
				}))

				if props.onSubmitted then
					props.onSubmitted()
				end

				v17()
			end, function(p2)
				v6(setNetworkingErrorToast(p2))
			end)
		end
	end, {
		v7,
		v8,
		comment.maximum_length,
		comment.minimum_length,
		v15.commentTooShortMessage,
		v15.commentTooLongMessage,
		rootPlaceId,
		categoryType,
		state5,
		state4,
		props.onSubmitted,
		v17
	})

	useEffect(function()
		PlayerFeedbackEvents.PlayerFeedbackFormModalMounted(v8, rootPlaceId, {
			categoryType = categoryType
		})
	end, { v8, rootPlaceId, categoryType })

	local v21 = React.useCallback(function()
		PlayerFeedbackEvents.FocusPlayerFeedbackFormModalComment(v8, rootPlaceId, {
			categoryType = categoryType
		})
	end, { v8, rootPlaceId, categoryType })

	local v22 = React.useCallback(function()
		PlayerFeedbackEvents.ClickPlayerFeedbackFormAbuseReportPrompt(v8, rootPlaceId, {
			categoryType = categoryType
		})

		v6(OpenDynamicAbuseReport({
			abuseVector = AbuseVector.Place,
			targetId = rootPlaceId,
			custom = fFlagAddThumbnailSelectorReport and defineFastFlag2 and {
				universeId = props.universeId
			} or nil,
			onClose = function()
				v6(closeCentralOverlay())
			end
		}))
	end, { v8, rootPlaceId, categoryType, rootPlaceId })

	local v23 = React.useCallback(function()
		PlayerFeedbackEvents.ClickPlayerFeedbackFormAbuseReportPrompt(v8, rootPlaceId, {
			categoryType = categoryType
		})

		local v24 = {
			name = appPage.GenericWebPage,
			detail = urlBuilder.game.report({ placeId = rootPlaceId }),
			extraProps = { title = v15.reportFlowPageTitle }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v24))
		else
			v6(navigateDown(v24))
		end

		v17()
	end, { v8, rootPlaceId, categoryType, v17 })
	local v24 = React.useCallback(function()
		PlayerFeedbackEvents.ClickPlayerFeedbackFormModalDisclaimer(v8, rootPlaceId, {
			categoryType = categoryType
		})

		local v25 = {
			name = appPage.GenericWebPage,
			detail = urlBuilder.static.about.terms()
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v25))
		else
			v6(navigateDown(v25))
		end

		v17()
	end, { v8, rootPlaceId, categoryType, v17 })

	local v25 = React.useCallback(function(p2)
		local text = p2.Text
		setState4(text)
		local v26 = if utf8.len(text) then utf8.len(utf8.nfcnormalize(text)) else string.len(text)

		local v27 = v26 == 0 or comment.minimum_length <= v26 and v26 <= comment.maximum_length

		if state6 and v27 then
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
	local v27 = {
		title = metadata.form_title_label,
		screenSize = v9,
		onCloseClicked = v18,
		position = state and UDim2.new(0.5, 0, 1, v11) or nil,
		anchorPoint = state and Vector2.new(0.5, 1) or nil,
		marginSize = 0
	}

	local createElement2 = React.createElement
	local v30 = {
		size = UDim2.new(1, 0, 0, (math.min(state3 + 25, v12))),
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
			[React.Change.AbsoluteContentSize] = function(p2)
				setState3(p2.AbsoluteContentSize.Y)
			end
		}),
		ContentPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 24),
			PaddingLeft = UDim.new(0, 24),
			PaddingRight = UDim.new(0, 24)
		}),
		CheckboxesLabel = 0,
		CategoryCheckboxes = 0,
		CommmentLabel = 0,
		Commment = 0,
		HelperText = 0,
		Buttons = 0,
		DisclaimerText = 0,
		AbuseReportPromptText = 0
	}

	local createElement4 = React.createElement
	local v33 = {
		BackgroundTransparency = 1,
		Text = category.label,
		TextSize = v5.Font.BaseSize,
		TextColor3 = tokens.Color.Content.Emphasis.Color3,
		TextTransparency = tokens.Color.Content.Emphasis.Transparency,
		Font = 0,
		FontFace = 0,
		TextXAlignment = 0,
		AutomaticSize = 0,
		TextWrapped = true,
		Size = 0,
		LayoutOrder = 0
	}
	local v34 = if not foundationFontFaceMigration then tokens.Typography.TitleLarge.Font else nil
	v33.Font = v34

	local v35 = if foundationFontFaceMigration then normalizeFontFace(tokens.Typography.TitleLarge.Font) else nil
	v33.FontFace = v35

	v33.TextXAlignment = Enum.TextXAlignment.Left
	v33.AutomaticSize = Enum.AutomaticSize.Y

	v33.Size = UDim2.new(1, 0, 0, 0)
	children.CheckboxesLabel = createElement4("TextLabel", v33)

	local v36 = if not getFFlagEdpPlayerFeedbackCommentsOnly() then React.createElement(CategoryCheckboxes, {
		category = category,
		selectedCategoryIds = state5,
		onOptionSelected = v19,
		layoutOrder = 1
	}) else nil
	children.CategoryCheckboxes = v36
	local v37

	if not getFFlagEdpPlayerFeedbackCommentsOnly() then
		if v14 then
			local createElement5 = React.createElement
			local v39 = {
				BackgroundTransparency = 1,
				Text = comment.label,
				TextSize = v5.Font.BaseSize,
				TextColor3 = tokens.Color.Content.Emphasis.Color3,
				TextTransparency = tokens.Color.Content.Emphasis.Transparency,
				Font = 0,
				FontFace = 0,
				TextXAlignment = 0,
				AutomaticSize = 0,
				TextWrapped = true,
				Size = 0,
				LayoutOrder = 2
			}
			local v40 = if not foundationFontFaceMigration then tokens.Typography.TitleLarge.Font else nil
			v39.Font = v40

			local v41 = if foundationFontFaceMigration then normalizeFontFace(tokens.Typography.TitleLarge.Font) else nil
			v39.FontFace = v41

			v39.TextXAlignment = Enum.TextXAlignment.Left
			v39.AutomaticSize = Enum.AutomaticSize.Y

			v39.Size = UDim2.new(1, 0, 0, 0)
			v37 = createElement5("TextLabel", v39)
		else
			v37 = v14
		end
	end

	children.CommmentLabel = v37
	local v38

	if v14 then
		local createElement5 = React.createElement
		local v40 = {
			BorderSizePixel = 1,
			BackgroundColor3 = tokens.Color.Surface.Surface_200.Color3,
			BackgroundTransparency = tokens.Color.Surface.Surface_200.Transparency,
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 0)
		}
		local v41 = {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, tokens.Radius.Small)
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 8),
				PaddingBottom = UDim.new(0, 8),
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8)
			}),
			TextBox = 0
		}

		local createElement6 = React.createElement
		local v43 = {}
		v43.Text = state4
		v43.PlaceholderText = comment.placeholder_text
		v43.PlaceholderColor3 = v5.Theme.TextMuted.Color
		v43.Size = UDim2.new(1, 0, 0, 100)
		v43.TextXAlignment = Enum.TextXAlignment.Left
		v43.TextYAlignment = Enum.TextYAlignment.Top
		v43.ClearTextOnFocus = false
		v43.MultiLine = true
		v43.TextWrapped = true
		v43.ClipsDescendants = true
		v43.OverlayNativeInput = true
		v43.TextColor3 = tokens.Color.Content.Emphasis.Color3
		v43.TextTransparency = tokens.Color.Content.Emphasis.Transparency
		v43.BackgroundColor3 = tokens.Color.Surface.Surface_200.Color3
		v43.BackgroundTransparency = tokens.Color.Surface.Surface_200.Transparency
		local v44 = if not foundationFontFaceMigration then tokens.Typography.BodyLarge.Font else nil
		v43.Font = v44

		local v45 = if foundationFontFaceMigration then normalizeFontFace(tokens.Typography.BodyLarge.Font) else nil
		v43.FontFace = v45

		v43.TextSize = tokens.Typography.BodyLarge.FontSize
		v43.AutomaticSize = Enum.AutomaticSize.Y
		v43.BorderSizePixel = 0
		v43.ref = ref2
		v43[React.Change.Text] = v25
		v43[React.Event.Focused] = v21
		v41.TextBox = createElement6("TextBox", v43)
		v38 = createElement5("Frame", v40, v41)
	else
		v38 = v14
	end

	children.Commment = v38
	local v39

	if v14 and state6 ~= nil then
		local createElement5 = React.createElement
		local v41 = {
			Text = state6,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			BackgroundTransparency = 1,
			TextColor3 = v5.Theme.Alert.Color,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			LineHeight = 0,
			Size = 0,
			AutomaticSize = 0,
			LayoutOrder = 4
		}
		local v42 = if not foundationFontFaceMigration then tokens.Typography.CaptionSmall.Font else nil
		v41.Font = v42

		local v43 = if foundationFontFaceMigration then normalizeFontFace(tokens.Typography.CaptionSmall.Font) else nil
		v41.FontFace = v43

		v41.TextSize = tokens.Typography.CaptionLarge.FontSize
		v41.LineHeight = tokens.Typography.CaptionSmall.LineHeight
		v41.Size = UDim2.new(1, 0, 0, 0)
		v41.AutomaticSize = Enum.AutomaticSize.Y
		v39 = createElement5("TextLabel", v41)
	end

	children.HelperText = v39

	children.Buttons = React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 5,
			Size = UDim2.new(1, 0, 0, 0)
		},
		{
			ButtonStack = React.createElement(buttonStack, {
				buttons = {
					{
						buttonType = buttonType.PrimaryContextual,
						props = {
							onActivated = v20,
							isDisabled = v16 == false,
							text = metadata.submit_button_label
						}
					}
				}
			})
		}
	)

	local createElement5 = React.createElement
	local v41 = {}
	v41.BackgroundTransparency = 1
	v41.AutomaticSize = Enum.AutomaticSize.Y
	v41.Size = UDim2.new(1, 0, 0, 0)
	local v42 = if not foundationFontFaceMigration then v5.Font.CaptionHeader.Font else nil
	v41.Font = v42

	local v43 = if foundationFontFaceMigration then normalizeFontFace(tokens.Typography.CaptionLarge.Font) else nil
	v41.FontFace = v43

	v41.TextXAlignment = Enum.TextXAlignment.Left
	v41.TextWrapped = true
	v41.Text = metadata.disclaimer_label
	v41[React.Event.Activated] = v24
	v41.RichText = true
	v41.TextSize = tokens.Typography.CaptionLarge.FontSize
	v41.TextColor3 = v5.Theme.TextMuted.Color
	v41.TextTransparency = v5.Theme.TextMuted.Transparency
	v41.LineHeight = tokens.LineHeight.LineHeight_140
	v41.LayoutOrder = 6
	children.DisclaimerText = createElement5("TextButton", v41)
	local v44

	if categoryType == "Downvote" then
		local createElement6 = React.createElement
		local v46 = {}
		v46.BackgroundTransparency = 1
		v46.AutomaticSize = Enum.AutomaticSize.XY
		v46.TextXAlignment = Enum.TextXAlignment.Left
		v46.TextWrapped = true
		v46.Text = v15.abuseReportPromptText
		local activated = React.Event.Activated

		if fFlagEnableAbuseReportRevampFlow then
			if not defineFastFlag then
				v22 = v23
			end
		else
			v22 = v23
		end

		v46[activated] = v22

		v46.RichText = true
		v46.TextSize = tokens.Typography.CaptionLarge.FontSize
		v46.TextColor3 = v5.Theme.TextMuted.Color
		v46.TextTransparency = v5.Theme.TextMuted.Transparency
		local v47 = if not foundationFontFaceMigration then tokens.Typography.BodyLarge.Font else nil
		v46.Font = v47

		local v48 = if foundationFontFaceMigration then normalizeFontFace(tokens.Typography.BodyLarge.Font) else nil
		v46.FontFace = v48

		v46.LineHeight = tokens.LineHeight.LineHeight_140
		v46.LayoutOrder = 7
		v44 = createElement6("TextButton", v46)
	else
		v44 = false
	end

	children.AbuseReportPromptText = v44
	return createElement(partialPageModal, v27, {
		Content = createElement2(verticalScrollView, v30, children)
	})
end

return GamePlayerFeedbackFormModal
