local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local Cryo = require(ParentParentParentParent.Cryo)
local t = require(ParentParentParentParent.t)
local RoactGamepad = require(ParentParentParentParent.RoactGamepad)
local GenericTextLabel = require(ParentParentParent.Core.Text.GenericTextLabel.GenericTextLabel)
local ImageSetComponent = require(ParentParentParent.Core.ImageSet.ImageSetComponent)
local validateImage = require(ParentParentParent.Core.ImageSet.Validator.validateImage)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local getPageMargin = require(ParentParent.Container.getPageMargin)
local IconSize = require(ParentParent.ImageSet.Enum.IconSize)
local getIconSize = require(ParentParent.ImageSet.getIconSize)
local Images = require(ParentParent.ImageSet.Images)
local Button = require(ParentParent.Button.Button)
local ButtonType = require(ParentParent.Button.Enum.ButtonType)
local v18 = Roact.PureComponent:extend("EmptyState")

v18.validateProps = t.strictInterface({
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
	titleProps = t.optional(t.strictInterface({
		titleText = t.optional(t.string)
	}))
})
v18.defaultProps = {
	icon = Images["icons/status/oof_xlarge"],
	size = UDim2.fromScale(1, 1),
	position = UDim2.fromScale(0.5, 0.5),
	anchorPoint = Vector2.new(0.5, 0.5),
	buttonIcon = Images["icons/common/refresh"],
	buttonType = ButtonType.Secondary,
	iconSize = UDim2.fromOffset(getIconSize(IconSize.XLarge), getIconSize(IconSize.XLarge))
}

local function getCorrectedIconValue(p1) -- line: 73
	if p1 == "" then
		return nil
	end

	return p1
end

function v18.init(p2) -- line: 77
	-- upvalues: Roact (copy)
	p2:setState({
		absoluteSize = Vector2.new(0, 0)
	})

	function p2.onAbsoluteSizeChange(p3) -- line: 81
		-- upvalues: p2 (copy)
		p2:setState({
			absoluteSize = p3.AbsoluteSize
		})
	end

	p2.buttonRef = Roact.createRef()
end
function v18.render(p4) -- line: 90
	-- upvalues: withStyle (copy), Roact (copy), RoactGamepad (copy), ImageSetComponent (copy), GenericTextLabel (copy), getPageMargin (copy), Button (copy)
	return withStyle(function(p5) -- line: 91
		-- upvalues: Roact (copy), RoactGamepad (copy), p4 (copy), ImageSetComponent (copy), GenericTextLabel (copy), getPageMargin (copy), Button (copy)
		local createElement = Roact.createElement
		local Frame = RoactGamepad.Focusable.Frame
		local t1 = {
			[Roact.Change.AbsoluteSize] = p4.onAbsoluteSizeChange,
			Size = p4.props.size,
			Position = p4.props.position,
			AnchorPoint = p4.props.anchorPoint,
			BackgroundTransparency = 1,
			[Roact.Ref] = p4.props.frameRef,
			NextSelectionUp = p4.props.NextSelectionUp,
			NextSelectionDown = p4.props.NextSelectionDown,
			NextSelectionULeft = p4.props.NextSelectionLeft,
			NextSelectionRight = p4.props.NextSelectionRight,
			defaultChild = p4.buttonRef
		}
		local t2 = {}
		local createElement2 = Roact.createElement
		local t3 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 187),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}
		local t4 = {
			UIListLayout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Icon = Roact.createElement(ImageSetComponent.Label, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0),
				Size = p4.props.iconSize,
				Image = p4.props.icon,
				ImageColor3 = p4.props.iconColor or p5.Theme.IconEmphasis.Color,
				ImageTransparency = p5.Theme.IconEmphasis.Transparency
			}),
			iconTextPadding = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(0, 12)
			}),
			TitleFrame = if not p4.props.titleProps or not p4.props.titleProps.titleText then nil else Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 3,
				Size = UDim2.fromScale(1, 0),
				Position = UDim2.fromScale(0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				TitlePadding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 14),
					PaddingBottom = UDim.new(0, 14)
				}),
				TitleText = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextWrapped = true,
					LayoutOrder = 1,
					Text = p4.props.titleProps.titleText,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					Font = p5.Font.Title.Font,
					TextSize = p5.Font.Header1.RelativeSize * p5.Font.BaseSize,
					TextColor3 = p5.Theme.TextEmphasis.Color,
					TextTransparency = p5.Theme.TextEmphasis.Transparency,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.fromScale(1, 0)
				})
			}),
			Text = Roact.createElement(GenericTextLabel, {
				LayoutOrder = 4,
				Text = p4.props.text,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				fontStyle = p5.Font.Body,
				colorStyle = p5.Theme.TextDefault,
				maxSize = p4.props.maxSizeTextLabel
			}),
			textButtonPadding = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 5,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(0, 24)
			})
		}
		local onActivated = p4.props.onActivated

		if onActivated then
			local createElement3 = Roact.createElement
			local t5 = {
				BackgroundTransparency = 1,
				LayoutOrder = 6,
				Size = UDim2.new(1, 0, 0, 48),
				AnchorPoint = Vector2.new(0.5, 0)
			}
			local t6 = {
				UIPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, getPageMargin(p4.state.absoluteSize.X)),
					PaddingRight = UDim.new(0, getPageMargin(p4.state.absoluteSize.X))
				}),
				UISizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(640, 48)
				})
			}
			local createElement4 = Roact.createElement
			local v39 = Button
			local t7 = {
				buttonType = p4.props.buttonType,
				size = UDim2.fromScale(1, 1),
				position = UDim2.fromScale(0.5, 0.5),
				anchorPoint = Vector2.new(0.5, 0.5),
				onActivated = p4.props.onActivated
			}
			local buttonIcon = p4.props.buttonIcon

			t7.icon = if buttonIcon ~= "" then buttonIcon else nil
			t7.text = p4.props.buttonText
			t7[Roact.Ref] = p4.buttonRef
			t6.Button = createElement4(v39, t7)
			onActivated = createElement3("Frame", t5, t6)
		end

		t4.buttonFrame = onActivated
		t2.Content = createElement2("Frame", t3, t4)

		return createElement(Frame, t1, t2)
	end)
end

return Roact.forwardRef(function(p6, p7) -- line: 203
	-- upvalues: Roact (copy), v18 (copy), Cryo (copy)
	return Roact.createElement(v18, Cryo.Dictionary.join(p6, {
		frameRef = p7
	}))
end)
