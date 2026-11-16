local parent = script.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local Foundation = require(parent3.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local Roact = require(parent3.Roact)
local Cryo = require(parent3.Cryo)
local t = require(parent3.t)
local RoactGamepad = require(parent3.RoactGamepad)

local GenericTextLabel = require(parent2.Core.Text.GenericTextLabel.GenericTextLabel)
local GetFontFromFontStyle = require(parent2.Core.Text.GetFontFromFontStyle)
local ImageSetComponent = require(parent2.Core.ImageSet.ImageSetComponent)
local validateImage = require(parent2.Core.ImageSet.Validator.validateImage)
local withStyle = require(parent2.Core.Style.withStyle)
local getPageMargin = require(parent.Container.getPageMargin)
local IconSize = require(parent.ImageSet.Enum.IconSize)
local getIconSize = require(parent.ImageSet.getIconSize)
local Images = require(parent.ImageSet.Images)

local Button = require(parent.Button.Button)
local ButtonType = require(parent.Button.Enum.ButtonType)

local extended = Roact.PureComponent:extend("EmptyState")

extended.validateProps = t.strictInterface({
	text = t.string,
	icon = t.optional(validateImage),
	size = t.optional(t.UDim2),
	position = t.optional(t.UDim2),
	anchorPoint = t.optional(t.Vector2),
	buttonIcon = t.optional(validateImage),
	buttonText = t.optional(t.string),
	buttonType = t.optional(ButtonType.isEnumValue),
	onActivated = t.optional(t.callback),
	frameRef = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	maxSizeTextLabel = t.optional(t.Vector2),
	iconColor = t.optional(t.Color3),
	iconSize = t.optional(t.UDim2),
	titleProps = t.optional(t.strictInterface({ titleText = t.optional(t.string) }))
})

extended.defaultProps = {
	icon = Images["icons/status/oof_xlarge"],
	size = UDim2.fromScale(1, 1),
	position = UDim2.fromScale(0.5, 0.5),
	anchorPoint = Vector2.new(0.5, 0.5),
	buttonIcon = Images["icons/common/refresh"],
	buttonType = ButtonType.Secondary,
	iconSize = UDim2.fromOffset(getIconSize(IconSize.XLarge), getIconSize(IconSize.XLarge))
}

local function getCorrectedIconValue(buttonIcon) -- 1 equivalent call inferred from this helper
	return if buttonIcon ~= "" then buttonIcon else nil
end

function extended:init()
	self:setState({ absoluteSize = Vector2.new(0, 0) })

	function self.onAbsoluteSizeChange(p)
		self:setState({ absoluteSize = p.AbsoluteSize })
	end

	self.buttonRef = Roact.createRef()
end

function extended.render(data)
	return withStyle(function(p)
		local createElement = Roact.createElement
		local frame = RoactGamepad.Focusable.Frame
		local v = {
			[Roact.Change.AbsoluteSize] = data.onAbsoluteSizeChange,
			Size = data.props.size,
			Position = data.props.position,
			AnchorPoint = data.props.anchorPoint,
			BackgroundTransparency = 1,
			[Roact.Ref] = data.props.frameRef,
			NextSelectionUp = data.props.NextSelectionUp,
			NextSelectionDown = data.props.NextSelectionDown,
			NextSelectionULeft = data.props.NextSelectionLeft,
			NextSelectionRight = data.props.NextSelectionRight,
			defaultChild = data.buttonRef
		}

		local createElement2 = Roact.createElement
		local v2 = {
			Size = UDim2.new(1, 0, 0, 187),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1
		}

		local children = {
			UIListLayout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Icon = Roact.createElement(ImageSetComponent.Label, {
				AnchorPoint = Vector2.new(0.5, 0),
				Size = data.props.iconSize,
				LayoutOrder = 1,
				Image = data.props.icon,
				BackgroundTransparency = 1,
				ImageColor3 = data.props.iconColor or p.Theme.IconEmphasis.Color,
				ImageTransparency = p.Theme.IconEmphasis.Transparency
			}),
			iconTextPadding = Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(0, 12),
				BackgroundTransparency = 1,
				LayoutOrder = 2
			}),
			TitleFrame = 0,
			Text = 0,
			textButtonPadding = 0,
			buttonFrame = 0
		}
		local titleFrame

		if data.props.titleProps and data.props.titleProps.titleText then
			titleFrame = Roact.createElement("Frame", {
				Size = UDim2.fromScale(1, 0),
				Position = UDim2.fromScale(0, 0),
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				BorderSizePixel = 0,
				LayoutOrder = 3
			}, {
				TitlePadding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 14),
					PaddingBottom = UDim.new(0, 14)
				}),
				TitleText = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = data.props.titleProps.titleText,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					FontFace = normalizeFontFace(GetFontFromFontStyle(p.Font.Title)),
					TextSize = p.Font.Header1.RelativeSize * p.Font.BaseSize,
					TextColor3 = p.Theme.TextEmphasis.Color,
					TextTransparency = p.Theme.TextEmphasis.Transparency,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.fromScale(1, 0),
					TextWrapped = true,
					LayoutOrder = 1
				})
			})
		end

		children.TitleFrame = titleFrame

		children.Text = Roact.createElement(GenericTextLabel, {
			Text = data.props.text,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			LayoutOrder = 4,
			fontStyle = p.Font.Body,
			colorStyle = p.Theme.TextDefault,
			maxSize = data.props.maxSizeTextLabel
		})

		children.textButtonPadding = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(0, 24),
			BackgroundTransparency = 1,
			LayoutOrder = 5
		})

		local buttonFrame = data.props.onActivated

		if buttonFrame then
			buttonFrame = Roact.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, 48),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					LayoutOrder = 6
				},
				{
					UIPadding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, getPageMargin(data.state.absoluteSize.X)),
						PaddingRight = UDim.new(0, getPageMargin(data.state.absoluteSize.X))
					}),
					UISizeConstraint = Roact.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(640, 48)
					}),
					Button = Roact.createElement(Button, {
						buttonType = data.props.buttonType,
						size = UDim2.fromScale(1, 1),
						position = UDim2.fromScale(0.5, 0.5),
						anchorPoint = Vector2.new(0.5, 0.5),
						onActivated = data.props.onActivated,
						icon = getCorrectedIconValue(data.props.buttonIcon), -- inferred equivalent call
						text = data.props.buttonText,
						[Roact.Ref] = data.buttonRef
					})
				}
			)
		end

		children.buttonFrame = buttonFrame
		return createElement(frame, v, {
			Content = createElement2("Frame", v2, children)
		})
	end)
end

return Roact.forwardRef(function(p, frameRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { frameRef = frameRef }))
end)
