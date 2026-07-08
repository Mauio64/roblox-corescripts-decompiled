local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local withStyle = UIBlox.Core.Style.withStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local v7 = game:DefineFastFlag("FeedbackBarHintSizeAdjustment", false)
local v8 = Roact.PureComponent:extend("FeedbackBarHint")

v8.validateProps = t.strictInterface({
	layoutOrder = t.optional(t.integer),
	text = t.string,
	maxWidth = t.optional(t.number),
	hintTextSize = t.optional(t.number)
})

function v8.render(p1) -- line: 32
	-- upvalues: withStyle (copy), Roact (copy), StyledTextLabel (copy), v7 (copy)
	return withStyle(function(p2) -- line: 33
		-- upvalues: Roact (copy), p1 (copy), StyledTextLabel (copy), v7 (copy)
		local Theme = p2.Theme
		local p2Font = p2.Font

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = p1.props.layoutOrder,
			AutomaticSize = Enum.AutomaticSize.X
		}, {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 8)
			}),
			FeedbackBarHintText = Roact.createElement(StyledTextLabel, {
				layoutOrder = 2,
				textSize = p1.props.hintTextSize,
				maxSize = if not p1.props.maxWidth then nil else if not v7 then Vector2.new(p1.props.maxWidth) else Vector2.new(1000, p1.props.maxWidth),
				fontStyle = p2Font.Header2,
				colorStyle = Theme.TextEmphasis,
				automaticSize = if p1.props.maxWidth then nil else Enum.AutomaticSize.X,
				fluidSizing = not not p1.props.maxWidth,
				text = p1.props.text,
				textTruncate = if not p1.props.maxWidth then nil else Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center
			})
		})
	end)
end

return v8
