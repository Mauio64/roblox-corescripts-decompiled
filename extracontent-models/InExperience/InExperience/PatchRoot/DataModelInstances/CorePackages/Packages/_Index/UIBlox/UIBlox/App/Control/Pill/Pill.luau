local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Core = ParentParentParent.Core
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local Foundation = require(ParentParentParentParent.Foundation)
local IconSize = require(ParentParent.ImageSet.Enum.IconSize)
local getIconSize = require(ParentParent.ImageSet.getIconSize)
local withStyle = require(Core.Style.withStyle)
local validateImageSetData = require(Core.ImageSet.Validator.validateImageSetData)
local ControlState = require(Core.Control.Enum.ControlState)
local Interactable = require(Core.Control.Interactable)
local getContentStyle = require(Core.Button.getContentStyle)
local GenericTextLabel = require(Core.Text.GenericTextLabel.GenericTextLabel)
local ImageSetComponent = require(ParentParentParent.Core.ImageSet.ImageSetComponent)
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local GetTextSize = require(ParentParentParent.Core.Text.GetTextSize)
local v20 = Roact.PureComponent:extend("Pill")

v20.validateProps = t.strictInterface({
	text = t.optional(t.string),
	isSelected = t.optional(t.boolean),
	isDisabled = t.optional(t.boolean),
	isLoading = t.optional(t.boolean),
	icon = t.union(t.string, validateImageSetData),
	onActivated = t.callback
})
v20.defaultProps = {
	text = "",
	isSelected = false,
	isDisabled = false,
	isLoading = false
}

function v20.init(p1) -- line: 55
	-- upvalues: ControlState (copy)
	p1.state = {
		controlState = ControlState.Initialize
	}
end
function v20.render(p2) -- line: 61
	-- upvalues: withStyle (copy), ControlState (copy), getContentStyle (copy), getIconSize (copy), IconSize (copy), GetTextSize (copy), Roact (copy), Interactable (copy), ImageSetComponent (copy), GenericTextLabel (copy), Skeleton (copy), EnumsRadius (copy)
	return withStyle(function(p3) -- line: 62
		-- upvalues: p2 (copy), ControlState (copy), getContentStyle (copy), getIconSize (copy), IconSize (copy), GetTextSize (copy), Roact (copy), Interactable (copy), ImageSetComponent (copy), GenericTextLabel (copy), Skeleton (copy), EnumsRadius (copy)
		local p3Font = p3.Font
		local isSelected = p2.props.isSelected
		local isDisabled = p2.props.isDisabled
		local isLoading = p2.props.isLoading
		local icon = p2.props.icon
		local text = p2.props.text
		local onActivated = p2.props.onActivated
		local t1 = {
			[ControlState.Default] = not isSelected and "IconDefault" or "SystemPrimaryContent",
			[ControlState.Hover] = not isSelected and "IconEmphasis" or "SystemPrimaryContent"
		}
		local t2 = {
			[ControlState.Default] = not isSelected and "TextDefault" or "SystemPrimaryContent",
			[ControlState.Hover] = not isSelected and "TextEmphasis" or "SystemPrimaryContent"
		}
		local t3 = {
			[ControlState.Default] = not isSelected and "BackgroundUIDefault" or "SystemPrimaryDefault",
			[ControlState.Hover] = not isSelected and "BackgroundUIDefault" or "SystemPrimaryOnHover"
		}
		local v34 = getContentStyle(t1, p2.state.controlState, p3)
		local v35 = getContentStyle(t2, p2.state.controlState, p3)
		local v36 = getContentStyle(t3, p2.state.controlState, p3)
		local v37 = getIconSize(IconSize.Small)
		local BaseSize = p3Font.BaseSize
		local v39 = p3Font.CaptionHeader.RelativeSize * BaseSize
		local X = GetTextSize(text, v39, p3Font.CaptionHeader.Font, Vector2.new(10000, 10000)).X
		local v41 = X + 24
		local v42 = 240 - (28 + v37)

		return not isLoading and Roact.createElement(Interactable, {
			Size = UDim2.new(0, v41 + 4 + v37, 0, 28),
			BackgroundColor3 = v36.Color,
			BackgroundTransparency = v36.Transparency,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			isDisabled = isDisabled,
			[Roact.Event.Activated] = not isLoading and onActivated or nil,
			onStateChanged = function(_, p5) -- line: 106
				-- upvalues: p2 (copy)
				p2:setState({
					controlState = p5
				})
			end
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 0),
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			Content = Roact.createElement("Frame", {
				ClipsDescendants = true,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, X + 4 + v37, 1, 0)
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					Padding = UDim.new(0, 4),
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				Icon = Roact.createElement(ImageSetComponent.Label, {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.fromOffset(v37, v37),
					Image = icon,
					ImageColor3 = v34.Color,
					ImageTransparency = v34.Transparency
				}),
				TextArea = string.len(text) > 0 and Roact.createElement("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(X, v39)
				}, {
					PillText = Roact.createElement(GenericTextLabel, {
						Text = text,
						BackgroundTransparency = 1,
						fontStyle = p3Font.CaptionHeader,
						colorStyle = v35,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Size = UDim2.fromOffset(v42, v39),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						[Roact.Ref] = p2.PillText
					}),
					Roact.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(v42, 28)
					})
				}),
				UISizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(216, 28)
				})
			}),
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}),
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(240, 28)
			})
		}) or Roact.createElement(Skeleton, {
			Size = UDim2.fromOffset(v41 + 4 + v37, 28),
			radius = EnumsRadius.Circle
		})
	end)
end

return v20
