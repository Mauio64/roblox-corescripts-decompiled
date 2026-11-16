local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local core = parent2.Core

local Roact = require(parent3.Roact)
local t = require(parent3.t)
local Cryo = require(parent3.Cryo)

local FitFrame = require(parent3.FitFrame)
local FitFrameOnAxis = FitFrame.FitFrameOnAxis

local GenericTextLabel = require(parent2.Core.Text.GenericTextLabel.GenericTextLabel)
local withStyle = require(parent2.Core.Style.withStyle)
local Images = require(parent.ImageSet.Images)
local ImageSetComponent = require(core.ImageSet.ImageSetComponent)
local useCursor = require(parent2.App.SelectionCursor.useCursor)

local udim = UDim.new(0, 8)

local extended = Roact.PureComponent:extend("AlertTitle")

extended.validateProps = t.strictInterface({
	layoutOrder = t.optional(t.number),
	margin = t.optional(t.table),
	maxWidth = t.optional(t.number),
	minWidth = t.optional(t.number),
	screenSize = t.Vector2,
	title = t.string,
	titlePadding = t.optional(t.number),
	titleContent = t.optional(t.callback),
	onCloseClicked = t.optional(t.callback),
	closeCursor = t.optional(t.table)
})

extended.defaultProps = {
	margin = { top = 0, bottom = 24, left = 24, right = 24 },
	maxWidth = 400,
	minWidth = 272,
	titlePadding = 12
}

function extended.render(p)
	local v = math.clamp(
		p.props.screenSize.X - p.props.margin.left - p.props.margin.right,
		p.props.minWidth,
		p.props.maxWidth
	) - p.props.margin.left - p.props.margin.right

	return withStyle(function(p2)
		local theme = p2.Theme

		local headingSmall = p2.Tokens.Typography.HeadingSmall
		local fontSize = headingSmall.FontSize

		local createElement = Roact.createElement
		local v2 = {
			BackgroundTransparency = 1,
			contentPadding = UDim.new(0, 8),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			LayoutOrder = p.props.layoutOrder,
			margin = { top = 12, bottom = 0, left = 0, right = 0 },
			minimumSize = UDim2.new(1, 0, 0, 0)
		}
		local v3 = {
			TitleContent = p.props.titleContent and Roact.createElement(
				FitFrameOnAxis,
				{ BackgroundTransparency = 1, LayoutOrder = 0, minimumSize = UDim2.new(1, 0, 0, 0) },
				{ Content = p.props.titleContent() }
			),
			TitleArea = 0
		}

		local createElement2 = Roact.createElement
		local v4 = {
			BackgroundTransparency = 1,
			contentPadding = UDim.new(0, 12),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			LayoutOrder = 1,
			minimumSize = UDim2.new(1, 0, 0, 0)
		}
		local title

		if p.props.onCloseClicked then
			title = Roact.createElement(
				"Frame",
				{ BackgroundTransparency = 1, LayoutOrder = 1, Size = UDim2.new(1, 0, 0, fontSize) },
				{
					CloseButton = Roact.createElement(ImageSetComponent.Button, {
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 36, 0, 36),
						Image = Images["icons/navigation/close"],
						ImageColor3 = theme.IconEmphasis.Color,
						ImageTransparency = theme.IconEmphasis.Transparency,
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 0, 0.5, 0),
						[Roact.Event.Activated] = p.props.onCloseClicked,
						SelectionImageObject = p.props.closeCursor
					}),
					TitleText = Roact.createElement(GenericTextLabel, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						colorStyle = theme.TextEmphasis,
						fontStyle = headingSmall,
						Size = UDim2.new(1, -(2 * (36 + p.props.titlePadding)), 0, fontSize * 2),
						LayoutOrder = 1,
						Text = p.props.title,
						TextSize = fontSize,
						TextTruncate = Enum.TextTruncate.AtEnd
					})
				}
			)
		else
			title = Roact.createElement(GenericTextLabel, {
				colorStyle = theme.TextEmphasis,
				fontStyle = headingSmall,
				maxSize = Vector2.new(v, fontSize * 2),
				LayoutOrder = 1,
				Text = p.props.title,
				TextSize = fontSize,
				TextTruncate = Enum.TextTruncate.AtEnd
			})
		end

		v3.TitleArea = createElement2(FitFrameOnAxis, v4, {
			Title = title,
			Underline = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundColor3 = theme.Divider.Color,
				BackgroundTransparency = theme.Divider.Transparency,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 1)
			})
		})
		return createElement(FitFrameOnAxis, v2, v3)
	end)
end

local function AlertTitleFunctionalWrapper(p)
	local closeCursor = useCursor(udim)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { closeCursor = closeCursor }))
end

return AlertTitleFunctionalWrapper
