local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local useChatPagePadding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/useChatPagePadding")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local getBoldTextTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/Utils/getBoldTextTheme")
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local iconSize = UIBlox.App.Constant.IconSize
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")
local FFlagAppChatRemoveConversationListDivider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatRemoveConversationListDivider")

local iconsnavigationpushRight = images["icons/navigation/pushRight"]

function LUAUFORGE_MODULE_GLOBALS_hgu_CustomConversationListEntry(props)
	local v5 = useStyle()
	local v6 = getBoldTextTheme(v5)
	local v7 = useTextSizeOffset()
	local v8 = useChatPagePadding()

	local onActivated = props.onActivated

	local titleText = props.titleText
	local font = v6.Font.Header2.Font
	local transparency = v6.Theme.TextEmphasis.Transparency
	local color = v6.Theme.TextEmphasis.Color
	local v9 = v6.Font.Header2.RelativeSize * v6.Font.BaseSize
	local v10 = v9 + v7
	local subTitleText = props.subTitleText
	local font2 = v5.Font.CaptionBody.Font
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

	local createElement2 = React.createElement
	local v18 = {
		Size = UDim2.new(1, -v13, 1, 0),
		BackgroundTransparency = 1
	}

	local v19 = {
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
		centerContent = 0
	}

	local createElement3 = React.createElement
	local v21 = {
		Size = UDim2.new(1, -60, 1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}

	local children2 = {
		layout = React.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 2)
		}),
		title = 0,
		subTitle = 0
	}

	local createElement4 = React.createElement
	local v23 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v10),
		TextSize = v9,
		TextColor3 = color,
		TextTransparency = transparency,
		Font = 0,
		FontFace = 0,
		Text = 0,
		TextTruncate = 0,
		TextXAlignment = 0,
		LayoutOrder = 1
	}

	if foundationFontFaceMigration then
		font = nil
	end

	v23.Font = font

	local v24 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.TitleLarge.Font) else nil
	v23.FontFace = v24

	v23.Text = titleText or ""
	v23.TextTruncate = Enum.TextTruncate.AtEnd
	v23.TextXAlignment = Enum.TextXAlignment.Left
	children2.title = createElement4("TextLabel", v23)

	local createElement5 = React.createElement
	local v26 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v12),
		TextSize = v11,
		TextColor3 = color2,
		TextTransparency = transparency2,
		Font = 0,
		FontFace = 0,
		Text = 0,
		TextXAlignment = 0,
		TextTruncate = 0,
		LayoutOrder = 2
	}

	if foundationFontFaceMigration then
		font2 = nil
	end

	v26.Font = font2

	local v27 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.BodySmall.Font) else nil
	v26.FontFace = v27

	v26.Text = subTitleText
	v26.TextXAlignment = Enum.TextXAlignment.Left
	v26.TextTruncate = Enum.TextTruncate.AtEnd
	children2.subTitle = createElement5("TextLabel", v26)
	v19.centerContent = createElement3("Frame", v21, children2)
	local children = {
		leftAlign = createElement2("Frame", v18, v19),
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

	local v28 = if not FFlagAppChatRemoveConversationListDivider then React.createElement(
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
	children.divider = v28
	return createElement(view, v15, children)
end

return LUAUFORGE_MODULE_GLOBALS_hgu_CustomConversationListEntry
