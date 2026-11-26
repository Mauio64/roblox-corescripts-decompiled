local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)

local useStyle = UIBlox.Core.Style.useStyle
local useCursorByType = UIBlox.App.SelectionCursor.useCursorByType
local cursorType = UIBlox.App.SelectionCursor.CursorType

return function(props)
	local v5 = useStyle()

	local font = v5.Font
	local theme = v5.Theme

	local isSelected = props.isSelected

	local font2 = font.Header2.Font
	local v6 = font.BaseSize * font.Header2.RelativeSize

	local tabTitle = props.tabTitle

	local color = isSelected and theme.TextEmphasis.Color or theme.TextMuted.Color
	local transparency = isSelected and theme.TextEmphasis.Transparency or theme.TextMuted.Transparency

	local ref = props.ref

	local frameRef = props.frameRef

	local v7 = useCursorByType(cursorType.NavHighlight)

	local tabsLength = props.tabsLength

	local v8 = not (tabsLength > 0) and 1 or 1 / tabsLength

	local createElement = React.createElement
	local v10 = {
		Size = UDim2.new(v8, 0, 1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		ref = frameRef
	}

	local children = {
		Button = React.createElement(focusable.TextButton, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = tabTitle,
			TextSize = v6,
			TextColor3 = color,
			TextTransparency = transparency,
			Font = font2,
			[React.Event.Activated] = function()
				props.onActivate(props.tabIndex)
			end,
			ref = ref,
			NextSelectionLeft = props.NextSelectionLeft,
			NextSelectionRight = props.NextSelectionRight,
			NextSelectionUp = props.NextSelectionUp,
			NextSelectionDown = props.NextSelectionDown,
			SelectionImageObject = v7
		}),
		Frame = 0
	}

	local createElement3 = React.createElement
	local v13 = {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, isSelected and 3 or 1),
		BorderSizePixel = 0,
		BackgroundColor3 = 0,
		BackgroundTransparency = 0
	}

	local v14 = if isSelected then theme.IconEmphasis.Color else theme.Divider.Color
	v13.BackgroundColor3 = v14
	local v15 = if isSelected then theme.IconEmphasis.Transparency else theme.Divider.Transparency
	v13.BackgroundTransparency = v15
	children.Frame = createElement3("Frame", v13)
	return createElement("Frame", v10, children)
end
