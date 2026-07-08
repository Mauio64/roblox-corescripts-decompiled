local Parent = script:FindFirstAncestor("AppBlox").Parent
local UIBlox = require(Parent.UIBlox)
local withStyle = UIBlox.Core.Style.withStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Roact = require(Parent.Roact)
local t = require(Parent.t)
local GetTextSize = require(Parent.Style).GetTextSize
local v8 = Roact.PureComponent:extend("DetailsPageTitleContent")

v8.validateProps = t.strictInterface({
	titleText = t.optional(t.string),
	subTitleText = t.optional(t.string),
	renderInfoContent = t.optional(t.callback),
	layoutOrder = t.optional(t.number),
	verticalAlignment = t.optional(t.enum(Enum.VerticalAlignment))
})

function v8.init(p1) -- line: 27
	-- upvalues: GetTextSize (copy)
	p1.state = {
		containerWidth = nil
	}

	function p1.onContainerSizeChange(p2) -- line: 31
		-- upvalues: p1 (copy)
		p1:setState(function(_, _) -- line: 32
			-- upvalues: p2 (copy)
			return {
				containerWidth = p2.AbsoluteSize.X
			}
		end)
	end
	function p1.getTextSize(p5, p6, p7) -- line: 38
		-- upvalues: GetTextSize (copy)
		local BaseSize = p7.Font.BaseSize
		local v16 = p6.RelativeSize * BaseSize
		local vector2 = Vector2.new(10000, 10000)

		return GetTextSize(p5, v16, p6.Font, vector2)
	end
end
function v8.render(p8) -- line: 46
	-- upvalues: withStyle (copy), Roact (copy), StyledTextLabel (copy)
	return withStyle(function(p9) -- line: 47
		-- upvalues: p8 (copy), Roact (copy), StyledTextLabel (copy)
		local Theme = p9.Theme
		local p9Font = p9.Font
		local uDim2 = UDim2.new(0, 0, 1, 0)

		if p8.props.titleText then
			local v22 = p8.getTextSize(p8.props.titleText, p9Font.Title, p9)
			local v23 = v22.Y * 1

			uDim2 = if p8.state.containerWidth == nil or not (v22.X >= p8.state.containerWidth) then UDim2.new(0, 0, 0, v23) else UDim2.new(0, 0, 0, v23 * 2)
		end

		return Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			[Roact.Change.AbsoluteSize] = p8.onContainerSizeChange,
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = p8.props.layoutOrder
		}, {
			ListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = p8.props.verticalAlignment
			}),
			Title = p8.props.titleText and Roact.createElement(StyledTextLabel, {
				lineHeight = 1,
				fluidSizing = false,
				layoutOrder = 1,
				richText = false,
				text = p8.props.titleText,
				size = uDim2,
				automaticSize = Enum.AutomaticSize.X,
				fontStyle = p9Font.Title,
				colorStyle = Theme.TextEmphasis,
				textTruncate = Enum.TextTruncate.AtEnd
			}) or nil,
			SubTitle = p8.props.subTitleText and Roact.createElement(StyledTextLabel, {
				layoutOrder = 2,
				richText = false,
				text = p8.props.subTitleText,
				fontStyle = p9Font.Header2,
				colorStyle = Theme.TextMuted,
				automaticSize = Enum.AutomaticSize.XY
			}) or nil,
			CustomContentComponentFrame = p8.props.renderInfoContent and Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				CustomContent = p8.props.renderInfoContent()
			}) or nil
		})
	end)
end

return v8
