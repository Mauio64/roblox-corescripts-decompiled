local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")

local withStyle = UIBlox.Core.Style.withStyle

local styledTextLabel = UIBlox.App.Text.StyledTextLabel

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Roact")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/t")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Style").GetTextSize

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

	function self.onContainerSizeChange(p2)
		self:setState(function(p3, p4)
			return { containerWidth = p2.AbsoluteSize.X }
		end)
	end
	function self.getTextSize(p2, p3, p4)
		local baseSize = p4.Font.BaseSize
		local v5 = p3.RelativeSize * baseSize
		local vector2 = Vector2.new(10000, 10000)
		return getTextSize(p2, v5, p3.Font, vector2)
	end
end

function extended.render(data)
	return withStyle(function(p2)
		local theme = p2.Theme
		local font = p2.Font
		local udim = UDim2.new(0, 0, 1, 0)

		if data.props.titleText then
			local textSize = data.getTextSize(data.props.titleText, font.Title, p2)
			local v5 = textSize.Y * 1

			if data.state.containerWidth == nil or not (textSize.X >= data.state.containerWidth) then
				udim = UDim2.new(0, 0, 0, v5)
			else
				udim = UDim2.new(0, 0, 0, v5 * 2)
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
		local v6 = {
			ListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = data.props.verticalAlignment
			}),
			Title = 0,
			SubTitle = 0,
			CustomContentComponentFrame = 0
		}

		local v7 = if data.props.titleText then Roact.createElement(styledTextLabel, {
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
		}) or nil else nil
		v6.Title = v7

		v6.SubTitle = data.props.subTitleText and Roact.createElement(styledTextLabel, {
			text = data.props.subTitleText,
			fontStyle = font.Header2,
			colorStyle = theme.TextMuted,
			automaticSize = Enum.AutomaticSize.XY,
			layoutOrder = 2,
			richText = false
		}) or nil

		v6.CustomContentComponentFrame = data.props.renderInfoContent
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
		return createElement("Frame", onContainerSizeChangesByAbsoluteSize, v6)
	end)
end

return extended
