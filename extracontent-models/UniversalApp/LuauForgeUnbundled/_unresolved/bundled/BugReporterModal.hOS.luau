local module = require("@luauforge/bundled/hOo")
require("@luauforge/bundled/hOy")
local module2 = require("@luauforge/bundled/hOT")
local module3 = require("@luauforge/bundled/hOU")
local normalizeFontFace = module3.Utility.normalizeFontFace
local foundationFontFaceMigration = module3.Utility.Flags.FoundationFontFaceMigration
require("@luauforge/bundled/hOz")
local buttonType = module2.App.Button.Enum.ButtonType
local partialPageModal = module2.App.Dialog.Modal.PartialPageModal
local verticalScrollView = module2.App.Container.VerticalScrollView
require("@luauforge/bundled/hOD")

local function BugReporterModal(props)
	local localizedStrings = props.localizedStrings
	local localizedDeviceSummary = props.localizedDeviceSummary
	local screenSize = props.screenSize
	local bottomInset = props.bottomInset
	local designTokens = props.designTokens
	local v5 = {
		modalTitleHeight = designTokens.Size.Size_1200,
		modalPadding = designTokens.Size.Size_1200,
		modalButtonHeight = designTokens.Size.Size_900,
		contentPadding = designTokens.Size.Size_600,
		labelPadding = designTokens.Size.Size_300,
		screenShotHeight = designTokens.Size.Size_2200
	}

	local screenshotContentId = props.screenshotContentId
	local scrollContentHeight = props.scrollContentHeight
	local onListLayoutSizeChange = props.onListLayoutSizeChange
	local commentText = props.commentText
	local commentErrorMessage = props.commentErrorMessage
	local onCommentTextChange = props.onCommentTextChange
	local canSubmit = props.canSubmit
	local onSubmit = props.onSubmit
	local onClose = props.onClose
	local y = props.onScreenKeyboardSize.Y
	local v6 = y > 0
	local v7 = -y + bottomInset
	local v8 = v6 and 0 or v5.modalPadding
	local v9 = screenSize.Y - y - v5.modalTitleHeight - v5.modalPadding * 2 - v5.modalButtonHeight - v8

	local v10 = v5.screenShotHeight + v5.contentPadding * 2 + v5.labelPadding

	local ref = module.useRef(nil)
	module.useEffect(function()
		local current = ref.current

		if current and v6 then
			current.CanvasPosition = Vector2.new(0, v10)
		end
	end, { v6, v10 })

	module.useEffect(function()
		props.onLoad()
	end, {})

	local createElement = module.createElement
	local v12 = {
		title = localizedStrings.title,
		screenSize = screenSize,
		buttonStackProps = {
			buttons = {
				{
					buttonType = buttonType.PrimaryContextual,
					props = {
						onActivated = onSubmit,
						isDisabled = canSubmit == false,
						text = localizedStrings.submit
					}
				}
			}
		},
		onCloseClicked = onClose,
		position = v6 and UDim2.new(0.5, 0, 1, v7) or nil,
		anchorPoint = v6 and Vector2.new(0.5, 1) or nil,
		marginSize = 0
	}

	local v13 = { Content = 0 }
	local createElement2 = module.createElement
	local v15 = {
		size = UDim2.new(1, 0, 0, (math.min(scrollContentHeight + 2 * v5.contentPadding, v9))),
		useAutomaticCanvasSize = true,
		canvasSizeY = UDim.new(),
		elasticBehavior = Enum.ElasticBehavior.Never,
		scrollingFrameRef = ref
	}

	local children = {
		UIListLayout = module.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v5.contentPadding),
			[module.Change.AbsoluteContentSize] = onListLayoutSizeChange
		}),
		ContentPadding = module.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v5.contentPadding),
			PaddingBottom = UDim.new(0, v5.contentPadding),
			PaddingLeft = UDim.new(0, v5.contentPadding),
			PaddingRight = UDim.new(0, v5.contentPadding)
		}),
		ScreenshotContainer = 0,
		CommentContainer = 0,
		HelperText = 0,
		DeviceSummary = 0
	}

	local createElement4 = module.createElement
	local v17 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local v18 = {
		UIListLayout = module.createElement("UIListLayout", {
			Padding = UDim.new(0, v5.labelPadding),
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			ItemLineAlignment = Enum.ItemLineAlignment.End
		}),
		Screenshot = module.createElement("ImageLabel", {
			BackgroundTransparency = 0,
			Size = UDim2.new(1, 0, 0, v5.screenShotHeight),
			Image = screenshotContentId,
			ScaleType = Enum.ScaleType.Tile,
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			LayoutOrder = 1
		}, {
			UIAspectRatioConstraint = module.createElement("UIAspectRatioConstraint", {
				AspectRatio = math.max(1, screenSize.X) / math.max(1, screenSize.Y)
			})
		}),
		ScreenshotAnnotation = 0
	}

	local createElement5 = module.createElement
	local v20 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		Font = 0,
		FontFace = 0,
		TextXAlignment = 0,
		Text = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		LineHeight = 0,
		LayoutOrder = 2
	}
	local v21 = if not foundationFontFaceMigration then designTokens.Typography.BodyLarge.Font else nil
	v20.Font = v21

	local v22 = if foundationFontFaceMigration then normalizeFontFace(designTokens.Typography.BodyLarge.Font) else nil
	v20.FontFace = v22

	v20.TextXAlignment = Enum.TextXAlignment.Left
	v20.Text = localizedStrings.screenshotAnnotation
	v20.TextSize = designTokens.Typography.BodyLarge.FontSize
	v20.TextColor3 = designTokens.Color.Content.Default.Color3
	v20.TextTransparency = designTokens.Color.Content.Default.Transparency
	v20.LineHeight = designTokens.LineHeight.LineHeight_120
	v18.ScreenshotAnnotation = createElement5("TextLabel", v20)
	children.ScreenshotContainer = createElement4("Frame", v17, v18)

	local createElement6 = module.createElement
	local v24 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local children2 = {
		UIListLayout = module.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v5.labelPadding)
		}),
		CommmentLabel = 0,
		Commment = 0,
		CharacterCount = 0
	}

	local createElement7 = module.createElement
	local v26 = {
		BackgroundTransparency = 1,
		Text = localizedStrings.commentLabel,
		TextSize = designTokens.Typography.BodyLarge.FontSize,
		TextColor3 = designTokens.Color.Content.Emphasis.Color3,
		TextTransparency = designTokens.Color.Content.Emphasis.Transparency,
		Font = 0,
		FontFace = 0,
		TextXAlignment = 0,
		AutomaticSize = 0,
		TextWrapped = true,
		Size = 0,
		LayoutOrder = 1
	}
	local v27 = if not foundationFontFaceMigration then designTokens.Typography.BodyLarge.Font else nil
	v26.Font = v27

	local v28 = if foundationFontFaceMigration then normalizeFontFace(designTokens.Typography.BodyLarge.Font) else nil
	v26.FontFace = v28

	v26.TextXAlignment = Enum.TextXAlignment.Left
	v26.AutomaticSize = Enum.AutomaticSize.Y

	v26.Size = UDim2.new(1, 0, 0, 0)
	children2.CommmentLabel = createElement7("TextLabel", v26)

	local createElement8 = module.createElement
	local v30 = {
		BorderSizePixel = 1,
		BackgroundColor3 = designTokens.Color.Surface.Surface_200.Color3,
		BackgroundTransparency = designTokens.Color.Surface.Surface_200.Transparency,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local v31 = {
		UICorner = module.createElement("UICorner", {
			CornerRadius = UDim.new(0, designTokens.Radius.Small)
		}),
		UIPadding = module.createElement("UIPadding", {
			PaddingTop = UDim.new(0, designTokens.Size.Size_200),
			PaddingBottom = UDim.new(0, designTokens.Size.Size_200),
			PaddingLeft = UDim.new(0, designTokens.Size.Size_200),
			PaddingRight = UDim.new(0, designTokens.Size.Size_200)
		}),
		TextBox = 0
	}

	local createElement9 = module.createElement
	local onCommentTextChangesByText = {}
	onCommentTextChangesByText.Text = commentText
	onCommentTextChangesByText.PlaceholderText = localizedStrings.commentPlaceholder
	onCommentTextChangesByText.PlaceholderColor3 = designTokens.Color.Content.Default.Color3
	onCommentTextChangesByText.Size = UDim2.new(1, 0, 0, designTokens.Size.Size_2400)
	onCommentTextChangesByText.TextXAlignment = Enum.TextXAlignment.Left
	onCommentTextChangesByText.TextYAlignment = Enum.TextYAlignment.Top
	onCommentTextChangesByText.ClearTextOnFocus = false
	onCommentTextChangesByText.MultiLine = true
	onCommentTextChangesByText.TextWrapped = true
	onCommentTextChangesByText.ClipsDescendants = true
	onCommentTextChangesByText.OverlayNativeInput = true
	onCommentTextChangesByText.TextColor3 = designTokens.Color.Content.Emphasis.Color3
	onCommentTextChangesByText.TextTransparency = designTokens.Color.Content.Emphasis.Transparency
	onCommentTextChangesByText.BackgroundColor3 = designTokens.Color.Surface.Surface_200.Color3
	onCommentTextChangesByText.BackgroundTransparency = designTokens.Color.Surface.Surface_200.Transparency
	local v33 = if not foundationFontFaceMigration then designTokens.Typography.BodyLarge.Font else nil
	onCommentTextChangesByText.Font = v33

	local v34 = if foundationFontFaceMigration then normalizeFontFace(designTokens.Typography.BodyLarge.Font) else nil
	onCommentTextChangesByText.FontFace = v34

	onCommentTextChangesByText.TextSize = designTokens.Typography.BodyLarge.FontSize
	onCommentTextChangesByText.AutomaticSize = Enum.AutomaticSize.Y
	onCommentTextChangesByText.BorderSizePixel = 0
	onCommentTextChangesByText[module.Change.Text] = onCommentTextChange
	v31.TextBox = createElement9("TextBox", onCommentTextChangesByText)
	children2.Commment = createElement8("Frame", v30, v31)

	local createElement10 = module.createElement
	local v36 = {
		BackgroundTransparency = 1,
		Text = localizedStrings.commentCharacterCount,
		TextSize = designTokens.Typography.BodyLarge.FontSize,
		TextColor3 = designTokens.Color.Content.Emphasis.Color3,
		TextTransparency = designTokens.Color.Content.Emphasis.Transparency,
		Font = 0,
		FontFace = 0,
		TextXAlignment = 0,
		AutomaticSize = 0,
		TextWrapped = true,
		Size = 0,
		LayoutOrder = 3
	}
	local v37 = if not foundationFontFaceMigration then designTokens.Typography.BodyLarge.Font else nil
	v36.Font = v37

	local v38 = if foundationFontFaceMigration then normalizeFontFace(designTokens.Typography.BodyLarge.Font) else nil
	v36.FontFace = v38

	v36.TextXAlignment = Enum.TextXAlignment.Left
	v36.AutomaticSize = Enum.AutomaticSize.Y

	v36.Size = UDim2.new(1, 0, 0, 0)
	children2.CharacterCount = createElement10("TextLabel", v36)
	children.CommentContainer = createElement6("Frame", v24, children2)
	local v39

	if commentErrorMessage ~= nil then
		local createElement11 = module.createElement
		local v41 = {
			Text = commentErrorMessage,
			TextTransparency = designTokens.Color.ActionAlert.Foreground.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			BackgroundTransparency = 1,
			TextColor3 = designTokens.Color.ActionAlert.Foreground.Color3,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			LineHeight = 0,
			Size = 0,
			AutomaticSize = 0,
			LayoutOrder = 3
		}
		local v42 = if not foundationFontFaceMigration then designTokens.Typography.CaptionSmall.Font else nil
		v41.Font = v42

		local v43 = if foundationFontFaceMigration then normalizeFontFace(designTokens.Typography.CaptionSmall.Font) else nil
		v41.FontFace = v43

		v41.TextSize = designTokens.Typography.CaptionSmall.FontSize
		v41.LineHeight = designTokens.Typography.CaptionSmall.FontSize
		v41.Size = UDim2.new(1, 0, 0, 0)
		v41.AutomaticSize = Enum.AutomaticSize.Y
		v39 = createElement11("TextLabel", v41)
	end

	children.HelperText = v39

	local createElement11 = module.createElement
	local v41 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		Font = 0,
		FontFace = 0,
		TextXAlignment = 0,
		TextWrapped = true,
		Text = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		LineHeight = 0,
		LayoutOrder = 4
	}
	local v42 = if not foundationFontFaceMigration then designTokens.Typography.BodyLarge.Font else nil
	v41.Font = v42

	local v43 = if foundationFontFaceMigration then normalizeFontFace(designTokens.Typography.BodyLarge.Font) else nil
	v41.FontFace = v43

	v41.TextXAlignment = Enum.TextXAlignment.Left

	v41.Text = localizedDeviceSummary
	v41.TextSize = designTokens.Typography.BodyLarge.FontSize
	v41.TextColor3 = designTokens.Color.Content.Muted.Color3
	v41.TextTransparency = designTokens.Color.Content.Muted.Transparency
	v41.LineHeight = designTokens.LineHeight.LineHeight_120
	children.DeviceSummary = createElement11("TextLabel", v41)
	v13.Content = createElement2(verticalScrollView, v15, children)
	return createElement(partialPageModal, v12, v13)
end

return BugReporterModal
