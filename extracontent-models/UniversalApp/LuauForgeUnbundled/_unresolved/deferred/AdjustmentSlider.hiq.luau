local CorePackages = game:GetService("CorePackages")

local Foundation = require(CorePackages.Packages.Foundation)

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local module = require("@luauforge/bundled/dFs")

local useStyle = UIBlox.Core.Style.useStyle
local systemSlider = UIBlox.App.Slider.SystemSlider
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module2 = require("@luauforge/deferred/hih")

local module3 = require("@luauforge/deferred/hij")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local module5 = require("@luauforge/bundled/fCh")

local module6 = require("@luauforge/bundled/fCi")
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
local fFlagAXUseSignalsForAvatarSettings = AvatarExperienceFlags.FFlagAXUseSignalsForAvatarSettings

local v5 = if fFlagAXUseSignalsForAvatarSettings then require("@luauforge/deferred/hir") else nil

local v6 = if fFlagAXUseSignalsForAvatarSettings then require("@luauforge/deferred/hit") else nil

local component_assetscircle_21 = images["component_assets/circle_21"]

local v7 = {
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
		ImageColor3 = v7[adjustmentSliderType].Color,
		ImageTransparency = theme.IconEmphasis.Transparency,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0)
	}, {
		Letter = React.createElement("TextLabel", {
			Size = UDim2.new(1, -3, 1, -3),
			BackgroundTransparency = 1,
			Text = v7[adjustmentSliderType].Text,
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
	local v8 = if p2 < p5 then -math.abs((p2 - p5) / (p3 - p5)) else math.abs((p2 - p5) / (p4 - p5))

	if p6 then
		v8 = -v8
	end

	return v8 * 100
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
		local v8 = if defineFastFlag then useIsSpatial() else nil
		local ref = if defineFastFlag and v8 then React.createRef() else nil

		local v9 = if fFlagAXUseSignalsForAvatarSettings then v5() else useSelector(module2)

		local v10 = if fFlagAXUseSignalsForAvatarSettings then v6() else useSelector(module3)

		local v11 = if fFlagAXUseSignalsForAdjustmentTypeSelected then useSignalState(getAdjustmentTypeSelectedStore(false).getAdjustmentTypeSelected) else useSelector(fn)
		local v12 = module5.AdjustmentSliderTypeToAdjustmentType[props.adjustmentSliderType] ~= v11

		local ref2 = React.useRef(false)

		local v13 = Responsive.useLastInput() == Responsive.Input.Directional

		local adjustmentSliderType = props.adjustmentSliderType
		local adjustmentKey = v7[adjustmentSliderType].AdjustmentKey
		local limitKey = v7[adjustmentSliderType].LimitKey
		local v14 = v9[adjustmentKey][limitKey]
		local v15 = v10[adjustmentKey][limitKey]

		local function mapTokens(p2)
			return { smallIconSize = p2.Size.Size_400, padding = p2.Size.Size_400 }
		end

		local v16 = useDesignTokens(mapTokens)
		local v17 = props.adjustmentSliderType == module6.Scale and 1 or 0

		local invert = v7[props.adjustmentSliderType].Invert

		local useState = React.useState
		local sliderValue = props.sliderValue
		local v18

		if sliderValue < v17 then
			v18 = -math.abs((sliderValue - v17) / (v14 - v17))
		else
			v18 = math.abs((sliderValue - v17) / (v15 - v17))
		end

		if invert then
			v18 = -v18
		end

		local state, setState = useState(v18 * 100)

		React.useEffect(function()
			local sliderValue2 = props.sliderValue
			local v20 = v14
			local v21 = v15
			local v22 = v17
			local v24

			if sliderValue2 < v22 then
				v24 = -math.abs((sliderValue2 - v22) / (v20 - v22))
			else
				v24 = math.abs((sliderValue2 - v22) / (v21 - v22))
			end

			if invert then
				v24 = -v24
			end

			setState(v24 * 100)
		end, { props.sliderValue, v14, v15, v17, invert })

		local createElement = React.createElement
		local v20 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = 1,
			LayoutOrder = props.LayoutOrder,
			ref = 0
		}
		local v21 = if defineFastFlag and v8 then ref else nil
		v20.ref = v21
		local v22 = {
			UIListLayout = React.createElement("UIListLayout", {
				Padding = UDim.new(0, v16.padding),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			SliderImage = SliderImage(theme, props.adjustmentSliderType, v16.smallIconSize),
			Slider = 0
		}

		local createElement2 = React.createElement
		local v24 = {
			ref = props.sliderRef,
			NextSelectionDown = props.NextSelectionDown,
			NextSelectionUp = props.NextSelectionUp,
			isDisabled = v12,
			min = -100,
			max = 100,
			stepInterval = 2,
			value = state,
			onDragStart = function()
				ref2.current = true
			end,
			onValueChanged = function(p2)
				if math.abs(p2) < defineFastInt then
					if v13 and not (p2 < 0 and state < p2 or p2 > 0 and p2 < state) then
						if state == 0 then
							p2 = (p2 < 0 and -1 or 1) * defineFastInt
						end
					else
						p2 = 0
					end
				end

				local v27 = v17
				local v28 = if invert then -p2 else p2

				local v29 = if v28 < 0 then v27 - math.abs(v28 / 100) * math.abs(v27 - v14) else v27 + math.abs(v28 / 100) * math.abs(v15 - v27)

				props.updateCharacterCallback(v29, props.adjustmentSliderType)
				setState(p2)
			end,
			onDragEnd = function()
				if not ref2.current then
					return
				end

				local v25 = state
				local v28 = v17

				if invert then
					v25 = -v25
				end

				local v29 = if v25 < 0 then v28 - math.abs(v25 / 100) * math.abs(v28 - v14) else v28 + math.abs(v25 / 100) * math.abs(v15 - v28)

				props.setSliderValuesCallback(v29, props.adjustmentSliderType)
				ref2.current = false
			end,
			width = UDim.new(1, -v16.padding - v16.smallIconSize),
			layoutOrder = 2,
			containerRef = 0
		}

		if not (defineFastFlag and v8) then
			ref = nil
		end

		v24.containerRef = ref
		v22.Slider = createElement2(systemSlider, v24)
		return createElement("Frame", v20, v22)
	end

	return AdjustmentSlider
end

local function convertStoredValueToSliderValue(p2, p3, p4, p5, p6)
	if p4 <= p5 then
		module("AdjustmentSlider.lua convertStoredValueToSliderValue argument error: max must be greater than defaultValue.")

		return 0.5
	end

	local v8 = if p2 < p5 then 0.5 - (p5 - p2) / (p4 - p5) / 2 else 0.5 + (p2 - p5) / (p4 - p5) / 2

	if p6 then
		return 1 - v8
	end

	return v8
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
	local v8 = if defineFastFlag then useIsSpatial() else nil
	local ref = if defineFastFlag and v8 then React.createRef() else nil

	local v9 = if fFlagAXUseSignalsForAvatarSettings then v5() else useSelector(module2)

	local v10 = if fFlagAXUseSignalsForAvatarSettings then v6() else useSelector(module3)

	local v11 = if fFlagAXUseSignalsForAdjustmentTypeSelected then useSignalState(getAdjustmentTypeSelectedStore(false).getAdjustmentTypeSelected) else useSelector(fn)
	local v12 = module5.AdjustmentSliderTypeToAdjustmentType[props.adjustmentSliderType] ~= v11

	local ref2 = React.useRef(false)

	local v13 = Responsive.useLastInput() == Responsive.Input.Directional

	local adjustmentSliderType = props.adjustmentSliderType
	local adjustmentKey = v7[adjustmentSliderType].AdjustmentKey
	local limitKey = v7[adjustmentSliderType].LimitKey
	local v14 = v9[adjustmentKey][limitKey]
	local v15 = v10[adjustmentKey][limitKey]

	local function mapTokens(p2)
		return { smallIconSize = p2.Size.Size_400, padding = p2.Size.Size_400 }
	end

	local v16 = useDesignTokens(mapTokens)
	local v17 = props.adjustmentSliderType == module6.Scale and 1 or 0

	local invert = v7[props.adjustmentSliderType].Invert

	local useState = React.useState
	local sliderValue = props.sliderValue
	local v18

	if v15 <= v17 then
		module("AdjustmentSlider.lua convertStoredValueToSliderValue argument error: max must be greater than defaultValue.")
		v18 = 0.5
	else
		if sliderValue < v17 then
			v18 = 0.5 - (v17 - sliderValue) / (v15 - v17) / 2
		else
			v18 = 0.5 + (sliderValue - v17) / (v15 - v17) / 2
		end

		if invert then
			v18 = 1 - v18
		end
	end

	local state, setState = useState(v18)

	React.useEffect(function()
		local sliderValue2 = props.sliderValue
		local v20 = v15
		local v21 = v17
		local v22 = invert
		local v23

		if v20 <= v21 then
			module("AdjustmentSlider.lua convertStoredValueToSliderValue argument error: max must be greater than defaultValue.")
			v23 = 0.5
		else
			if sliderValue2 < v21 then
				v23 = 0.5 - (v21 - sliderValue2) / (v20 - v21) / 2
			else
				v23 = 0.5 + (sliderValue2 - v21) / (v20 - v21) / 2
			end

			if v22 then
				v23 = 1 - v23
			end
		end

		setState(v23)
	end, { props.sliderValue, v14, v15, v17, invert })

	local createElement = React.createElement
	local v20 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		ref = 0
	}

	if not (defineFastFlag and v8) then
		ref = nil
	end

	v20.ref = ref
	return createElement("Frame", v20, {
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, v16.padding),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		SliderImage = SliderImage(theme, props.adjustmentSliderType, v16.smallIconSize),
		Slider = React.createElement(Foundation.Slider, {
			ref = props.sliderRef,
			NextSelectionDown = props.NextSelectionDown,
			NextSelectionUp = props.NextSelectionUp,
			isDisabled = v12,
			range = NumberRange.new(0, 1),
			value = state,
			onDragStarted = function()
				ref2.current = true
			end,
			onValueChanged = function(p2)
				if math.abs(0.5 - p2) < 0.025 then
					p2 = not v13 and 0.5
						or p2 < 0.5 and state < p2 and 0.5
						or p2 > 0.5 and p2 < state and 0.5
						or state == 0.5 and (p2 > 0.5 and 0.525 or 0.475)
						or p2
				end

				local v21 = v15
				local v22 = v17
				local v23 = if invert then 1 - p2 else p2

				local v24 = if v23 < 0.5 then v22 - (0.5 - v23) / 0.5 * (v21 - v22) else v22 + (v23 - 0.5) / 0.5 * (v21 - v22)

				props.updateCharacterCallback(v24, props.adjustmentSliderType)
				setState(p2)
			end,
			onDragEnded = function()
				if not ref2.current then
					return
				end

				local v21 = state
				local v22 = v15
				local v23 = v17

				if invert then
					v21 = 1 - v21
				end

				local v24 = if v21 < 0.5 then v23 - (0.5 - v21) / 0.5 * (v22 - v23) else v23 + (v21 - 0.5) / 0.5 * (v22 - v23)

				props.setSliderValuesCallback(v24, props.adjustmentSliderType)
				ref2.current = false
			end,
			width = UDim.new(1, -v16.padding - v16.smallIconSize),
			layoutOrder = 2,
			step = fFlagAXMakeSlidersSmoothWithGamepad and 0.01 or nil
		})
	})
end

return AdjustmentSlider
