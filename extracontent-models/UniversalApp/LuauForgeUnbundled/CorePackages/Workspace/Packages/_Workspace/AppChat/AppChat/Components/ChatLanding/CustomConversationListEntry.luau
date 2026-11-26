local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local useChatPagePadding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/useChatPagePadding")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local getBoldTextTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/Utils/getBoldTextTheme")
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local iconSize = UIBlox.App.Constant.IconSize
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")
local FFlagAppChatRemoveConversationListDivider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatRemoveConversationListDivider")

local iconsnavigationpushRight = images["icons/navigation/pushRight"]

function LUAUFORGE_MODULE_GLOBALS_hre_CustomConversationListEntry(props)
	local v5 = useStyle()
	local v6 = getBoldTextTheme(v5)
	local v7 = useTextSizeOffset()
	local v8 = useChatPagePadding()

	local onActivated = props.onActivated

	local titleText = props.titleText
	local transparency = v6.Theme.TextEmphasis.Transparency
	local color = v6.Theme.TextEmphasis.Color
	local v9 = v6.Font.Header2.RelativeSize * v6.Font.BaseSize
	local v10 = v9 + v7
	local subTitleText = props.subTitleText
	local transparency2 = v5.Theme.TextDefault.Transparency
	local color2 = v5.Theme.TextDefault.Color
	local v11 = v5.Font.CaptionBody.RelativeSize * v5.Font.BaseSize
	local v12 = v11 + v7

	local v13 = iconSize.Regular + 12
	local v14 = 60 - (60 - iconSize.Regular) / 2

	local view = Foundation.View
	local createElement = React.createElement
	local v15 = {
		Size = UDim2.new(1, 0, 0, props.entryHeight),
		BackgroundColor3 = v5.Theme.BackgroundDefault.Color,
		BackgroundTransparency = v5.Theme.BackgroundDefault.Transparency,
		onActivated = onActivated,
		testId = 0
	}

	local v16 = if FFlagDebugAppChatEnableDomLocators then props.testId else nil
	v15.testId = v16
	local v17 = {
		leftAlign = React.createElement("Frame", {
			Size = UDim2.new(1, -v13, 1, 0),
			BackgroundTransparency = 1
		}, {
			padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v8.left)
			}),
			layout = React.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			iconHolder = React.createElement(
				"Frame",
				{
					Size = UDim2.new(0, v14, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = 0
				},
				{
					layout = React.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Left
					}),
					icon = React.createElement(imageSetLabel, {
						BackgroundColor3 = v6.Theme.BackgroundUIDefault.Color,
						BackgroundTransparency = v6.Theme.BackgroundUIDefault.Transparency,
						BorderSizePixel = 0,
						Size = UDim2.new(0, iconSize.Regular, 0, iconSize.Regular),
						ScaleType = Enum.ScaleType.Stretch,
						Image = props.entryIcon,
						ImageColor3 = v5.Theme.IconEmphasis.Color,
						ImageTransparency = v5.Theme.IconEmphasis.Transparency
					}, {
						corner = React.createElement("UICorner", {
							CornerRadius = UDim.new(0, 8)
						})
					})
				}
			),
			centerContent = React.createElement(
				"Frame",
				{
					Size = UDim2.new(1, -60, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = 1
				},
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
						Size = UDim2.new(1, 0, 0, v10),
						TextSize = v9,
						TextColor3 = color,
						TextTransparency = transparency,
						FontFace = normalizeFontFace(v5.Tokens.Typography.TitleLarge.Font),
						Text = titleText or "",
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextXAlignment = Enum.TextXAlignment.Left,
						LayoutOrder = 1
					}),
					subTitle = React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v12),
						TextSize = v11,
						TextColor3 = color2,
						TextTransparency = transparency2,
						FontFace = normalizeFontFace(v5.Tokens.Typography.BodySmall.Font),
						Text = subTitleText,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						LayoutOrder = 2
					})
				}
			)
		}),
		rightAlign = React.createElement(
			"Frame",
			{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 },
			{
				layout = React.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				padding = React.createElement("UIPadding", {
					PaddingRight = UDim.new(0, v8.right)
				}),
				icon = React.createElement(imageSetLabel, {
					LayoutOrder = 0,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, iconSize.Regular, 0, iconSize.Regular),
					ScaleType = Enum.ScaleType.Stretch,
					Image = iconsnavigationpushRight,
					ImageColor3 = v5.Theme.IconEmphasis.Color,
					ImageTransparency = v5.Theme.IconEmphasis.Transparency
				})
			}
		),
		divider = 0
	}

	local v18 = if not FFlagAppChatRemoveConversationListDivider then React.createElement(
		"Frame",
		{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 },
		{
			layout = React.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				HorizontalAlignment = Enum.HorizontalAlignment.Right
			}),
			divider = React.createElement("Frame", {
				BackgroundTransparency = v5.Theme.Divider.Transparency,
				BackgroundColor3 = v5.Theme.Divider.Color,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -v14, 0, 1)
			})
		}
	) else nil
	v17.divider = v18
	return createElement(view, v15, v17)
end

return LUAUFORGE_MODULE_GLOBALS_hre_CustomConversationListEntry
