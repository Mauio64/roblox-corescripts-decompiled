local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local core = parent2.Core
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local t = require(parent3.t)
local Cryo = require(parent3.Cryo)

local Images = require(parent.ImageSet.Images)
local ImageSetComponent = require(core.ImageSet.ImageSetComponent)
local Controllable = require(core.Control.Controllable)
local GenericTextLabel = require(core.Text.GenericTextLabel.GenericTextLabel)
local withStyle = require(parent2.Core.Style.withStyle)
local CloseButtonIcon = require(script.Parent.Enum.CloseButtonIcon)

local extended = Roact.PureComponent:extend("ModalTitle")

extended.validateProps = t.strictInterface({
	title = t.string,
	position = t.optional(t.UDim2),
	anchor = t.optional(t.Vector2),
	closeButtonIcon = t.optional(CloseButtonIcon.isEnumValue),
	onCloseClicked = t.optional(t.callback),
	titleBackgroundImageProps = t.optional(t.strictInterface({
		image = t.string,
		imageHeight = t.number,
		text = t.optional(t.string)
	})),
	onTitleSizeChanged = t.optional(t.callback)
})

extended.defaultProps = {
	title = "",
	position = UDim2.new(0.5, 0, 0, 0),
	anchor = Vector2.new(0.5, 0),
	closeButtonIcon = CloseButtonIcon.Close
}

function extended.GetHeight(_): number
	return 48
end

local function getCloseButtonIcon(closeButtonIcon): nil | string -- 1 equivalent call inferred from this helper
	if closeButtonIcon == CloseButtonIcon.Close then
		return "icons/navigation/close"
	end

	if closeButtonIcon == CloseButtonIcon.Back then
		return "icons/actions/cycleLeft"
	end

	return nil
end

local function renderBackgroundImage(props, p, p2)
	local text = props.text

	local v = text and #text > 0
	local v2 = text and #text > 0

	local v3 = math.clamp(props.imageHeight, 48, 261)

	if v then
		v3 += 8
		p2 = Cryo.Dictionary.join(p2, {
			UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) })
		})
	end

	if text and #text > 0 then
		p2 = Cryo.Dictionary.join(p2, {
			BackgroundText = Roact.createElement(GenericTextLabel, {
				Size = UDim2.new(1, 0, 1, -56),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 48),
				fontStyle = p.Font.Body,
				colorStyle = p.Theme.TextEmphasis,
				RichText = true,
				Text = text,
				TextTruncate = Enum.TextTruncate.AtEnd,
				ZIndex = 2
			})
		})
	end

	if v2 then
		p2 = Cryo.Dictionary.join(p2, {
			BackgroundTextShadow = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, v and -8 or 0),
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 0,
				ZIndex = 1
			}, {
				UIGradient = Roact.createElement("UIGradient", {
					Color = ColorSequence.new(Color3.new(0, 0, 0)),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.6, 0.25),
						NumberSequenceKeypoint.new(1, 1)
					}),
					Rotation = 90
				})
			})
		})
	end

	local backgroundImage = Roact.createElement(ImageSetComponent.Label, {
		AnchorPoint = Vector2.new(0, 0),
		Size = UDim2.new(1, 0, 0, v3),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		ScaleType = Enum.ScaleType.Crop,
		BorderSizePixel = 0,
		Image = props.image,
		ImageColor3 = Color3.fromRGB(255, 255, 255)
	}, p2)

	if v then
		backgroundImage = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 0, 0, v3 - 8),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundTransparency = 1,
			ClipsDescendants = true
		}, { TitleBackground = backgroundImage })
	end

	return backgroundImage
end

function extended.render(p)
	local titleBackgroundImageProps = p.props.titleBackgroundImageProps

	return withStyle(function(p2)
		local font = p2.Font
		local theme = p2.Theme

		local textSize = font.BaseSize * font.Header1.RelativeSize

		local createElement = Roact.createElement
		local onTitleSizeChangedsByAbsoluteSize = {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 48),
			BackgroundTransparency = 1,
			[Roact.Change.AbsoluteSize] = p.props.onTitleSizeChanged
		}
		local closeButton

		if p.props.onCloseClicked then
			local createElement2 = Roact.createElement
			local controlComponent = {
				component = ImageSetComponent.Button,
				props = 0,
				children = 0
			}
			local onCloseClickedsByActivated = {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0, 32, 0.5, 0),
				Size = UDim2.new(0, 48, 0, 48),
				[Roact.Event.Activated] = p.props.onCloseClicked
			}
			controlComponent.props = onCloseClickedsByActivated
			controlComponent.children = {
				InputFillImage = Roact.createElement(ImageSetComponent.Label, {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 36, 0, 36),
					Image = Images[getCloseButtonIcon(p.props.closeButtonIcon)], -- inferred equivalent call
					ImageColor3 = theme.IconEmphasis.Color,
					ImageTransparency = theme.IconEmphasis.Transparency,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0)
				})
			}
			closeButton = createElement2(Controllable, {
				controlComponent = controlComponent,
				onStateChanged = function(...) end
			}) or nil
		end

		local element = createElement("Frame", onTitleSizeChangedsByAbsoluteSize, {
			CloseButton = closeButton,
			Title = Roact.createElement(GenericTextLabel, {
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, -104, 1, 0),
				colorStyle = theme.TextEmphasis,
				fontStyle = font.Header1,
				LayoutOrder = 1,
				Text = p.props.title,
				TextSize = textSize,
				TextWrapped = true,
				TextTruncate = Enum.TextTruncate.AtEnd
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 8),
					PaddingBottom = UDim.new(0, 8)
				})
			}),
			Underline = not titleBackgroundImageProps and Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = theme.Divider.Color,
				BackgroundTransparency = theme.Divider.Transparency,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 1)
			})
		})

		if titleBackgroundImageProps then
			return renderBackgroundImage(titleBackgroundImageProps, p2, { TitleText = element })
		end

		return element
	end)
end

return extended
