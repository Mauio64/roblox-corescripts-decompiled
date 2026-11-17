local parent = script.Parent.Parent.Parent.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize

local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle

return function(props)
	local v = useStyle()

	local font = v.Tokens.Typography.TitleLarge.Font
	local v2 = v.Font.BaseSize * v.Font.Header2.RelativeSize

	local v3 = React.useMemo(function()
		if props.buttonWidth then
			return props.buttonWidth
		end

		return GetTextSize(props.text, v2, font, Vector2.new(10000, 10000)).X + 24
	end, { props.text, font, v2, props.buttonWidth })
	local size

	if props.buttonHeight then
		size = UDim2.fromOffset(v3, props.buttonHeight)
	else
		size = UDim2.new(0, v3, 1, 0)
	end

	return React.createElement("Frame", {
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		Position = props.Position,
		Size = size
	}, {
		ShowMoreButton = React.createElement(Button, {
			buttonType = ButtonType.Secondary,
			onActivated = props.onActivated,
			size = UDim2.fromScale(1, 1),
			text = props.text
		})
	})
end
