local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent

local Roact = require(parent4.Roact)
local t = require(parent4.t)
local Otter = require(parent4.Otter)

local withStyle = require(parent3.Core.Style.withStyle)
local Images = require(parent2.ImageSet.Images)
local ImageSetComponent = require(parent3.Core.ImageSet.ImageSetComponent)
local Label = ImageSetComponent.Label
local GenericTextLabel = require(parent3.Core.Text.GenericTextLabel.GenericTextLabel)
local GetTextSize = require(parent3.Core.Text.GetTextSize)
local GetTextHeight = require(parent3.Core.Text.GetTextHeight)

local divideTransparency = require(parent3.Utility.divideTransparency)
local lerp = require(parent3.Utility.lerp)

local TooltipOrientation = require(parent.Enum.TooltipOrientation)
local getPositionInfo = require(parent.getPositionInfo)

local v = {
	[TooltipOrientation.Bottom] = Images["component_assets/triangleUp_16"],
	[TooltipOrientation.Top] = Images["component_assets/triangleDown_16"],
	[TooltipOrientation.Right] = Images["component_assets/triangleLeft_16"],
	[TooltipOrientation.Left] = Images["component_assets/triangleRight_16"]
}

local v2 = { frequency = 50, dampingRatio = 1 }

local extended = Roact.PureComponent:extend("TooltipContainer")

extended.validateProps = t.strictInterface({
	triggerPosition = t.Vector2,
	triggerSize = t.Vector2,
	bodyText = t.string,
	headerText = t.optional(t.string),
	screenSize = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	orientation = t.optional(TooltipOrientation.isEnumValue),
	isDirectChild = t.optional(t.boolean)
})

extended.defaultProps = {
	screenSize = Vector2.new(10000, 10000),
	orientation = TooltipOrientation.Bottom,
	isDirectChild = false
}

function extended:init()
	self.visible = true

	local binding, v3 = Roact.createBinding(0)
	self.progress = binding

	self.progressMotor = Otter.createSingleMotor(0)
	self.progressMotor:onStep(v3)
	self.progressMotor:setGoal(Otter.spring(1, v2))
end

function extended.render(data)
	return withStyle(function(p)
		local font = p.Font
		local theme = p.Theme

		local captionHeader = font.CaptionHeader
		local captionBody = font.CaptionBody

		local v3 = font.BaseSize * font.CaptionBody.RelativeSize

		local x = GetTextSize(data.props.bodyText, v3, captionBody.Font, Vector2.new()).X

		if data.props.headerText then
			x = math.max(
				x,
				GetTextSize(
					data.props.headerText,
					font.BaseSize * captionHeader.RelativeSize,
					captionHeader.Font,
					Vector2.new()
				).X
			)
		end

		local v4 = math.min(x, 216)
		local v5 = v4 + 24

		local textHeight = GetTextHeight(data.props.bodyText, captionBody.Font, v3, v4)
		local v6 = data.props.headerText and GetTextHeight(data.props.headerText, captionHeader.Font, v3, v4) or 0

		local v7 = data.props.headerText and v6 + textHeight + 24 + 4 or textHeight + 24

		local positionInfo = getPositionInfo(
			v5,
			v7,
			data.props.orientation,
			data.props.triggerPosition,
			data.props.triggerSize,
			data.props.screenSize,
			data.props.position
		)

		local mapped = data.progress:map(function(p2)
			local position

			if data.props.position then
				position = data.props.position
			else
				position = data.props.isDirectChild and positionInfo.position or positionInfo.absolutePosition
			end

			return position:lerp(position + positionInfo.animatedDistance, p2)
		end)

		local mapped2 = data.progress:map(function(p2)
			return lerp(1, divideTransparency(theme.BackgroundMuted.Transparency, 1), p2)
		end)

		local mapped3 = data.progress:map(function(p2)
			return lerp(1, divideTransparency(theme.TextEmphasis.Transparency, 2), p2)
		end)

		return Roact.createElement("Frame", {
			Visible = data.visible,
			Position = mapped,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = positionInfo.fillDirection == Enum.FillDirection.Vertical and UDim2.fromOffset(v5, v7 + 8) or UDim2.fromOffset(v5 + 8, v7)
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = positionInfo.fillDirection
			}),
			CaretFrame = Roact.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = positionInfo.caretFrameSize,
					LayoutOrder = positionInfo.caretLayoutOrder
				},
				{
					Caret = Roact.createElement(Label, {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = positionInfo.caretPosition,
						AnchorPoint = positionInfo.caretAnchorPoint,
						Size = positionInfo.caretImageSize,
						Image = v[positionInfo.updatedOrientation],
						ImageColor3 = theme.BackgroundMuted.Color,
						ImageTransparency = mapped2,
						[Roact.Ref] = data.caretRef
					})
				}
			),
			Content = Roact.createElement("TextButton", {
				AutoButtonColor = false,
				Text = "",
				Selectable = false,
				Size = UDim2.fromOffset(v5, v7),
				BackgroundColor3 = theme.BackgroundMuted.Color,
				BackgroundTransparency = mapped2,
				BorderSizePixel = 0,
				LayoutOrder = positionInfo.contentLayoutOrder
			}, {
				VerticalLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 4),
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 12),
					PaddingBottom = UDim.new(0, 12),
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12)
				}),
				Header = data.props.headerText and Roact.createElement(GenericTextLabel, {
					colorStyle = theme.TextEmphasis,
					fontStyle = captionHeader,
					LayoutOrder = 1,
					Text = data.props.headerText,
					TextTransparency = mapped3,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(1, 0, 0, v6)
				}),
				Body = Roact.createElement(GenericTextLabel, {
					colorStyle = theme.TextDefault,
					fontStyle = captionBody,
					LayoutOrder = 2,
					Text = data.props.bodyText,
					TextTransparency = mapped3,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(1, 0, 0, textHeight)
				})
			})
		})
	end)
end

function extended.didMount(p)
	p.progressMotor:start()
end

function extended:didUpdate(p, _)
	if p.triggerPosition ~= self.props.triggerPosition then
		if
			self.props.triggerPosition.Y < 0
			or self.props.triggerPosition.Y + self.props.triggerSize.Y > self.props.screenSize.Y
		then
			self.visible = false
		else
			self.visible = true
		end
	end
end

function extended:willUnmount()
	self.progressMotor:destroy()
	self.progressMotor = nil
end

return extended
