local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent

local Roact = require(parent4.Roact)
local t = require(parent4.t)

local Alert = require(parent.Alert)
local AlertType = require(parent.Enum.AlertType)

local FitFrame = require(parent4.FitFrame)
local FitFrameOnAxis = FitFrame.FitFrameOnAxis

local minWidth = 272
local maxWidth = 400

local GenericTextLabel = require(parent3.Core.Text.GenericTextLabel.GenericTextLabel)
local ImageSetComponent = require(parent3.Core.ImageSet.ImageSetComponent)
local GetTextHeight = require(parent3.Core.Text.GetTextHeight)
local GetFontFromFontStyle = require(parent3.Core.Text.GetFontFromFontStyle)
local withStyle = require(parent3.Core.Style.withStyle)

local ButtonStack = require(parent2.Button.ButtonStack)

local extended = Roact.PureComponent:extend("InteractiveAlert")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = { bottomMargin = 24 }

function extended.render(p)
	return withStyle(function(props)
		minWidth = props.Tokens.Size.Size_400 * 17
		maxWidth = props.Tokens.Size.Size_1000 * 10
		local theme = props.Theme
		local font = props.Font
		local fontFromFontStyle = GetFontFromFontStyle(font.Body)

		local textSize = font.BaseSize * font.Body.RelativeSize

		local titleContent = p.props.titleContent
		local fn = p.props.titleIcon and function()
			return Roact.createElement(FitFrameOnAxis, {
				BackgroundTransparency = 1,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				margin = { top = 12, bottom = 0, left = 0, right = 0 },
				minimumSize = UDim2.new(1, 0, 0, 0)
			}, {
				Icon = Roact.createElement(ImageSetComponent.Label, {
					BackgroundTransparency = 1,
					Image = p.props.titleIcon,
					ImageColor3 = theme.IconEmphasis.Color,
					ImageTransparency = theme.IconEmphasis.Transparency,
					Size = UDim2.new(0, 48, 0, 48)
				})
			})
		end or titleContent

		local v = math.clamp(p.props.screenSize.X - 48, minWidth, maxWidth) - 48

		local footerContent = p.props.footerContent

		if p.props.footerText then
			local textSize2 = font.BaseSize * font.Footer.RelativeSize
			local v2 = p.props.footerText
				and GetTextHeight(
					p.props.footerText,
					GetFontFromFontStyle(font.Footer),
					font.BaseSize * font.Footer.RelativeSize,
					v,
					100
				)
				or 0

			footerContent = function()
				return Roact.createElement(GenericTextLabel, {
					BackgroundTransparency = 1,
					colorStyle = theme.TextDefault,
					fontStyle = font.Footer,
					LayoutOrder = 4,
					Text = p.props.footerText,
					TextSize = textSize2,
					TextXAlignment = Enum.TextXAlignment.Center,
					Size = UDim2.new(1, 0, 0, v2)
				})
			end
		end

		local v2 = p.props.bodyText and GetTextHeight(p.props.bodyText, fontFromFontStyle, textSize, v, 200) or 0

		local middleContent = p.props.middleContent
		local fn2 = p.props.bodyText and function()
			return Roact.createElement(
				FitFrameOnAxis,
				{
					BackgroundTransparency = 1,
					contentPadding = UDim.new(0, 12),
					LayoutOrder = 2,
					minimumSize = UDim2.new(1, 0, 0, 0)
				},
				{
					BodyText = Roact.createElement(GenericTextLabel, {
						BackgroundTransparency = 1,
						colorStyle = theme.TextDefault,
						fontStyle = font.Body,
						LayoutOrder = 1,
						Text = p.props.bodyText,
						RichText = p.props.richText,
						TextSize = textSize,
						TextXAlignment = Enum.TextXAlignment.Center,
						Size = UDim2.new(1, 0, 0, v2)
					}),
					CustomContent = p.props.middleContent and Roact.createElement(
						FitFrameOnAxis,
						{
							BackgroundTransparency = 1,
							LayoutOrder = 2,
							minimumSize = UDim2.new(1, 0, 0, 0)
						},
						{ Content = p.props.middleContent() }
					)
				}
			)
		end or middleContent

		return Roact.createElement(Alert, {
			anchorPoint = p.props.anchorPoint,
			alertType = AlertType.Interactive,
			margin = { top = 0, bottom = p.props.bottomMargin, left = 24, right = 24 },
			maxWidth = maxWidth,
			minWidth = minWidth,
			buttonStackInfo = p.props.buttonStackInfo,
			middleContent = fn2,
			isMiddleContentFocusable = p.props.isMiddleContentFocusable,
			onMounted = p.props.onMounted,
			onAbsoluteSizeChanged = p.props.onAbsoluteSizeChanged,
			position = p.props.position,
			screenSize = p.props.screenSize,
			title = p.props.title,
			titleContent = fn,
			footerContent = footerContent,
			isFooterContentFocusable = p.props.isFooterContentFocusable,
			onCloseClicked = p.props.onCloseClicked,
			defaultChildRef = p.props.defaultChildRef,
			isRoactGamepadEnabled = p.props.isRoactGamepadEnabled
		})
	end)
end

return extended
