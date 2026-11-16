local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)

local useStyle = UIBlox.Core.Style.useStyle

local module = require("@luauforge/deferred/gWj")
local module2 = require("@luauforge/bundled/fuH")
local module3 = require("@luauforge/bundled/dTu")
local focusable = RoactGamepad.Focusable

local function Slider(p2, p3, p4, p5, setSliderValuesCallback, p6)
	return React.createElement(module, {
		sliderRef = p6,
		LayoutOrder = p4,
		adjustmentSliderType = p3,
		sliderValue = p2[p3],
		updateCharacterCallback = p5,
		setSliderValuesCallback = setSliderValuesCallback
	})
end

local function getSliders(p2, sliderValues, updateCharacterCallback, setSliderValuesCallback, list)
	local sliders = {}

	if p2 == module3.Position then
		table.insert(
			sliders,
			Slider(
				sliderValues,
				module2.PositionX,
				1,
				updateCharacterCallback,
				setSliderValuesCallback,
				list[1]
			)
		)

		table.insert(
			sliders,
			Slider(
				sliderValues,
				module2.PositionY,
				2,
				updateCharacterCallback,
				setSliderValuesCallback,
				list[2]
			)
		)

		table.insert(
			sliders,
			Slider(
				sliderValues,
				module2.PositionZ,
				3,
				updateCharacterCallback,
				setSliderValuesCallback,
				list[3]
			)
		)
	elseif p2 == module3.Rotation then
		table.insert(
			sliders,
			Slider(
				sliderValues,
				module2.RotationX,
				1,
				updateCharacterCallback,
				setSliderValuesCallback,
				list[1]
			)
		)

		table.insert(
			sliders,
			Slider(
				sliderValues,
				module2.RotationY,
				2,
				updateCharacterCallback,
				setSliderValuesCallback,
				list[2]
			)
		)

		table.insert(
			sliders,
			Slider(
				sliderValues,
				module2.RotationZ,
				3,
				updateCharacterCallback,
				setSliderValuesCallback,
				list[3]
			)
		)
	elseif p2 == module3.Scale then
		table.insert(
			sliders,
			Slider(
				sliderValues,
				module2.Scale,
				1,
				updateCharacterCallback,
				setSliderValuesCallback,
				list[1]
			)
		)
	end

	table.insert(sliders, React.createElement("UIListLayout", {
		Padding = UDim.new(0, 24),
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top
	}))

	table.insert(sliders, React.createElement("UIPadding", {
		PaddingRight = UDim.new(0, 5)
	}))

	return sliders
end

if require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXMigrateSystemSliderToFoundationSlider then
	local function AdjustmentSliders(props)
		local theme = useStyle().Theme

		local v5 = RoactGamepad.useRefCache()
		local v6 = RoactGamepad.useRefCache()
		local v7 = RoactGamepad.useRefCache()

		local ref = React.useRef(nil)
		local ref2 = React.useRef(nil)
		local ref3 = React.useRef(nil)

		local sliders = getSliders(
			module3.Position,
			props.sliderValues,
			props.updateCharacterCallback,
			props.setSliderValuesCallback,
			v5
		)

		local sliders2 = getSliders(
			module3.Rotation,
			props.sliderValues,
			props.updateCharacterCallback,
			props.setSliderValuesCallback,
			v6
		)

		local sliders3 = getSliders(
			module3.Scale,
			props.sliderValues,
			props.updateCharacterCallback,
			props.setSliderValuesCallback,
			v7
		)

		local createElement = React.createElement
		local v9 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = 1,
			LayoutOrder = props.LayoutOrder
		}

		local v11 = if props.adjustmentTypeSelected == module3.Position then React.createElement("Frame", {
			ref = ref,
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			ZIndex = 2
		}, sliders) else nil

		local v12 = if props.adjustmentTypeSelected == module3.Rotation then React.createElement("Frame", {
			ref = ref2,
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			ZIndex = 2
		}, sliders2) else nil

		local v13 = if props.adjustmentTypeSelected == module3.Scale then React.createElement("Frame", {
			ref = ref3,
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			ZIndex = 2
		}, sliders3) else nil
		return createElement("Frame", v9, {
			PositionSlidersContainer = v11,
			RotationSlidersContainer = v12,
			ScaleSlidersContainer = v13,
			BackPanel = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = theme.BackgroundDefault.Color,
				BackgroundTransparency = theme.BackgroundDefault.Transparency,
				BorderSizePixel = 0,
				ZIndex = 1
			})
		})
	end

	return AdjustmentSliders
end

local function AdjustmentSliders(props)
	local theme = useStyle().Theme

	local v5 = RoactGamepad.useRefCache()
	local v6 = RoactGamepad.useRefCache()
	local v7 = RoactGamepad.useRefCache()

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	local state, setState = React.useState(v5[1])

	local sliders = getSliders(
		module3.Position,
		props.sliderValues,
		props.updateCharacterCallback,
		props.setSliderValuesCallback,
		v5
	)

	local sliders2 = getSliders(
		module3.Rotation,
		props.sliderValues,
		props.updateCharacterCallback,
		props.setSliderValuesCallback,
		v6
	)

	local sliders3 = getSliders(
		module3.Scale,
		props.sliderValues,
		props.updateCharacterCallback,
		props.setSliderValuesCallback,
		v7
	)

	React.useEffect(function()
		if props.adjustmentTypeSelected == module3.Position then
			setState(ref)
		elseif props.adjustmentTypeSelected == module3.Rotation then
			setState(ref2)
		else
			setState(ref3)
		end
	end, { props.adjustmentTypeSelected })

	return React.createElement(focusable.Frame, {
		ref = props.frameRef,
		defaultChild = state,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder
	}, {
		PositionSlidersContainer = React.createElement(focusable.Frame, {
			ref = ref,
			defaultChild = v5[1],
			restorePreviousChildFocus = true,
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			ZIndex = props.adjustmentTypeSelected == module3.Position and 2 or 0
		}, sliders),
		RotationSlidersContainer = React.createElement(focusable.Frame, {
			ref = ref2,
			defaultChild = v6[1],
			restorePreviousChildFocus = true,
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			ZIndex = props.adjustmentTypeSelected == module3.Rotation and 2 or 0
		}, sliders2),
		ScaleSlidersContainer = React.createElement(focusable.Frame, {
			ref = ref3,
			defaultChild = v7[1],
			restorePreviousChildFocus = true,
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			ZIndex = props.adjustmentTypeSelected == module3.Scale and 2 or 0
		}, sliders3),
		BackPanel = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			ZIndex = 1
		})
	})
end

return AdjustmentSliders
