local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Core = ParentParentParent.Core
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local Cryo = require(ParentParentParentParent.Cryo)
local FitFrameOnAxis = require(ParentParentParentParent.FitFrame).FitFrameOnAxis
local GenericTextLabel = require(ParentParentParent.Core.Text.GenericTextLabel.GenericTextLabel)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local Images = require(ParentParent.ImageSet.Images)
local ImageSetComponent = require(Core.ImageSet.ImageSetComponent)
local useCursor = require(ParentParentParent.App.SelectionCursor.useCursor)
local uDim = UDim.new(0, 8)
local v15 = Roact.PureComponent:extend("AlertTitle")

v15.validateProps = t.strictInterface({
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
v15.defaultProps = {
	maxWidth = 400,
	minWidth = 272,
	titlePadding = 12,
	margin = {
		top = 0,
		bottom = 24,
		left = 24,
		right = 24
	}
}

function v15.render(p1) -- line: 57
	-- upvalues: withStyle (copy), Roact (copy), FitFrameOnAxis (copy), ImageSetComponent (copy), Images (copy), GenericTextLabel (copy)
	local v18 = math.clamp(p1.props.screenSize.X - p1.props.margin.left - p1.props.margin.right, p1.props.minWidth, p1.props.maxWidth) - p1.props.margin.left - p1.props.margin.right

	return withStyle(function(p2) -- line: 65
		-- upvalues: Roact (copy), FitFrameOnAxis (copy), p1 (copy), ImageSetComponent (copy), Images (copy), GenericTextLabel (copy), v18 (copy)
		local Theme = p2.Theme
		local Header = p2.Tokens.Semantic.Typography.Header
		local FontSize = Header.FontSize

		return Roact.createElement(FitFrameOnAxis, {
			BackgroundTransparency = 1,
			contentPadding = UDim.new(0, 8),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			LayoutOrder = p1.props.layoutOrder,
			margin = {
				top = 12,
				bottom = 0,
				left = 0,
				right = 0
			},
			minimumSize = UDim2.new(1, 0, 0, 0)
		}, {
			TitleContent = p1.props.titleContent and Roact.createElement(FitFrameOnAxis, {
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				minimumSize = UDim2.new(1, 0, 0, 0)
			}, {
				Content = p1.props.titleContent()
			}),
			TitleArea = Roact.createElement(FitFrameOnAxis, {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				contentPadding = UDim.new(0, 12),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				minimumSize = UDim2.new(1, 0, 0, 0)
			}, {
				Title = if not p1.props.onCloseClicked then Roact.createElement(GenericTextLabel, {
					LayoutOrder = 1,
					colorStyle = Theme.TextEmphasis,
					fontStyle = Header,
					maxSize = Vector2.new(v18, FontSize * 2),
					Text = p1.props.title,
					TextSize = FontSize,
					TextTruncate = Enum.TextTruncate.AtEnd
				}) else Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, FontSize)
				}, {
					CloseButton = Roact.createElement(ImageSetComponent.Button, {
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 36, 0, 36),
						Image = Images["icons/navigation/close"],
						ImageColor3 = Theme.IconEmphasis.Color,
						ImageTransparency = Theme.IconEmphasis.Transparency,
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 0, 0.5, 0),
						[Roact.Event.Activated] = p1.props.onCloseClicked,
						SelectionImageObject = p1.props.closeCursor
					}),
					TitleText = Roact.createElement(GenericTextLabel, {
						LayoutOrder = 1,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						colorStyle = Theme.TextEmphasis,
						fontStyle = Header,
						Size = UDim2.new(1, -(2 * (36 + p1.props.titlePadding)), 0, FontSize * 2),
						Text = p1.props.title,
						TextSize = FontSize,
						TextTruncate = Enum.TextTruncate.AtEnd
					})
				}),
				Underline = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					LayoutOrder = 2,
					BackgroundColor3 = Theme.Divider.Color,
					BackgroundTransparency = Theme.Divider.Transparency,
					Size = UDim2.new(1, 0, 0, 1)
				})
			})
		})
	end)
end

local function AlertTitleFunctionalWrapper(p3) -- line: 149
	-- upvalues: useCursor (copy), uDim (copy), Roact (copy), v15 (copy), Cryo (copy)
	local v20 = useCursor(uDim)

	return Roact.createElement(v15, Cryo.Dictionary.join(p3, {
		closeCursor = v20
	}))
end

return AlertTitleFunctionalWrapper
