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
	secondaryIcon = "",
	secondaryIconSize = 24,
	iconCellWidth = 60,
	LayoutOrder = 0,
	showDivider = true,
	Size = UDim2.new(1, 0, 1, 0),
	onActivated = function() -- line: 44
		print("IconWithTextCell onActivated")
	end,
	style = Cryo.Dictionary.join(TestStyle, {
		Tokens = {
			Color = {
				None = {}
			}
		}
	})
}

local function IconWithTextCell(t2: {[any]: any}) -- line: 65
	-- upvalues: Cryo (copy), t1 (copy), React (copy), BaseCell (copy), ImageSetLabel (copy)
	local v12 = Cryo.Dictionary.join(t1, t2)
	local style = v12.style
	local Theme = style.Theme
	local styleFont = style.Font
	local v16 = v12.primaryIcon == nil

	return React.createElement(BaseCell, {
		Size = v12.Size,
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		BackgroundTransparency = style.Tokens.Color.None.Transparency,
		onPressedBackgroundColor3 = Theme.BackgroundOnPress.Color,
		onPressedBackgroundTransparency = Theme.BackgroundOnPress.Transparency,
		LayoutOrder = v12.LayoutOrder,
		onActivated = v12.onActivated,
		showDivider = v12.showDivider,
		dividerColor3 = Theme.Divider.Color,
		dividerTransparency = Theme.Divider.Transparency,
		isDisabled = v12.isDisabled,
		avatarCircleCellWidth = v12.iconCellWidth,
		testId = t2.testId
	}, {
		leftFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.new(1, -v12.iconCellWidth, 1, 0)
		}, {
			leftListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
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
			text = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, if not v16 then -v12.iconCellWidth else 0, 1, 0),
				Text = v12.Text,
				TextSize = styleFont.Header2.RelativeSize * styleFont.BaseSize,
				Font = styleFont.Header2.Font,
				TextColor3 = Theme.TextEmphasis.Color,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd
			})
		}),
		rightFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.fromScale(1, 0.5),
			Size = UDim2.fromOffset(v12.iconCellWidth, v12.iconCellWidth)
		}, {
			secondaryIcon = v12.secondaryIcon and React.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = v12.secondaryIcon,
				Size = UDim2.fromOffset(v12.secondaryIconSize, v12.secondaryIconSize)
			})
		})
	})
end

return memo(IconWithTextCell)
