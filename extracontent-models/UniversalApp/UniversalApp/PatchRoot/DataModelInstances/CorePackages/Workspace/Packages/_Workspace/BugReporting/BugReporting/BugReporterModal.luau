local Parent = script:FindFirstAncestor("BugReporting").Parent
local React = require(Parent.React)

require(Parent.AppCommonLib)

local UIBlox = require(Parent.UIBlox)

require(Parent.SystemInfoProtocol)

local ButtonType = UIBlox.App.Button.Enum.ButtonType
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local VerticalScrollView = UIBlox.App.Container.VerticalScrollView

require(script.Parent.BugReporterTypes)

local function BugReporterModal(t1: {[any]: any}) -- line: 40
	-- upvalues: React (copy), PartialPageModal (copy), ButtonType (copy), VerticalScrollView (copy)
	local localizedStrings = t1.localizedStrings
	local localizedDeviceSummary = t1.localizedDeviceSummary
	local screenSize = t1.screenSize
	local bottomInset = t1.bottomInset
	local designTokens = t1.designTokens
	local t2 = {
		modalTitleHeight = designTokens.Size.Size_1200,
		modalPadding = designTokens.Size.Size_1200,
		modalButtonHeight = designTokens.Size.Size_900,
		contentPadding = designTokens.Size.Size_600,
		labelPadding = designTokens.Size.Size_300,
		screenShotHeight = designTokens.Size.Size_2200
	}
	local screenshotContentId = t1.screenshotContentId
	local scrollContentHeight = t1.scrollContentHeight
	local onListLayoutSizeChange = t1.onListLayoutSizeChange
	local commentText = t1.commentText
	local commentErrorMessage = t1.commentErrorMessage
	local onCommentTextChange = t1.onCommentTextChange
	local canSubmit = t1.canSubmit
	local onSubmit = t1.onSubmit
	local onClose = t1.onClose
	local onScreenKeyboardSizeY = t1.onScreenKeyboardSize.Y
	local v25 = onScreenKeyboardSizeY > 0
	local v26 = -onScreenKeyboardSizeY + bottomInset
	local v27 = if not v25 then t2.modalPadding else 0
	local v28 = screenSize.Y - onScreenKeyboardSizeY - t2.modalTitleHeight - t2.modalPadding * 2 - t2.modalButtonHeight - v27
	local v29 = t2.screenShotHeight + t2.contentPadding * 2 + t2.labelPadding
	local v30 = React.useRef(nil)

	React.useEffect(function() -- line: 77
		-- upvalues: v30 (copy), v25 (copy), v29 (copy)
		local current = v30.current

		if current and v25 then
			current.CanvasPosition = Vector2.new(0, v29)
		end
	end, {
		v25,
		v29
	})
	React.useEffect(function() -- line: 87
		-- upvalues: t1 (copy)
		t1.onLoad()
	end, {})

	return React.createElement(PartialPageModal, {
		marginSize = 0,
		title = localizedStrings.title,
		screenSize = screenSize,
		buttonStackProps = {
			buttons = {{
				buttonType = ButtonType.PrimaryContextual,
				props = {
					onActivated = onSubmit,
					isDisabled = canSubmit == false,
					text = localizedStrings.submit
				}
			}}
		},
		onCloseClicked = onClose,
		position = v25 and UDim2.new(0.5, 0, 1, v26) or nil,
		anchorPoint = v25 and Vector2.new(0.5, 1) or nil
	}, {
		Content = React.createElement(VerticalScrollView, {
			useAutomaticCanvasSize = true,
			size = UDim2.new(1, 0, 0, (math.min(scrollContentHeight + 2 * t2.contentPadding, v28))),
			canvasSizeY = UDim.new(),
			elasticBehavior = Enum.ElasticBehavior.Never,
			scrollingFrameRef = v30
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, t2.contentPadding),
				[React.Change.AbsoluteContentSize] = onListLayoutSizeChange
			}),
			ContentPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, t2.contentPadding),
				PaddingBottom = UDim.new(0, t2.contentPadding),
				PaddingLeft = UDim.new(0, t2.contentPadding),
				PaddingRight = UDim.new(0, t2.contentPadding)
			}),
			ScreenshotContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					Padding = UDim.new(0, t2.labelPadding),
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
					ItemLineAlignment = Enum.ItemLineAlignment.End
				}),
				Screenshot = React.createElement("ImageLabel", {
					BackgroundTransparency = 0,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, t2.screenShotHeight),
					Image = screenshotContentId,
					ScaleType = Enum.ScaleType.Tile,
					SizeConstraint = Enum.SizeConstraint.RelativeYY
				}, {
					UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
						AspectRatio = math.max(1, screenSize.X) / math.max(1, screenSize.Y)
					})
				}),
				ScreenshotAnnotation = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					Font = designTokens.Typography.BodyLarge.Font,
					TextXAlignment = Enum.TextXAlignment.Left,
					Text = localizedStrings.screenshotAnnotation,
					TextSize = designTokens.Typography.BodyLarge.FontSize,
					TextColor3 = designTokens.Color.Content.Default.Color3,
					TextTransparency = designTokens.Color.Content.Default.Transparency,
					LineHeight = designTokens.LineHeight.LineHeight_120
				})
			}),
			CommentContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, t2.labelPadding)
				}),
				CommmentLabel = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextWrapped = true,
					LayoutOrder = 1,
					Text = localizedStrings.commentLabel,
					TextSize = designTokens.Typography.BodyLarge.FontSize,
					TextColor3 = designTokens.Color.Content.Emphasis.Color3,
					TextTransparency = designTokens.Color.Content.Emphasis.Transparency,
					Font = designTokens.Typography.BodyLarge.Font,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}),
				Commment = React.createElement("Frame", {
					BorderSizePixel = 1,
					LayoutOrder = 2,
					BackgroundColor3 = designTokens.Color.Surface.Surface_200.Color3,
					BackgroundTransparency = designTokens.Color.Surface.Surface_200.Transparency,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					UICorner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, designTokens.Radius.Small)
					}),
					UIPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, designTokens.Size.Size_200),
						PaddingBottom = UDim.new(0, designTokens.Size.Size_200),
						PaddingLeft = UDim.new(0, designTokens.Size.Size_200),
						PaddingRight = UDim.new(0, designTokens.Size.Size_200)
					}),
					TextBox = React.createElement("TextBox", {
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
						Font = designTokens.Typography.BodyLarge.Font,
						TextSize = designTokens.Typography.BodyLarge.FontSize,
						AutomaticSize = Enum.AutomaticSize.Y,
						BorderSizePixel = 0,
						[React.Change.Text] = onCommentTextChange
					})
				}),
				CharacterCount = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextWrapped = true,
					LayoutOrder = 3,
					Text = localizedStrings.commentCharacterCount,
					TextSize = designTokens.Typography.BodyLarge.FontSize,
					TextColor3 = designTokens.Color.Content.Emphasis.Color3,
					TextTransparency = designTokens.Color.Content.Emphasis.Transparency,
					Font = designTokens.Typography.BodyLarge.Font,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				})
			}),
			HelperText = if commentErrorMessage == nil then nil else React.createElement("TextLabel", {
				TextWrapped = true,
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Text = commentErrorMessage,
				TextTransparency = designTokens.Color.ActionAlert.Foreground.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextColor3 = designTokens.Color.ActionAlert.Foreground.Color3,
				Font = designTokens.Typography.CaptionSmall.Font,
				TextSize = designTokens.Typography.CaptionSmall.FontSize,
				LineHeight = designTokens.Typography.CaptionSmall.FontSize,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}),
			DeviceSummary = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				LayoutOrder = 4,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				Font = designTokens.Typography.BodyLarge.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = localizedDeviceSummary,
				TextSize = designTokens.Typography.BodyLarge.FontSize,
				TextColor3 = designTokens.Color.Content.Muted.Color3,
				TextTransparency = designTokens.Color.Content.Muted.Transparency,
				LineHeight = designTokens.LineHeight.LineHeight_120
			})
		})
	})
end

return BugReporterModal
