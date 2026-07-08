local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent.Parent
local InputLabel = require(script.Parent.InputLabel)
local SliderWithInput = require(ParentParent.Components.SliderWithInput)
local v9 = Roact.PureComponent:extend("SliderEntry")

v9.validateProps = t.strictInterface({
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

function v9.init(p1) -- line: 29
	p1.state = {
		isFrameSelectable = true
	}
end
function v9.render(p2) -- line: 35
	-- upvalues: Roact (copy), GuiService (copy), InputLabel (copy), SliderWithInput (copy)
	local v12 = p2.props.buttonRef or Roact.createRef()

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 92),
		LayoutOrder = p2.props.LayoutOrder,
		Selectable = p2.state.isFrameSelectable,
		[Roact.Event.SelectionGained] = function() -- line: 45
			-- upvalues: GuiService (copy), v12 (copy), p2 (copy)
			GuiService.SelectedCoreObject = v12:getValue()
			p2:setState({
				isFrameSelectable = false
			})
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
			localizationKey = p2.props.labelKey,
			Position = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0)
		}),
		Slider = Roact.createElement(SliderWithInput, {
			min = p2.props.min,
			max = p2.props.max,
			stepInterval = p2.props.stepInterval,
			keyboardInputStepInterval = p2.props.keyboardInputStepInterval,
			value = p2.props.value,
			Position = UDim2.new(0, 0, 0, 32),
			disabled = p2.props.disabled,
			valueChanged = p2.props.valueChanged,
			canCaptureFocus = p2.props.canCaptureFocus,
			isMenuOpen = p2.props.isMenuOpen,
			sliderDotRef = v12,
			onSelectionLost = function() -- line: 81
				-- upvalues: p2 (copy)
				p2:setState({
					isFrameSelectable = true
				})
			end,
			onSelectionGained = function() -- line: 86
				-- upvalues: p2 (copy)
				p2:setState({
					isFrameSelectable = false
				})
			end
		})
	})
end

return v9
