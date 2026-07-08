local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local Alert = require(scriptParent.Alert)
local AlertType = require(scriptParent.Enum.AlertType)
local FitFrameOnAxis = require(ParentParentParentParent.FitFrame).FitFrameOnAxis
local n1 = 272
local n2 = 400
local GenericTextLabel = require(ParentParentParent.Core.Text.GenericTextLabel.GenericTextLabel)
local ImageSetComponent = require(ParentParentParent.Core.ImageSet.ImageSetComponent)
local GetTextHeight = require(ParentParentParent.Core.Text.GetTextHeight)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local ButtonStack = require(ParentParent.Button.ButtonStack)
local v17 = Roact.PureComponent:extend("InteractiveAlert")

v17.validateProps = t.strictInterface({
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	screenSize = t.Vector2,
	onMounted = t.optional(t.callback),
	onAbsoluteSizeChanged = t.optional(t.callback),
	title = t.string,
	titleIcon = t.optional(t.union(t.table, t.string)),
	titleContent = t.optional(t.callback),
	bodyText = t.optional(t.string),
	richText = t.optional(t.boolean),
	middleContent = t.optional(t.callback),
	buttonStackInfo = ButtonStack.validateProps,
	footerText = t.optional(t.string),
	footerContent = t.optional(t.callback),
	onCloseClicked = t.optional(t.callback),
	bottomMargin = t.optional(t.number),
	defaultChildRef = t.optional(t.union(t.table, t.callback)),
	isMiddleContentFocusable = t.optional(t.boolean),
	isFooterContentFocusable = t.optional(t.boolean),
	isRoactGamepadEnabled = t.optional(t.boolean)
})
v17.defaultProps = {
	bottomMargin = 24
}

function v17.render(p1) -- line: 84
	-- upvalues: withStyle (copy), n1 (ref), n2 (ref), Roact (copy), FitFrameOnAxis (copy), ImageSetComponent (copy), GetTextHeight (copy), GenericTextLabel (copy), Alert (copy), AlertType (copy)
	return withStyle(function(p2) -- line: 85
		-- upvalues: n1 (ref), n2 (ref), p1 (copy), Roact (copy), FitFrameOnAxis (copy), ImageSetComponent (copy), GetTextHeight (copy), GenericTextLabel (copy), Alert (copy), AlertType (copy)
		n1 = p2.Tokens.Global.Size_200 * 17
		n2 = p2.Tokens.Global.Size_500 * 10

		local Theme = p2.Theme
		local p2Font = p2.Font
		local BodyFont = p2Font.Body.Font
		local v23 = p2Font.BaseSize * p2Font.Body.RelativeSize
		local titleContent = p1.props.titleContent

		if p1.props.titleIcon then
			function titleContent() -- line: 96
				-- upvalues: Roact (copy), FitFrameOnAxis (copy), ImageSetComponent (copy), p1 (copy), Theme (copy)
				return Roact.createElement(FitFrameOnAxis, {
					BackgroundTransparency = 1,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					margin = {
						top = 12,
						bottom = 0,
						left = 0,
						right = 0
					},
					minimumSize = UDim2.new(1, 0, 0, 0)
				}, {
					Icon = Roact.createElement(ImageSetComponent.Label, {
						BackgroundTransparency = 1,
						Image = p1.props.titleIcon,
						ImageColor3 = Theme.IconEmphasis.Color,
						ImageTransparency = Theme.IconEmphasis.Transparency,
						Size = UDim2.new(0, 48, 0, 48)
					})
				})
			end
		end

		local v25 = math.clamp(p1.props.screenSize.X - 48, n1, n2) - 48
		local footerContent = p1.props.footerContent

		if p1.props.footerText then
			local v27 = p1.props.footerText and GetTextHeight(p1.props.footerText, p2Font.Footer.Font, p2Font.BaseSize * p2Font.Footer.RelativeSize, v25, 100) or 0

			function footerContent() -- line: 134
				-- upvalues: Roact (copy), GenericTextLabel (copy), Theme (copy), p2Font (copy), p1 (copy), v23 (copy), v27 (copy)
				return Roact.createElement(GenericTextLabel, {
					BackgroundTransparency = 1,
					LayoutOrder = 4,
					colorStyle = Theme.TextDefault,
					fontStyle = p2Font.Footer,
					Text = p1.props.footerText,
					TextSize = v23,
					TextXAlignment = Enum.TextXAlignment.Center,
					Size = UDim2.new(1, 0, 0, v27)
				})
			end
		end

		local v28 = p1.props.bodyText and GetTextHeight(p1.props.bodyText, BodyFont, v23, v25, 200) or 0
		local middleContent = p1.props.middleContent

		if p1.props.bodyText then
			function middleContent() -- line: 154
				-- upvalues: Roact (copy), FitFrameOnAxis (copy), GenericTextLabel (copy), Theme (copy), p2Font (copy), p1 (copy), v23 (copy), v28 (copy)
				return Roact.createElement(FitFrameOnAxis, {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					contentPadding = UDim.new(0, 12),
					minimumSize = UDim2.new(1, 0, 0, 0)
				}, {
					BodyText = Roact.createElement(GenericTextLabel, {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						colorStyle = Theme.TextDefault,
						fontStyle = p2Font.Body,
						Text = p1.props.bodyText,
						RichText = p1.props.richText,
						TextSize = v23,
						TextXAlignment = Enum.TextXAlignment.Center,
						Size = UDim2.new(1, 0, 0, v28)
					}),
					CustomContent = p1.props.middleContent and Roact.createElement(FitFrameOnAxis, {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						minimumSize = UDim2.new(1, 0, 0, 0)
					}, {
						Content = p1.props.middleContent()
					})
				})
			end
		end

		return Roact.createElement(Alert, {
			anchorPoint = p1.props.anchorPoint,
			alertType = AlertType.Interactive,
			margin = {
				top = 0,
				left = 24,
				right = 24,
				bottom = p1.props.bottomMargin
			},
			maxWidth = n2,
			minWidth = n1,
			buttonStackInfo = p1.props.buttonStackInfo,
			middleContent = middleContent,
			isMiddleContentFocusable = p1.props.isMiddleContentFocusable,
			onMounted = p1.props.onMounted,
			onAbsoluteSizeChanged = p1.props.onAbsoluteSizeChanged,
			position = p1.props.position,
			screenSize = p1.props.screenSize,
			title = p1.props.title,
			titleContent = titleContent,
			footerContent = footerContent,
			isFooterContentFocusable = p1.props.isFooterContentFocusable,
			onCloseClicked = p1.props.onCloseClicked,
			defaultChildRef = p1.props.defaultChildRef,
			isRoactGamepadEnabled = p1.props.isRoactGamepadEnabled
		})
	end)
end

return v17
