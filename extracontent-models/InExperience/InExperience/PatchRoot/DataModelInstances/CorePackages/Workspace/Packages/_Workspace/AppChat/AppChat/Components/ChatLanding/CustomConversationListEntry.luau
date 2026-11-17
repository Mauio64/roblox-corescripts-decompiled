local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local getBoldTextTheme = require(script.Parent.Utils.getBoldTextTheme)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local FFlagAppChatRemoveConversationListDivider = require(AppChat.Flags.FFlagAppChatRemoveConversationListDivider)

local iconsnavigationpushRight = Images["icons/navigation/pushRight"]

function CustomConversationListEntry(props)
	local v = useStyle()
	local boldTextTheme = getBoldTextTheme(v)
	local v2 = useTextSizeOffset()
	local v3 = useChatPagePadding()

	local onActivated = props.onActivated

	local titleText = props.titleText
	local transparency = boldTextTheme.Theme.TextEmphasis.Transparency
	local color = boldTextTheme.Theme.TextEmphasis.Color
	local textSize = boldTextTheme.Font.Header2.RelativeSize * boldTextTheme.Font.BaseSize
	local v4 = textSize + v2
	local subTitleText = props.subTitleText
	local transparency2 = v.Theme.TextDefault.Transparency
	local color2 = v.Theme.TextDefault.Color
	local textSize2 = v.Font.CaptionBody.RelativeSize * v.Font.BaseSize
	local v5 = textSize2 + v2

	local v6 = IconSize.Regular + 12
	local v7 = 60 - (60 - IconSize.Regular) / 2

	local view = Foundation.View
	local createElement = React.createElement
	local v8 = {
		Size = UDim2.new(1, 0, 0, props.entryHeight),
		BackgroundColor3 = v.Theme.BackgroundDefault.Color,
		BackgroundTransparency = v.Theme.BackgroundDefault.Transparency,
		onActivated = onActivated,
		testId = 0
	}
	local testId

	if FFlagDebugAppChatEnableDomLocators then
		testId = props.testId
	end

	v8.testId = testId
	local v9 = {
		leftAlign = React.createElement("Frame", {
			Size = UDim2.new(1, -v6, 1, 0),
			BackgroundTransparency = 1
		}, {
			padding = React.createElement("UIPadding", { PaddingLeft = UDim.new(0, v3.left) }),
			layout = React.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			iconHolder = React.createElement(
				"Frame",
				{ Size = UDim2.new(0, v7, 1, 0), BackgroundTransparency = 1, LayoutOrder = 0 },
				{
					layout = React.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Left
					}),
					icon = React.createElement(ImageSetLabel, {
						BackgroundColor3 = boldTextTheme.Theme.BackgroundUIDefault.Color,
						BackgroundTransparency = boldTextTheme.Theme.BackgroundUIDefault.Transparency,
						BorderSizePixel = 0,
						Size = UDim2.new(0, IconSize.Regular, 0, IconSize.Regular),
						ScaleType = Enum.ScaleType.Stretch,
						Image = props.entryIcon,
						ImageColor3 = v.Theme.IconEmphasis.Color,
						ImageTransparency = v.Theme.IconEmphasis.Transparency
					}, {
						corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) })
					})
				}
			),
			centerContent = React.createElement(
				"Frame",
				{ Size = UDim2.new(1, -60, 1, 0), BackgroundTransparency = 1, LayoutOrder = 1 },
				{
					layout = React.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 2)
					}),
					title = React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v4),
						TextSize = textSize,
						TextColor3 = color,
						TextTransparency = transparency,
						FontFace = normalizeFontFace(v.Tokens.Typography.TitleLarge.Font),
						Text = titleText or "",
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextXAlignment = Enum.TextXAlignment.Left,
						LayoutOrder = 1
					}),
					subTitle = React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v5),
						TextSize = textSize2,
						TextColor3 = color2,
						TextTransparency = transparency2,
						FontFace = normalizeFontFace(v.Tokens.Typography.BodySmall.Font),
						Text = subTitleText,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						LayoutOrder = 2
					})
				}
			)
		}),
		rightAlign = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1
		}, {
			layout = React.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			padding = React.createElement("UIPadding", { PaddingRight = UDim.new(0, v3.right) }),
			icon = React.createElement(ImageSetLabel, {
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, IconSize.Regular, 0, IconSize.Regular),
				ScaleType = Enum.ScaleType.Stretch,
				Image = iconsnavigationpushRight,
				ImageColor3 = v.Theme.IconEmphasis.Color,
				ImageTransparency = v.Theme.IconEmphasis.Transparency
			})
		}),
		divider = 0
	}
	local divider

	if not FFlagAppChatRemoveConversationListDivider then
		divider = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1
		}, {
			layout = React.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				HorizontalAlignment = Enum.HorizontalAlignment.Right
			}),
			divider = React.createElement("Frame", {
				BackgroundTransparency = v.Theme.Divider.Transparency,
				BackgroundColor3 = v.Theme.Divider.Color,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -v7, 0, 1)
			})
		})
	end

	v9.divider = divider
	return createElement(view, v8, v9)
end

return CustomConversationListEntry
