local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent.Parent

local InputLabel = require(script.Parent.InputLabel)
local SliderWithInput = require(parent.Components.SliderWithInput)

local extended = Roact.PureComponent:extend("SliderEntry")
extended.validateProps = t.strictInterface({
	LayoutOrder = t.integer,
	labelKey = t.string,
	min = t.number,
	max = t.number,
	stepInterval = t.number,
	keyboardInputStepInterval = t.optional(t.numberPositive),
	value = t.number,
	disabled = t.optional(t.boolean),
	valueChanged = t.callback,
	canCaptureFocus = t.optional(t.boolean),
	isMenuOpen = t.optional(t.boolean),
	buttonRef = t.optional(t.table)
})

function extended:init()
	self.state = { isFrameSelectable = true }
end

function extended.render(object)
	local buttonRef = object.props.buttonRef or Roact.createRef()
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 92),
		LayoutOrder = object.props.LayoutOrder,
		Selectable = object.state.isFrameSelectable,
		[Roact.Event.SelectionGained] = function()
			GuiService.SelectedCoreObject = buttonRef:getValue()
			object:setState({ isFrameSelectable = false })
		end
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 24),
			PaddingTop = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 30),
			PaddingBottom = UDim.new(0, 24)
		}),
		Label = Roact.createElement(InputLabel, {
			Size = UDim2.new(1, 0, 0, 24),
			localizationKey = object.props.labelKey,
			Position = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0)
		}),
		Slider = Roact.createElement(SliderWithInput, {
			min = object.props.min,
			max = object.props.max,
			stepInterval = object.props.stepInterval,
			keyboardInputStepInterval = object.props.keyboardInputStepInterval,
			value = object.props.value,
			Position = UDim2.new(0, 0, 0, 32),
			disabled = object.props.disabled,
			valueChanged = object.props.valueChanged,
			canCaptureFocus = object.props.canCaptureFocus,
			isMenuOpen = object.props.isMenuOpen,
			sliderDotRef = buttonRef,
			onSelectionLost = function()
				object:setState({ isFrameSelectable = true })
			end,
			onSelectionGained = function()
				object:setState({ isFrameSelectable = false })
			end
		})
	})
end

return extended
