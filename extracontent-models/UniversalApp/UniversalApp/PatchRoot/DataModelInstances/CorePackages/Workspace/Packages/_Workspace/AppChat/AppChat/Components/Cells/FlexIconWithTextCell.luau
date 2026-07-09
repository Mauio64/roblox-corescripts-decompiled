local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local memo = React.memo
local ImageSetLabel = require(AppChatParent.UIBlox).Core.ImageSet.ImageSetLabel
local BaseCell = require(script.Parent.BaseCell)
local TestStyle = require(AppChat.SocialLibraries).Components.TestStyle

require(AppChat.types)

local t1 = {
	Text = "titleText",
	primaryIconSize = 32,
	isDisabled = false,
	topPadding = 8,
	bottomPadding = 8,
	widthScale = 1,
	widthOffset = 0,
	secondaryIcon = "",
	secondaryIconSize = 24,
	iconCellWidth = 60,
	LayoutOrder = 0,
	BackgroundTransparency = nil,
	showDivider = true,
	onActivated = function() -- line: 54
		print("FlexIconWithTextCell onActivated")
	end,
	style = TestStyle
}

local function FlexIconWithTextCell(t2: {[any]: any}) -- line: 70
	-- upvalues: Cryo (copy), t1 (copy), React (copy), BaseCell (copy), ImageSetLabel (copy)
	local v12 = Cryo.Dictionary.union(t1, t2)
	local style = v12.style
	local Theme = style.Theme
	local styleFont = style.Font
	local v16 = v12.primaryIcon == nil

	return React.createElement(BaseCell, {
		Size = UDim2.new(1, v12.widthOffset, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		BackgroundTransparency = v12.BackgroundTransparency or Theme.BackgroundDefault.Transparency,
		onPressedBackgroundColor3 = Theme.BackgroundOnPress.Color,
		onPressedBackgroundTransparency = Theme.BackgroundOnPress.Transparency,
		LayoutOrder = v12.LayoutOrder,
		onActivated = v12.onActivated,
		showDivider = v12.showDivider,
		dividerColor3 = Theme.Divider.Color,
		dividerTransparency = Theme.Divider.Transparency,
		isDisabled = v12.isDisabled,
		avatarCircleCellWidth = v12.iconCellWidth
	}, {
		leftFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, -v12.iconCellWidth, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			leftListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			leftFramePadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v12.topPadding),
				PaddingBottom = UDim.new(0, v12.bottomPadding)
			}),
			imageFrame = if v16 then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(0, v12.iconCellWidth, 0, v12.primaryIconSize)
			}, {
				primaryIcon = React.createElement(ImageSetLabel, {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = v12.primaryIcon,
					Size = UDim2.new(0, v12.primaryIconSize, 0, v12.primaryIconSize),
					ImageColor3 = Theme.IconEmphasis.Color
				})
			}),
			textFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				uiListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				titleText = React.createElement("TextLabel", {
					TextWrapped = true,
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(1, if not v16 then -v12.iconCellWidth else 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					Text = v12.Text,
					TextSize = styleFont.Header2.RelativeSize * styleFont.BaseSize,
					Font = styleFont.Header2.Font,
					TextColor3 = Theme.TextEmphasis.Color,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd
				}),
				subTitleText = if not v12.SubTitleText then nil else React.createElement("TextLabel", {
					TextWrapped = true,
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					Size = UDim2.new(1, if not v16 then -v12.iconCellWidth else 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					Text = v12.SubTitleText,
					TextSize = styleFont.BodySmall.RelativeSize * styleFont.BaseSize,
					Font = styleFont.BodySmall.Font,
					TextColor3 = Theme.TextDefault.Color,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			})
		}),
		rightFrame = if not v12.secondaryIcon then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v12.iconCellWidth, v12.iconCellWidth)
		}, {
			secondaryIcon = React.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = v12.secondaryIcon,
				Size = UDim2.fromOffset(v12.secondaryIconSize, v12.secondaryIconSize)
			})
		})
	})
end

return memo(FlexIconWithTextCell)
