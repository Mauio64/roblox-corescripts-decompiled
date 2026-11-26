local module = require("@luauforge/bundled/hYV")
require("@luauforge/bundled/hZf")
local module2 = require("@luauforge/bundled/hZA")
local normalizeFontFace = require("@luauforge/bundled/hZB").Utility.normalizeFontFace
require("@luauforge/bundled/hZg")
local buttonType = module2.App.Button.Enum.ButtonType
local partialPageModal = module2.App.Dialog.Modal.PartialPageModal
local verticalScrollView = module2.App.Container.VerticalScrollView
require("@luauforge/bundled/hZk")

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
		ScreenshotContainer = module.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0)
			},
			{
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
				ScreenshotAnnotation = module.createElement("TextLabel", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					FontFace = normalizeFontFace(designTokens.Typography.BodyLarge.Font),
					TextXAlignment = Enum.TextXAlignment.Left,
					Text = localizedStrings.screenshotAnnotation,
					TextSize = designTokens.Typography.BodyLarge.FontSize,
					TextColor3 = designTokens.Color.Content.Default.Color3,
					TextTransparency = designTokens.Color.Content.Default.Transparency,
					LineHeight = designTokens.LineHeight.LineHeight_120,
					LayoutOrder = 2
				})
			}
		),
		CommentContainer = module.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 0)
			},
			{
				UIListLayout = module.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, v5.labelPadding)
				}),
				CommmentLabel = module.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = localizedStrings.commentLabel,
					TextSize = designTokens.Typography.BodyLarge.FontSize,
					TextColor3 = designTokens.Color.Content.Emphasis.Color3,
					TextTransparency = designTokens.Color.Content.Emphasis.Transparency,
					FontFace = normalizeFontFace(designTokens.Typography.BodyLarge.Font),
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextWrapped = true,
					Size = UDim2.new(1, 0, 0, 0),
					LayoutOrder = 1
				}),
				Commment = module.createElement("Frame", {
					BorderSizePixel = 1,
					BackgroundColor3 = designTokens.Color.Surface.Surface_200.Color3,
					BackgroundTransparency = designTokens.Color.Surface.Surface_200.Transparency,
					AutomaticSize = Enum.AutomaticSize.Y,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					UICorner = module.createElement("UICorner", {
						CornerRadius = UDim.new(0, designTokens.Radius.Small)
					}),
					UIPadding = module.createElement("UIPadding", {
						PaddingTop = UDim.new(0, designTokens.Size.Size_200),
						PaddingBottom = UDim.new(0, designTokens.Size.Size_200),
						PaddingLeft = UDim.new(0, designTokens.Size.Size_200),
						PaddingRight = UDim.new(0, designTokens.Size.Size_200)
					}),
					TextBox = module.createElement("TextBox", {
						Text = commentText,
						PlaceholderText = localizedStrings.commentPlaceholder,
						PlaceholderColor3 = designTokens.Color.Content.Default.Color3,
						Size = UDim2.new(1, 0, 0, designTokens.Size.Size_2400),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						ClearTextOnFocus = false,
						MultiLine = true,
						TextWrapped = true,
						ClipsDescendants = true,
						OverlayNativeInput = true,
						TextColor3 = designTokens.Color.Content.Emphasis.Color3,
						TextTransparency = designTokens.Color.Content.Emphasis.Transparency,
						BackgroundColor3 = designTokens.Color.Surface.Surface_200.Color3,
						BackgroundTransparency = designTokens.Color.Surface.Surface_200.Transparency,
						FontFace = normalizeFontFace(designTokens.Typography.BodyLarge.Font),
						TextSize = designTokens.Typography.BodyLarge.FontSize,
						AutomaticSize = Enum.AutomaticSize.Y,
						BorderSizePixel = 0,
						[module.Change.Text] = onCommentTextChange
					})
				}),
				CharacterCount = module.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = localizedStrings.commentCharacterCount,
					TextSize = designTokens.Typography.BodyLarge.FontSize,
					TextColor3 = designTokens.Color.Content.Emphasis.Color3,
					TextTransparency = designTokens.Color.Content.Emphasis.Transparency,
					FontFace = normalizeFontFace(designTokens.Typography.BodyLarge.Font),
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextWrapped = true,
					Size = UDim2.new(1, 0, 0, 0),
					LayoutOrder = 3
				})
			}
		),
		HelperText = 0,
		DeviceSummary = 0
	}

	local v19 = if commentErrorMessage ~= nil then module.createElement("TextLabel", {
		Text = commentErrorMessage,
		TextTransparency = designTokens.Color.ActionAlert.Foreground.Transparency,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		BackgroundTransparency = 1,
		TextColor3 = designTokens.Color.ActionAlert.Foreground.Color3,
		FontFace = normalizeFontFace(designTokens.Typography.CaptionSmall.Font),
		TextSize = designTokens.Typography.CaptionSmall.FontSize,
		LineHeight = designTokens.Typography.CaptionSmall.FontSize,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 3
	}) else nil
	children.HelperText = v19

	children.DeviceSummary = module.createElement("TextLabel", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		FontFace = normalizeFontFace(designTokens.Typography.BodyLarge.Font),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		Text = localizedDeviceSummary,
		TextSize = designTokens.Typography.BodyLarge.FontSize,
		TextColor3 = designTokens.Color.Content.Muted.Color3,
		TextTransparency = designTokens.Color.Content.Muted.Transparency,
		LineHeight = designTokens.LineHeight.LineHeight_120,
		LayoutOrder = 4
	})
	return createElement(partialPageModal, v12, {
		Content = createElement2(verticalScrollView, v15, children)
	})
end

return BugReporterModal
