local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local core = parent2.Core

local Roact = require(parent3.Roact)
local t = require(parent3.t)
local Foundation = require(parent3.Foundation)

local IconSize = require(parent.ImageSet.Enum.IconSize)
local getIconSize = require(parent.ImageSet.getIconSize)
local withStyle = require(core.Style.withStyle)
local validateImageSetData = require(core.ImageSet.Validator.validateImageSetData)
local ControlState = require(core.Control.Enum.ControlState)
local Interactable = require(core.Control.Interactable)
local getContentStyle = require(core.Button.getContentStyle)

local GenericTextLabel = require(core.Text.GenericTextLabel.GenericTextLabel)
local ImageSetComponent = require(parent2.Core.ImageSet.ImageSetComponent)
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius
local GetTextSize = require(parent2.Core.Text.GetTextSize)
local GetFontFromFontStyle = require(parent2.Core.Text.GetFontFromFontStyle)

local extended = Roact.PureComponent:extend("Pill")

extended.validateProps = t.strictInterface({
	text = t.optional(t.string),
	isSelected = t.optional(t.boolean),
	isDisabled = t.optional(t.boolean),
	isLoading = t.optional(t.boolean),
	icon = t.union(t.string, validateImageSetData),
	onActivated = t.callback
})

extended.defaultProps = { text = "", isSelected = false, isDisabled = false, isLoading = false }

function extended:init()
	self.state = { controlState = ControlState.Initialize }
end

function extended.render(object)
	return withStyle(function(p)
		local font = p.Font

		local isSelected = object.props.isSelected
		local isDisabled = object.props.isDisabled
		local isLoading = object.props.isLoading
		local icon = object.props.icon
		local text = object.props.text
		local onActivated = object.props.onActivated

		local v = {
			[ControlState.Default] = isSelected and "SystemPrimaryContent" or "IconDefault",
			[ControlState.Hover] = isSelected and "SystemPrimaryContent" or "IconEmphasis"
		}

		local v2 = {
			[ControlState.Default] = isSelected and "SystemPrimaryContent" or "TextDefault",
			[ControlState.Hover] = isSelected and "SystemPrimaryContent" or "TextEmphasis"
		}

		local v3 = {
			[ControlState.Default] = isSelected and "SystemPrimaryDefault" or "BackgroundUIDefault",
			[ControlState.Hover] = isSelected and "SystemPrimaryOnHover" or "BackgroundUIDefault"
		}

		local contentStyle = getContentStyle(v, object.state.controlState, p)
		local contentStyle2 = getContentStyle(v2, object.state.controlState, p)
		local contentStyle3 = getContentStyle(v3, object.state.controlState, p)

		local iconSize = getIconSize(IconSize.Small)
		local baseSize = font.BaseSize
		local v4 = font.CaptionHeader.RelativeSize * baseSize

		local x = GetTextSize(text, v4, GetFontFromFontStyle(font.CaptionHeader), Vector2.new(10000, 10000)).X

		local v5 = x + 24
		local v6 = 240 - (28 + iconSize)

		if isLoading then
			return (Roact.createElement(Skeleton, {
				Size = UDim2.fromOffset(v5 + 4 + iconSize, 28),
				radius = Radius.Circle
			}))
		else
			local createElement = Roact.createElement
			local onActivatedsByActivated = {
				["Size"] = nil,
				["Size"] = nil,
				Size = UDim2.new(0, v5 + 4 + iconSize, 0, 28),
				BackgroundColor3 = contentStyle3.Color,
				BackgroundTransparency = contentStyle3.Transparency,
				AutoButtonColor = false,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				isDisabled = isDisabled
			}

			local activated = Roact.Event.Activated

			if isLoading or not onActivated then
				onActivated = nil
			end

			onActivatedsByActivated[activated] = onActivated
			function onActivatedsByActivated.onStateChanged(_, controlState)
				object:setState({ controlState = controlState })
			end
			local children = {
				UIListLayout = Roact.createElement("UIListLayout", {
					Padding = UDim.new(0, 0),
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				Content = 0,
				UICorner = 0,
				UISizeConstraint = 0
			}

			local createElement2 = Roact.createElement
			local v7 = {
				Size = UDim2.new(0, x + 4 + iconSize, 1, 0),
				ClipsDescendants = true,
				BackgroundTransparency = 1
			}

			local v8 = {
				UIListLayout = Roact.createElement("UIListLayout", {
					Padding = UDim.new(0, 4),
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				Icon = Roact.createElement(ImageSetComponent.Label, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.fromOffset(iconSize, iconSize),
					BackgroundTransparency = 1,
					Image = icon,
					ImageColor3 = contentStyle.Color,
					ImageTransparency = contentStyle.Transparency
				}),
				TextArea = 0,
				UISizeConstraint = 0
			}
			local textArea

			if string.len(text) > 0 then
				textArea = Roact.createElement(
					"Frame",
					{ Size = UDim2.fromOffset(x, v4), LayoutOrder = 2, BackgroundTransparency = 1 },
					{
						PillText = Roact.createElement(GenericTextLabel, {
							Text = text,
							BackgroundTransparency = 1,
							fontStyle = font.CaptionHeader,
							colorStyle = contentStyle2,
							TextTruncate = Enum.TextTruncate.AtEnd,
							Size = UDim2.fromOffset(v6, v4),
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center,
							[Roact.Ref] = object.PillText
						}),
						Roact.createElement("UISizeConstraint", { MaxSize = Vector2.new(v6, 28) })
					}
				)
			else
				textArea = false
			end

			v8.TextArea = textArea

			v8.UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(216, 28)
			})
			children.Content = createElement2("Frame", v7, v8)

			children.UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })

			children.UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(240, 28)
			})
			return createElement(Interactable, onActivatedsByActivated, children) or Roact.createElement(Skeleton, {
				Size = UDim2.fromOffset(v5 + 4 + iconSize, 28),
				radius = Radius.Circle
			})
		end
	end)
end

return extended
