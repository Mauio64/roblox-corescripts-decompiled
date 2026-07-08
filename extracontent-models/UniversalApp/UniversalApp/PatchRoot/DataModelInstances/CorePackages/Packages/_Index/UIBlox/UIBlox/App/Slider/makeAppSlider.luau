local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local Otter = require(ParentParentParentParent.Otter)
local Colors = require(ParentParent.Style.Colors)
local GenericSlider = require(ParentParentParent.Core.Slider.GenericSlider)
local Images = require(ParentParent.ImageSet.Images)
local t1 = {
	frequency = 5
}
local divideTransparency = require(ParentParentParent.Utility.divideTransparency)
local lerp = require(ParentParentParent.Utility.lerp)

local function makeAppSlider(p1, p2) -- line: 21
	-- upvalues: Roact (copy), divideTransparency (copy), Colors (copy), lerp (copy), Otter (copy), t1 (copy), Images (copy), GenericSlider (copy)
	local v15 = Roact.PureComponent:extend("AppSliderFor" .. p1)

	v15.defaultProps = {
		textInputEnabled = false,
		stepInterval = 1,
		customPressedKnobShadowTransparencyLower = 1,
		width = UDim.new(1, 0)
	}

	function v15.init(p3) -- line: 32
		-- upvalues: Roact (copy), divideTransparency (copy), p1 (copy), Colors (copy), lerp (copy), Otter (copy), t1 (copy)
		local v17, v18 = Roact.createBinding(0)

		p3.pressedProgressLower = v17

		local v19, v20 = Roact.createBinding(0)

		p3.pressedProgressUpper = v19

		local v21, v22 = Roact.createBinding(p3.props.isDisabled)

		p3.disabled = v21
		p3.setDisabled = v22

		local v23, v24 = Roact.createBinding(p3.props.style)

		p3.style = v23
		p3.setStyle = v24
		p3.wasUnmounted = false

		local v25 = Roact.joinBindings({
			disabled = p3.disabled,
			pressedProgressLower = p3.pressedProgressLower,
			pressedProgressUpper = p3.pressedProgressUpper,
			style = p3.style
		})

		p3.trackColor = v25:map(function(p4) -- line: 48
			return p4.style.Theme.UIMuted.Color
		end)
		p3.trackTransparency = v25:map(function(p5) -- line: 52
			-- upvalues: divideTransparency (copy)
			return divideTransparency(p5.style.Theme.UIMuted.Transparency, not p5.disabled and 1 or 2)
		end)
		p3.trackFillColor = v25:map(function(p6) -- line: 56
			-- upvalues: p1 (copy)
			return p6.style.Theme[p1].Color
		end)
		p3.trackFillTransparency = v25:map(function(p7) -- line: 60
			-- upvalues: divideTransparency (copy), p1 (copy)
			return divideTransparency(p7.style.Theme[p1].Transparency, not p7.disabled and 1 or 2)
		end)
		p3.knobColorLower = v25:map(function(p8) -- line: 64
			-- upvalues: Colors (copy), p1 (copy)
			if p8.disabled then
				return Colors.Pumice
			end

			local color3 = Color3.new(1, 1, 1)
			local Pumice = Colors.Pumice

			if p1 ~= "SystemPrimaryDefault" then
				Pumice = p8.style.Theme[p1].Color
			end

			return color3:lerp(Pumice, p8.pressedProgressLower)
		end)
		p3.knobColorUpper = v25:map(function(p9) -- line: 79
			-- upvalues: Colors (copy), p1 (copy)
			if p9.disabled then
				return Colors.Pumice
			end

			local color3 = Color3.new(1, 1, 1)
			local Pumice = Colors.Pumice

			if p1 ~= "SystemPrimaryDefault" then
				Pumice = p9.style.Theme[p1].Color
			end

			return color3:lerp(Pumice, p9.pressedProgressUpper)
		end)
		p3.knobTransparency = v25:map(function(p10) -- line: 94
			-- upvalues: divideTransparency (copy), p1 (copy)
			return divideTransparency(p10.style.Theme[p1].Transparency, not p10.disabled and 1 or 2)
		end)
		p3.knobShadowTransparencyLower = v25:map(function(p11) -- line: 98
			-- upvalues: p3 (copy), lerp (copy)
			if p11.disabled then
				return 1
			end

			local customPressedKnobShadowTransparencyLower = p3.props.customPressedKnobShadowTransparencyLower

			return lerp(p11.style.Theme.DropShadow.Transparency, customPressedKnobShadowTransparencyLower, p11.pressedProgressLower)
		end)
		p3.knobShadowTransparencyUpper = v25:map(function(p12) -- line: 107
			-- upvalues: lerp (copy)
			if p12.disabled then
				return 1
			end

			return lerp(p12.style.Theme.DropShadow.Transparency, 1, p12.pressedProgressUpper)
		end)
		p3.pressedMotorLower = Otter.createSingleMotor(0)
		p3.pressedMotorLower:onStep(v18)
		p3.pressedMotorUpper = Otter.createSingleMotor(0)
		p3.pressedMotorUpper:onStep(v20)

		function p3.onDragStartLower() -- line: 121
			-- upvalues: p3 (copy), Otter (copy), t1 (copy)
			if p3.props.onDragStartLower then
				p3.props.onDragStartLower()
			end

			if not p3.wasUnmounted then
				p3.pressedMotorLower:setGoal(Otter.spring(1, t1))
			end
		end
		function p3.onDragStartUpper() -- line: 131
			-- upvalues: p3 (copy), Otter (copy), t1 (copy)
			if p3.props.onDragStartUpper then
				p3.props.onDragStartUpper()
			end

			if not p3.wasUnmounted then
				p3.pressedMotorUpper:setGoal(Otter.spring(1, t1))
			end
		end
		function p3.onDragEnd() -- line: 141
			-- upvalues: p3 (copy), Otter (copy), t1 (copy)
			if p3.props.onDragEnd then
				p3.props.onDragEnd()
			end

			if not p3.wasUnmounted then
				p3.pressedMotorLower:setGoal(Otter.spring(0, t1))
				p3.pressedMotorUpper:setGoal(Otter.spring(0, t1))
			end
		end
	end
	function v15.render(p13) -- line: 153
		-- upvalues: Images (copy), Roact (copy), p2 (copy), GenericSlider (copy)
		local props = p13.props
		local v28 = props.customKnobColorLower or p13.knobColorLower
		local t2 = {
			min = props.min,
			max = props.max,
			stepInterval = props.stepInterval,
			isDisabled = props.isDisabled,
			width = props.width,
			position = props.position,
			anchorPoint = props.anchorPoint,
			layoutOrder = props.layoutOrder,
			onValueChanged = props.onValueChanged,
			onDragStartLower = p13.onDragStartLower,
			onDragStartUpper = p13.onDragStartUpper,
			onDragEnd = p13.onDragEnd,
			trackImage = Images["component_assets/circle_16"],
			trackColor = p13.trackColor,
			trackTransparency = p13.trackTransparency,
			trackSliceCenter = Rect.new(8, 8, 8, 8),
			trackFillImage = Images["component_assets/circle_16"],
			trackFillColor = p13.trackFillColor,
			trackFillTransparency = p13.trackFillTransparency,
			trackFillSliceCenter = Rect.new(8, 8, 8, 8),
			knobImage = Images["component_assets/circle_28_padding_10"],
			knobColorLower = v28,
			knobColorUpper = p13.knobColorUpper,
			knobTransparency = p13.knobTransparency,
			knobImagePadding = 10,
			knobShadowImage = Images["component_assets/dropshadow_28"],
			knobShadowTransparencyLower = p13.knobShadowTransparencyLower,
			knobShadowTransparencyUpper = p13.knobShadowTransparencyUpper,
			[Roact.Ref] = props.forwardedRef,
			NextSelectionUp = props.NextSelectionUp,
			NextSelectionDown = props.NextSelectionDown,
			focusController = props.focusController,
			customTrack = props.customTrack,
			customKnobHeight = props.customKnobHeight,
			customKnobBorderSize = props.customKnobBorderSize,
			customKnobBorderColor = props.customKnobBorderColor,
			containerRef = props.containerRef
		}

		if p2 then
			t2.upperValue = props.upperValue
			t2.lowerValue = props.lowerValue
		else
			t2.lowerValue = props.value
		end

		return Roact.createElement(GenericSlider, t2)
	end
	function v15.didMount(p14) -- line: 217
		p14.pressedMotorLower:start()
		p14.pressedMotorUpper:start()
	end
	function v15.didUpdate(p15, p16) -- line: 222
		-- upvalues: Otter (copy), t1 (copy)
		if p16.style ~= p15.props.style then
			p15.setStyle(p15.props.style)
		end

		if p16.isDisabled ~= p15.props.isDisabled then
			p15.setDisabled(p15.props.isDisabled)

			if p15.props.isDisabled then
				p15.pressedMotorLower:setGoal(Otter.spring(0, t1))
				p15.pressedMotorUpper:setGoal(Otter.spring(0, t1))
			end
		end
	end
	function v15.willUnmount(p17) -- line: 237
		p17.wasUnmounted = true
		p17.pressedMotorLower:destroy()
		p17.pressedMotorUpper:destroy()
	end

	return v15
end

return makeAppSlider
