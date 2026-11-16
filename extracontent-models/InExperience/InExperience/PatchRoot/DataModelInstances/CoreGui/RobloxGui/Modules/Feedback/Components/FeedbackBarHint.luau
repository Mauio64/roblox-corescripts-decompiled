local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)

local withStyle = UIBlox.Core.Style.withStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel

local defineFastFlag = game:DefineFastFlag("FeedbackBarHintSizeAdjustment", false)

local extended = Roact.PureComponent:extend("FeedbackBarHint")

extended.validateProps = t.strictInterface({
	layoutOrder = t.optional(t.integer),
	text = t.string,
	maxWidth = t.optional(t.number),
	hintTextSize = t.optional(t.number)
})

function extended.render(p)
	return withStyle(function(p2)
		local theme = p2.Theme
		local font = p2.Font

		local createElement = Roact.createElement
		local v = {
			LayoutOrder = p.props.layoutOrder,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.X
		}
		local v2 = {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 8)
			}),
			FeedbackBarHintText = 0
		}

		local createElement2 = Roact.createElement
		local v3 = {
			textSize = p.props.hintTextSize,
			maxSize = 0,
			layoutOrder = 2,
			fontStyle = 0,
			colorStyle = 0,
			automaticSize = 0,
			fluidSizing = 0,
			text = 0,
			textTruncate = 0,
			textXAlignment = 0,
			textYAlignment = 0
		}
		local vector2

		if p.props.maxWidth then
			if defineFastFlag then
				vector2 = Vector2.new(1000, p.props.maxWidth)
			else
				vector2 = Vector2.new(p.props.maxWidth)
			end
		end

		v3.maxSize = vector2

		v3.fontStyle = font.Header2
		v3.colorStyle = theme.TextEmphasis
		local automaticSize

		if not p.props.maxWidth then
			automaticSize = Enum.AutomaticSize.X
		end

		v3.automaticSize = automaticSize
		v3.fluidSizing = p.props.maxWidth and true or false
		v3.text = p.props.text
		local textTruncate

		if p.props.maxWidth then
			textTruncate = Enum.TextTruncate.AtEnd
		end

		v3.textTruncate = textTruncate

		v3.textXAlignment = Enum.TextXAlignment.Left
		v3.textYAlignment = Enum.TextYAlignment.Center
		v2.FeedbackBarHintText = createElement2(StyledTextLabel, v3)
		return createElement("Frame", v, v2)
	end)
end

return extended
