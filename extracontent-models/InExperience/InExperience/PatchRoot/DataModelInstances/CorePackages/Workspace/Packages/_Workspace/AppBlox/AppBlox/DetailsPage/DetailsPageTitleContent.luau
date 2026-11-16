local parent = script:FindFirstAncestor("AppBlox").Parent
local UIBlox = require(parent.UIBlox)

local withStyle = UIBlox.Core.Style.withStyle

local StyledTextLabel = UIBlox.App.Text.StyledTextLabel

local Roact = require(parent.Roact)
local t = require(parent.t)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize

local extended = Roact.PureComponent:extend("DetailsPageTitleContent")

extended.validateProps = t.strictInterface({
	titleText = t.optional(t.string),
	subTitleText = t.optional(t.string),
	renderInfoContent = t.optional(t.callback),
	layoutOrder = t.optional(t.number),
	verticalAlignment = t.optional(t.enum(Enum.VerticalAlignment))
})

function extended:init()
	self.state = { containerWidth = nil }

	function self.onContainerSizeChange(p)
		self:setState(function(_, _)
			return { containerWidth = p.AbsoluteSize.X }
		end)
	end
	function self.getTextSize(p, p2, p3)
		local baseSize = p3.Font.BaseSize
		local v = p2.RelativeSize * baseSize
		local vector2 = Vector2.new(10000, 10000)
		return GetTextSize(p, v, p2.Font, vector2)
	end
end

function extended.render(data)
	return withStyle(function(p)
		local theme = p.Theme
		local font = p.Font
		local udim = UDim2.new(0, 0, 1, 0)

		if data.props.titleText then
			local textSize = data.getTextSize(data.props.titleText, font.Title, p)
			local v = textSize.Y * 1

			if data.state.containerWidth == nil or not (textSize.X >= data.state.containerWidth) then
				udim = UDim2.new(0, 0, 0, v)
			else
				udim = UDim2.new(0, 0, 0, v * 2)
			end
		end

		local createElement = Roact.createElement
		local onContainerSizeChangesByAbsoluteSize = {
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			[Roact.Change.AbsoluteSize] = data.onContainerSizeChange,
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = data.props.layoutOrder
		}
		local v = {
			ListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = data.props.verticalAlignment
			}),
			Title = 0,
			SubTitle = 0,
			CustomContentComponentFrame = 0
		}
		local title

		if data.props.titleText then
			title = Roact.createElement(StyledTextLabel, {
				text = data.props.titleText,
				size = udim,
				automaticSize = Enum.AutomaticSize.X,
				fontStyle = font.Title,
				colorStyle = theme.TextEmphasis,
				textTruncate = Enum.TextTruncate.AtEnd,
				lineHeight = 1,
				fluidSizing = false,
				layoutOrder = 1,
				richText = false
			}) or nil
		end

		v.Title = title

		v.SubTitle = data.props.subTitleText and Roact.createElement(StyledTextLabel, {
			text = data.props.subTitleText,
			fontStyle = font.Header2,
			colorStyle = theme.TextMuted,
			automaticSize = Enum.AutomaticSize.XY,
			layoutOrder = 2,
			richText = false
		}) or nil

		v.CustomContentComponentFrame = data.props.renderInfoContent
			and Roact.createElement(
				"Frame",
				{
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					LayoutOrder = 3
				},
				{ CustomContent = data.props.renderInfoContent() }
			)
			or nil
		return createElement("Frame", onContainerSizeChangesByAbsoluteSize, v)
	end)
end

return extended
