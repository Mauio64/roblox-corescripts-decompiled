local CorePackages = game:GetService("CorePackages")

local Foundation = require(CorePackages.Packages.Foundation)

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local module = require("@luauforge/bundled/dCn")

local useStyle = UIBlox.Core.Style.useStyle
local systemSlider = UIBlox.App.Slider.SystemSlider
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module2 = require("@luauforge/deferred/gWa")

local module3 = require("@luauforge/deferred/gWc")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local module5 = require("@luauforge/bundled/fuG")

local module6 = require("@luauforge/bundled/fuH")
local Extents = require("@game/CorePackages/Packages/_Index/UGCValidation/UGCValidation/util/Extents")
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial

local defineFastInt = game:DefineFastInt("AXAdjustmentSnapThreshold", 5)

local defineFastFlag = game:DefineFastFlag("AXAddVRContainerRefToAASlider", false)

local fFlagAXMigrateSystemSliderToFoundationSlider = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXMigrateSystemSliderToFoundationSlider
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXMakeSlidersSmoothWithGamepad = AvatarExperienceFlags.FFlagAXMakeSlidersSmoothWithGamepad
local fFlagAXUseSignalsForAdjustmentTypeSelected = AvatarExperienceFlags.FFlagAXUseSignalsForAdjustmentTypeSelected
local getAdjustmentTypeSelectedStore

if fFlagAXUseSignalsForAdjustmentTypeSelected then
	getAdjustmentTypeSelectedStore = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Stores.getAdjustmentTypeSelectedStore
else
	getAdjustmentTypeSelectedStore = nil
end

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local component_assetscircle_21 = images["component_assets/circle_21"]

local v5 = {
	[module6.PositionX] = {
		Text = Extents.X,
		Color = module5.XAxisColor,
		AdjustmentKey = "position",
		LimitKey = "xPosition",
		Invert = true
	},
	[module6.PositionY] = {
		Text = Extents.Y,
		Color = module5.YAxisColor,
		AdjustmentKey = "position",
		LimitKey = "yPosition"
	},
	[module6.PositionZ] = {
		Text = Extents.Z,
		Color = module5.ZAxisColor,
		AdjustmentKey = "position",
		LimitKey = "zPosition",
		Invert = true
	},
	[module6.RotationX] = {
		Text = Extents.X,
		Color = module5.XAxisColor,
		AdjustmentKey = "rotation",
		LimitKey = "xRotation",
		Invert = true
	},
	[module6.RotationY] = {
		Text = Extents.Y,
		Color = module5.YAxisColor,
		AdjustmentKey = "rotation",
		LimitKey = "yRotation"
	},
	[module6.RotationZ] = {
		Text = Extents.Z,
		Color = module5.ZAxisColor,
		AdjustmentKey = "rotation",
		LimitKey = "zRotation"
	},
	[module6.Scale] = {
		Text = "",
		Color = module5.ZAxisColor,
		AdjustmentKey = "scale",
		LimitKey = "xScale"
	}
}

local function SliderImage(theme, adjustmentSliderType, smallIconSize)
	return React.createElement(imageSetLabel, {
		Size = UDim2.new(0, smallIconSize, 0, smallIconSize),
		BackgroundTransparency = 1,
		Image = component_assetscircle_21,
		ImageColor3 = v5[adjustmentSliderType].Color,
		ImageTransparency = theme.IconEmphasis.Transparency,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0)
	}, {
		Letter = React.createElement("TextLabel", {
			Size = UDim2.new(1, -3, 1, -3),
			BackgroundTransparency = 1,
			Text = v5[adjustmentSliderType].Text,
			TextScaled = true,
			FontFace = module5.FontFace,
			TextColor3 = Color3.new(1, 1, 1),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			ZIndex = 2
		})
	})
end

local function valueToPercent(p2, p3, p4, p5, p6)
	local v6 = if p2 < p5 then -math.abs((p2 - p5) / (p3 - p5)) else math.abs((p2 - p5) / (p4 - p5))

	if p6 then
		v6 = -v6
	end

	return v6 * 100
end

local function percentToValue(p2, p3, p4, p5, p6)
	if p6 then
		p2 = -p2
	end

	if p2 < 0 then
		return p5 - math.abs(p2 / 100) * math.abs(p5 - p3)
	end

	return p5 + math.abs(p2 / 100) * math.abs(p4 - p5)
end

local function fn(p2)
	return p2.AvatarExperience.AccessoryAdjustment.AdjustmentTypeSelected
end

if not fFlagAXMigrateSystemSliderToFoundationSlider then
	local function AdjustmentSlider(props)
		local theme = useStyle().Theme
		local v6 = if defineFastFlag then useIsSpatial() else nil
		local ref = if defineFastFlag and v6 then React.createRef() else nil
		local v7 = useSelector(module2)
		local v8 = useSelector(module3)

		local v9 = if fFlagAXUseSignalsForAdjustmentTypeSelected then useSignalState(getAdjustmentTypeSelectedStore(false).getAdjustmentTypeSelected) else useSelector(fn)
		local v10 = module5.AdjustmentSliderTypeToAdjustmentType[props.adjustmentSliderType] ~= v9

		local ref2 = React.useRef(false)

		local v11 = Responsive.useLastInput() == Responsive.Input.Directional

		local adjustmentSliderType = props.adjustmentSliderType
		local adjustmentKey = v5[adjustmentSliderType].AdjustmentKey
		local limitKey = v5[adjustmentSliderType].LimitKey
		local v12 = v7[adjustmentKey][limitKey]
		local v13 = v8[adjustmentKey][limitKey]

		local function mapTokens(p2)
			return { smallIconSize = p2.Size.Size_400, padding = p2.Size.Size_400 }
		end

		local v14 = useDesignTokens(mapTokens)
		local v15 = props.adjustmentSliderType == module6.Scale and 1 or 0

		local invert = v5[props.adjustmentSliderType].Invert

		local useState = React.useState
		local sliderValue = props.sliderValue
		local v16

		if sliderValue < v15 then
			v16 = -math.abs((sliderValue - v15) / (v12 - v15))
		else
			v16 = math.abs((sliderValue - v15) / (v13 - v15))
		end

		if invert then
			v16 = -v16
		end

		local state, setState = useState(v16 * 100)

		React.useEffect(function()
			local sliderValue2 = props.sliderValue
			local v18 = v12
			local v19 = v13
			local v20 = v15
			local v22

			if sliderValue2 < v20 then
				v22 = -math.abs((sliderValue2 - v20) / (v18 - v20))
			else
				v22 = math.abs((sliderValue2 - v20) / (v19 - v20))
			end

			if invert then
				v22 = -v22
			end

			setState(v22 * 100)
		end, { props.sliderValue, v12, v13, v15, invert })

		local createElement = React.createElement
		local v18 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = 1,
			LayoutOrder = props.LayoutOrder,
			ref = 0
		}
		local v19 = if defineFastFlag and v6 then ref else nil
		v18.ref = v19
		local v20 = {
			UIListLayout = React.createElement("UIListLayout", {
				Padding = UDim.new(0, v14.padding),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			SliderImage = SliderImage(theme, props.adjustmentSliderType, v14.smallIconSize),
			Slider = 0
		}

		local createElement2 = React.createElement
		local v22 = {
			ref = props.sliderRef,
			NextSelectionDown = props.NextSelectionDown,
			NextSelectionUp = props.NextSelectionUp,
			isDisabled = v10,
			min = -100,
			max = 100,
			stepInterval = 2,
			value = state,
			onDragStart = function()
				ref2.current = true
			end,
			onValueChanged = function(p2)
				if math.abs(p2) < defineFastInt then
					if v11 and not (p2 < 0 and state < p2 or p2 > 0 and p2 < state) then
						if state == 0 then
							p2 = (p2 < 0 and -1 or 1) * defineFastInt
						end
					else
						p2 = 0
					end
				end

				local v25 = v15
				local v26 = if invert then -p2 else p2

				local v27 = if v26 < 0 then v25 - math.abs(v26 / 100) * math.abs(v25 - v12) else v25 + math.abs(v26 / 100) * math.abs(v13 - v25)

				props.updateCharacterCallback(v27, props.adjustmentSliderType)
				setState(p2)
			end,
			onDragEnd = function()
				if not ref2.current then
					return
				end

				local v23 = state
				local v26 = v15

				if invert then
					v23 = -v23
				end

				local v27 = if v23 < 0 then v26 - math.abs(v23 / 100) * math.abs(v26 - v12) else v26 + math.abs(v23 / 100) * math.abs(v13 - v26)

				props.setSliderValuesCallback(v27, props.adjustmentSliderType)
				ref2.current = false
			end,
			width = UDim.new(1, -v14.padding - v14.smallIconSize),
			layoutOrder = 2,
			containerRef = 0
		}

		if not (defineFastFlag and v6) then
			ref = nil
		end

		v22.containerRef = ref
		v20.Slider = createElement2(systemSlider, v22)
		return createElement("Frame", v18, v20)
	end

	return AdjustmentSlider
end

local function convertStoredValueToSliderValue(p2, p3, p4, p5, p6)
	if p4 <= p5 then
		module("AdjustmentSlider.lua convertStoredValueToSliderValue argument error: max must be greater than defaultValue.")

		return 0.5
	end

	local v6 = if p2 < p5 then 0.5 - (p5 - p2) / (p4 - p5) / 2 else 0.5 + (p2 - p5) / (p4 - p5) / 2

	if p6 then
		return 1 - v6
	end

	return v6
end

local function convertSliderValueToStoredValue(p2, p3, p4, p5, p6)
	if p6 then
		p2 = 1 - p2
	end

	if p2 < 0.5 then
		return p5 - (0.5 - p2) / 0.5 * (p4 - p5)
	end

	return p5 + (p2 - 0.5) / 0.5 * (p4 - p5)
end

local function AdjustmentSlider(props)
	local theme = useStyle().Theme
	local v6 = if defineFastFlag then useIsSpatial() else nil
	local ref = if defineFastFlag and v6 then React.createRef() else nil
	local v7 = useSelector(module2)
	local v8 = useSelector(module3)

	local v9 = if fFlagAXUseSignalsForAdjustmentTypeSelected then useSignalState(getAdjustmentTypeSelectedStore(false).getAdjustmentTypeSelected) else useSelector(fn)
	local v10 = module5.AdjustmentSliderTypeToAdjustmentType[props.adjustmentSliderType] ~= v9

	local ref2 = React.useRef(false)

	local v11 = Responsive.useLastInput() == Responsive.Input.Directional

	local adjustmentSliderType = props.adjustmentSliderType
	local adjustmentKey = v5[adjustmentSliderType].AdjustmentKey
	local limitKey = v5[adjustmentSliderType].LimitKey
	local v12 = v7[adjustmentKey][limitKey]
	local v13 = v8[adjustmentKey][limitKey]

	local function mapTokens(p2)
		return { smallIconSize = p2.Size.Size_400, padding = p2.Size.Size_400 }
	end

	local v14 = useDesignTokens(mapTokens)
	local v15 = props.adjustmentSliderType == module6.Scale and 1 or 0

	local invert = v5[props.adjustmentSliderType].Invert

	local useState = React.useState
	local sliderValue = props.sliderValue
	local v16

	if v13 <= v15 then
		module("AdjustmentSlider.lua convertStoredValueToSliderValue argument error: max must be greater than defaultValue.")
		v16 = 0.5
	else
		if sliderValue < v15 then
			v16 = 0.5 - (v15 - sliderValue) / (v13 - v15) / 2
		else
			v16 = 0.5 + (sliderValue - v15) / (v13 - v15) / 2
		end

		if invert then
			v16 = 1 - v16
		end
	end

	local state, setState = useState(v16)

	React.useEffect(function()
		local sliderValue2 = props.sliderValue
		local v18 = v13
		local v19 = v15
		local v20 = invert
		local v21

		if v18 <= v19 then
			module("AdjustmentSlider.lua convertStoredValueToSliderValue argument error: max must be greater than defaultValue.")
			v21 = 0.5
		else
			if sliderValue2 < v19 then
				v21 = 0.5 - (v19 - sliderValue2) / (v18 - v19) / 2
			else
				v21 = 0.5 + (sliderValue2 - v19) / (v18 - v19) / 2
			end

			if v20 then
				v21 = 1 - v21
			end
		end

		setState(v21)
	end, { props.sliderValue, v12, v13, v15, invert })

	local createElement = React.createElement
	local v18 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		ref = 0
	}

	if not (defineFastFlag and v6) then
		ref = nil
	end

	v18.ref = ref
	return createElement("Frame", v18, {
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, v14.padding),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		SliderImage = SliderImage(theme, props.adjustmentSliderType, v14.smallIconSize),
		Slider = React.createElement(Foundation.Slider, {
			ref = props.sliderRef,
			NextSelectionDown = props.NextSelectionDown,
			NextSelectionUp = props.NextSelectionUp,
			isDisabled = v10,
			range = NumberRange.new(0, 1),
			value = state,
			onDragStarted = function()
				ref2.current = true
			end,
			onValueChanged = function(p2)
				if math.abs(0.5 - p2) < 0.025 then
					p2 = not v11 and 0.5
						or p2 < 0.5 and state < p2 and 0.5
						or p2 > 0.5 and p2 < state and 0.5
						or state == 0.5 and (p2 > 0.5 and 0.525 or 0.475)
						or p2
				end

				local v19 = v13
				local v20 = v15
				local v21 = if invert then 1 - p2 else p2

				local v22 = if v21 < 0.5 then v20 - (0.5 - v21) / 0.5 * (v19 - v20) else v20 + (v21 - 0.5) / 0.5 * (v19 - v20)

				props.updateCharacterCallback(v22, props.adjustmentSliderType)
				setState(p2)
			end,
			onDragEnded = function()
				if not ref2.current then
					return
				end

				local v19 = state
				local v20 = v13
				local v21 = v15

				if invert then
					v19 = 1 - v19
				end

				local v22 = if v19 < 0.5 then v21 - (0.5 - v19) / 0.5 * (v20 - v21) else v21 + (v19 - 0.5) / 0.5 * (v20 - v21)

				props.setSliderValuesCallback(v22, props.adjustmentSliderType)
				ref2.current = false
			end,
			width = UDim.new(1, -v14.padding - v14.smallIconSize),
			layoutOrder = 2,
			step = fFlagAXMakeSlidersSmoothWithGamepad and 0.01 or nil
		})
	})
end

return AdjustmentSlider
