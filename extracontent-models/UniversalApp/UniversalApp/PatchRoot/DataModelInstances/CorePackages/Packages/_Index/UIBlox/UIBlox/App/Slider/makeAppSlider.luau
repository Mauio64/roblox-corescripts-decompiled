local parent = script.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local Otter = require(parent3.Otter)

local Colors = require(parent.Style.Colors)
local GenericSlider = require(parent2.Core.Slider.GenericSlider)
local Images = require(parent.ImageSet.Images)

local v = { frequency = 5 }

local divideTransparency = require(parent2.Utility.divideTransparency)
local lerp = require(parent2.Utility.lerp)

local function makeAppSlider(p, p2)
	local appSlider = Roact.PureComponent:extend("AppSliderFor" .. p)

	appSlider.defaultProps = {
		textInputEnabled = false,
		stepInterval = 1,
		width = UDim.new(1, 0),
		customPressedKnobShadowTransparencyLower = 1
	}

	function appSlider:init()
		local binding, v2 = Roact.createBinding(0)
		self.pressedProgressLower = binding
		local binding2, v3 = Roact.createBinding(0)
		self.pressedProgressUpper = binding2
		local binding3, setDisabled = Roact.createBinding(self.props.isDisabled)
		self.disabled = binding3
		self.setDisabled = setDisabled
		local binding4, setStyle = Roact.createBinding(self.props.style)
		self.style = binding4
		self.setStyle = setStyle

		self.wasUnmounted = false

		local joinBindings = Roact.joinBindings({
			disabled = self.disabled,
			pressedProgressLower = self.pressedProgressLower,
			pressedProgressUpper = self.pressedProgressUpper,
			style = self.style
		})

		self.trackColor = joinBindings:map(function(p3)
			return p3.style.Theme.UIMuted.Color
		end)

		self.trackTransparency = joinBindings:map(function(p3)
			return divideTransparency(p3.style.Theme.UIMuted.Transparency, p3.disabled and 2 or 1)
		end)

		self.trackFillColor = joinBindings:map(function(p3)
			return p3.style.Theme[p].Color
		end)

		self.trackFillTransparency = joinBindings:map(function(p3)
			return divideTransparency(p3.style.Theme[p].Transparency, p3.disabled and 2 or 1)
		end)

		self.knobColorLower = joinBindings:map(function(data)
			if data.disabled then
				return Colors.Pumice
			end

			local color = Color3.new(1, 1, 1)

			local v4 = Colors.Pumice

			if p ~= "SystemPrimaryDefault" then
				v4 = data.style.Theme[p].Color
			end

			return color:lerp(v4, data.pressedProgressLower)
		end)

		self.knobColorUpper = joinBindings:map(function(data)
			if data.disabled then
				return Colors.Pumice
			end

			local color = Color3.new(1, 1, 1)

			local v4 = Colors.Pumice

			if p ~= "SystemPrimaryDefault" then
				v4 = data.style.Theme[p].Color
			end

			return color:lerp(v4, data.pressedProgressUpper)
		end)

		self.knobTransparency = joinBindings:map(function(p3)
			return divideTransparency(p3.style.Theme[p].Transparency, p3.disabled and 2 or 1)
		end)

		self.knobShadowTransparencyLower = joinBindings:map(function(data)
			if data.disabled then
				return 1
			end

			local customPressedKnobShadowTransparencyLower = self.props.customPressedKnobShadowTransparencyLower
			return lerp(
				data.style.Theme.DropShadow.Transparency,
				customPressedKnobShadowTransparencyLower,
				data.pressedProgressLower
			)
		end)

		self.knobShadowTransparencyUpper = joinBindings:map(function(data)
			if data.disabled then
				return 1
			end

			return lerp(data.style.Theme.DropShadow.Transparency, 1, data.pressedProgressUpper)
		end)

		self.pressedMotorLower = Otter.createSingleMotor(0)
		self.pressedMotorLower:onStep(v2)

		self.pressedMotorUpper = Otter.createSingleMotor(0)
		self.pressedMotorUpper:onStep(v3)

		function self.onDragStartLower()
			if self.props.onDragStartLower then
				self.props.onDragStartLower()
			end

			if not self.wasUnmounted then
				self.pressedMotorLower:setGoal(Otter.spring(1, v))
			end
		end

		function self.onDragStartUpper()
			if self.props.onDragStartUpper then
				self.props.onDragStartUpper()
			end

			if not self.wasUnmounted then
				self.pressedMotorUpper:setGoal(Otter.spring(1, v))
			end
		end

		function self.onDragEnd()
			if self.props.onDragEnd then
				self.props.onDragEnd()
			end

			if not self.wasUnmounted then
				self.pressedMotorLower:setGoal(Otter.spring(0, v))
				self.pressedMotorUpper:setGoal(Otter.spring(0, v))
			end
		end
	end

	function appSlider.render(props)
		local props2 = props.props

		local customKnobColorLower = props2.customKnobColorLower or props.knobColorLower

		local forwardedRefsByRef = {
			min = props2.min,
			max = props2.max,
			stepInterval = props2.stepInterval,
			isDisabled = props2.isDisabled,
			width = props2.width,
			position = props2.position,
			anchorPoint = props2.anchorPoint,
			layoutOrder = props2.layoutOrder,
			onValueChanged = props2.onValueChanged,
			onDragStartLower = props.onDragStartLower,
			onDragStartUpper = props.onDragStartUpper,
			onDragEnd = props.onDragEnd,
			trackImage = Images["component_assets/circle_16"],
			trackColor = props.trackColor,
			trackTransparency = props.trackTransparency,
			trackSliceCenter = Rect.new(8, 8, 8, 8),
			trackFillImage = Images["component_assets/circle_16"],
			trackFillColor = props.trackFillColor,
			trackFillTransparency = props.trackFillTransparency,
			trackFillSliceCenter = Rect.new(8, 8, 8, 8),
			knobImage = Images["component_assets/circle_28_padding_10"],
			knobColorLower = customKnobColorLower,
			knobColorUpper = props.knobColorUpper,
			knobTransparency = props.knobTransparency,
			knobImagePadding = 10,
			knobShadowImage = Images["component_assets/dropshadow_28"],
			knobShadowTransparencyLower = props.knobShadowTransparencyLower,
			knobShadowTransparencyUpper = props.knobShadowTransparencyUpper,
			[Roact.Ref] = props2.forwardedRef,
			NextSelectionUp = props2.NextSelectionUp,
			NextSelectionDown = props2.NextSelectionDown,
			focusController = props2.focusController,
			customTrack = props2.customTrack,
			customKnobHeight = props2.customKnobHeight,
			customKnobBorderSize = props2.customKnobBorderSize,
			customKnobBorderColor = props2.customKnobBorderColor,
			containerRef = props2.containerRef
		}

		if p2 then
			forwardedRefsByRef.upperValue = props2.upperValue
			forwardedRefsByRef.lowerValue = props2.lowerValue
		else
			forwardedRefsByRef.lowerValue = props2.value
		end

		return Roact.createElement(GenericSlider, forwardedRefsByRef)
	end

	function appSlider.didMount(p3)
		p3.pressedMotorLower:start()
		p3.pressedMotorUpper:start()
	end

	function appSlider.didUpdate(data, p3)
		if p3.style ~= data.props.style then
			data.setStyle(data.props.style)
		end

		if p3.isDisabled ~= data.props.isDisabled then
			data.setDisabled(data.props.isDisabled)

			if data.props.isDisabled then
				data.pressedMotorLower:setGoal(Otter.spring(0, v))
				data.pressedMotorUpper:setGoal(Otter.spring(0, v))
			end
		end
	end

	function appSlider:willUnmount()
		self.wasUnmounted = true

		self.pressedMotorLower:destroy()
		self.pressedMotorUpper:destroy()
	end

	return appSlider
end

return makeAppSlider
