local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local UIBlox = require(AppChatParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local Foundation = require(AppChatParent.Foundation)
local getBoldTextTheme = require(script.Parent.Utils.getBoldTextTheme)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local FFlagAppChatRemoveConversationListDivider = require(AppChat.Flags.FFlagAppChatRemoveConversationListDivider)
local v15 = Images["icons/navigation/pushRight"]

function CustomConversationListEntry(t1: {[any]: any}) -- line: 32
	-- upvalues: useStyle (copy), getBoldTextTheme (copy), useTextSizeOffset (copy), useChatPagePadding (copy), IconSize (copy), Foundation (copy), React (copy), FFlagDebugAppChatEnableDomLocators (copy), ImageSetLabel (copy), v15 (copy), FFlagAppChatRemoveConversationListDivider (copy)
	local v17 = useStyle()
	local v18 = getBoldTextTheme(v17)
	local v19 = useTextSizeOffset()
	local v20 = useChatPagePadding()
	local onActivated = t1.onActivated
	local titleText = t1.titleText
	local Header2Font = v18.Font.Header2.Font
	local TextEmphasisTransparency = v18.Theme.TextEmphasis.Transparency
	local TextEmphasisColor = v18.Theme.TextEmphasis.Color
	local v26 = v18.Font.Header2.RelativeSize * v18.Font.BaseSize
	local v27 = v26 + v19
	local subTitleText = t1.subTitleText
	local CaptionBodyFont = v17.Font.CaptionBody.Font
	local TextDefaultTransparency = v17.Theme.TextDefault.Transparency
	local TextDefaultColor = v17.Theme.TextDefault.Color
	local v32 = v17.Font.CaptionBody.RelativeSize * v17.Font.BaseSize
	local v33 = v32 + v19
	local v34 = IconSize.Regular + 12
	local v35 = 60 - (60 - IconSize.Regular) / 2
	local View = Foundation.View

	return React.createElement(View, {
		Size = UDim2.new(1, 0, 0, t1.entryHeight),
		BackgroundColor3 = v17.Theme.BackgroundDefault.Color,
		BackgroundTransparency = v17.Theme.BackgroundDefault.Transparency,
		onActivated = onActivated,
		testId = if not FFlagDebugAppChatEnableDomLocators then nil else t1.testId
	}, {
		leftAlign = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -v34, 1, 0)
		}, {
			padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v20.left)
			}),
			layout = React.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			iconHolder = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				Size = UDim2.new(0, v35, 1, 0)
			}, {
				layout = React.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Left
				}),
				icon = React.createElement(ImageSetLabel, {
					BorderSizePixel = 0,
					BackgroundColor3 = v18.Theme.BackgroundUIDefault.Color,
					BackgroundTransparency = v18.Theme.BackgroundUIDefault.Transparency,
					Size = UDim2.new(0, IconSize.Regular, 0, IconSize.Regular),
					ScaleType = Enum.ScaleType.Stretch,
					Image = t1.entryIcon,
					ImageColor3 = v17.Theme.IconEmphasis.Color,
					ImageTransparency = v17.Theme.IconEmphasis.Transparency
				}, {
					corner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, 8)
					})
				})
			}),
			centerContent = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, -60, 1, 0)
			}, {
				layout = React.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 2)
				}),
				title = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, v27),
					TextSize = v26,
					TextColor3 = TextEmphasisColor,
					TextTransparency = TextEmphasisTransparency,
					Font = Header2Font,
					Text = titleText or "",
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				subTitle = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, v33),
					TextSize = v32,
					TextColor3 = TextDefaultColor,
					TextTransparency = TextDefaultTransparency,
					Font = CaptionBodyFont,
					Text = subTitleText,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd
				})
			})
		}),
		rightAlign = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			layout = React.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			padding = React.createElement("UIPadding", {
				PaddingRight = UDim.new(0, v20.right)
			}),
			icon = React.createElement(ImageSetLabel, {
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, IconSize.Regular, 0, IconSize.Regular),
				ScaleType = Enum.ScaleType.Stretch,
				Image = v15,
				ImageColor3 = v17.Theme.IconEmphasis.Color,
				ImageTransparency = v17.Theme.IconEmphasis.Transparency
			})
		}),
		divider = if FFlagAppChatRemoveConversationListDivider then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			layout = React.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				HorizontalAlignment = Enum.HorizontalAlignment.Right
			}),
			divider = React.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = v17.Theme.Divider.Transparency,
				BackgroundColor3 = v17.Theme.Divider.Color,
				Size = UDim2.new(1, -v35, 0, 1)
			})
		})
	})
end

return CustomConversationListEntry
