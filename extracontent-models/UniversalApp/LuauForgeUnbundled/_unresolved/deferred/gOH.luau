local CorePackages = game:GetService("CorePackages")

local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local inputSize = Foundation.Enums.InputSize
local visibility = Foundation.Enums.Visibility
local sliderVariant = Foundation.Enums.SliderVariant
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Core.Style.withStyle
local systemSlider = UIBlox.App.Slider.SystemSlider
local Cryo = require(CorePackages.Packages.Cryo)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices

local module = require("@luauforge/bundled/dNQ")
local module2 = require("@luauforge/bundled/fvh")
local module3 = require("@luauforge/bundled/geT")
local module4 = require("@luauforge/deferred/gOG")
local module5 = require("@luauforge/deferred/gOB")
local module6 = require("@luauforge/deferred/gOI")

local module7 = require("@luauforge/bundled/ggq")

local defineFastFlag = game:DefineFastFlag("ColorPickerVRFix2", false)

local fFlagAXMigrateSystemSliderToFoundationSlider = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXMigrateSystemSliderToFoundationSlider
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXMakeSlidersSmoothWithGamepad = AvatarExperienceFlags.FFlagAXMakeSlidersSmoothWithGamepad
local fFlagAXUseSignalsForBodyColorPickerSettings = AvatarExperienceFlags.FFlagAXUseSignalsForBodyColorPickerSettings
local defineFastFlag2 = game:DefineFastFlag("AXIgnoreNaNBodyColorSliderValue", false)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local v5

if fFlagAXUseSignalsForBodyColorPickerSettings then
	v5 = require("@luauforge/bundled/gOv")
else
	v5 = nil
end

local color = Color3.new(0.75, 0.75, 0.75)

local extended = Roact.PureComponent:extend("BodyColorsSliderFrame")

local strictInterface = t.strictInterface
local v6 = {
	sliderValue = t.number,
	rangeStruct = t.optional(t.table),
	setBodyColor3 = t.optional(t.callback),
	setBodyColors = t.optional(t.callback),
	setAvatarScales = t.optional(t.callback),
	NextSelectionUp = t.optional(t.table),
	sliderRef = t.optional(t.table),
	gridAndSidebarFrameSizeBinding = t.union(t.UDim2, t.table),
	rangeIdForSelectedBodyParts = t.optional(t.string),
	defaultBodyColorRanges = t.optional(t.table),
	disabled = t.optional(t.boolean),
	tokens = 0,
	pickerSelectedBodyPartIndex = 0,
	pickerBodyPartsToSliderAndColor3Values = 0,
	analytics = 0
}
local v7 = if fFlagAXMigrateSystemSliderToFoundationSlider then t.table else nil
v6.tokens = v7

v6.pickerSelectedBodyPartIndex = t.optional(t.number)
v6.pickerBodyPartsToSliderAndColor3Values = t.optional(t.table)

v6.analytics = t.table
extended.validateProps = strictInterface(v6)

function extended:init()
	self.state = { sliderValue = self.props.sliderValue }

	function self.onSliderChanged(p2)
		if defineFastFlag2 and p2 ~= p2 then
			return
		end

		local color3AtValueForRangeId = module2.getColor3AtValueForRangeId(
			self.props.rangeIdForSelectedBodyParts,
			p2,
			self.props.defaultBodyColorRanges
		)

		self:setState({ sliderValue = p2 })

		self.props.setBodyColors(color3AtValueForRangeId)
	end
	function self.onDragEnd()
		if self.isMounted then
			local sliderValue = self.state.sliderValue
			local color3AtValueForRangeId = module2.getColor3AtValueForRangeId(
				self.props.rangeIdForSelectedBodyParts,
				sliderValue,
				self.props.defaultBodyColorRanges
			)

			self.props.setBodyColors(nil)

			self.props.setBodyColor3(
				color3AtValueForRangeId,
				self.props.rangeIdForSelectedBodyParts,
				sliderValue,
				self.props.analytics
			)
		end
	end

	local ref = if not defineFastFlag then Roact.createRef() else nil
	self.containerRef = ref
end

function extended:didMount()
	self:setState({ sliderValue = self.props.sliderValue })

	self.isMounted = true
end

function extended.didUpdate(object, p2)
	if p2.sliderValue ~= object.props.sliderValue then
		object:setState({ sliderValue = object.props.sliderValue })
	end
end

function extended:getCustomKnobColorLower()
	local sliderValue = self.state.sliderValue
	return (module2.getColor3AtValueForRangeId(
		self.props.rangeIdForSelectedBodyParts,
		sliderValue,
		self.props.defaultBodyColorRanges
	))
end

if not fFlagAXMigrateSystemSliderToFoundationSlider then
	function extended:renderTrack()
		local rangeStruct = self.props.rangeStruct

		if not rangeStruct then
			return nil
		end

		local colorSequenceKeypoints = {}

		for k, v8 in rangeStruct.range do
			local v9 = (k - 1) / (#rangeStruct.range - 1)
			table.insert(colorSequenceKeypoints, (ColorSequenceKeypoint.new(v9, v8)))
		end

		local colorSequence = ColorSequence.new(colorSequenceKeypoints)

		return Roact.createElement(
			"Frame",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(1, 0, 0, module.BodyColorsSliderTrackHeight),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundColor3 = color
			},
			{
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0.5, 0)
				}),
				TrackContent = Roact.createElement("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.new(1, -2, 0, module.BodyColorsSliderTrackHeight - 2),
					Position = UDim2.fromScale(0.5, 0.5),
					BackgroundColor3 = Color3.new(1, 1, 1)
				}, {
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0.5, 0)
					}),
					UIGradient = Roact.createElement("UIGradient", {
						Color = colorSequence
					})
				})
			}
		)
	end
end

function extended:render()
	return withStyle(function(p2)
		return self:renderWithProviders(p2)
	end)
end

function extended:renderWithProviders(p2)
	local theme = p2.Theme
	local sliderValue = self.state.sliderValue

	if fFlagAXMigrateSystemSliderToFoundationSlider then
		local tokens = self.props.tokens

		local rangeStruct = self.props.rangeStruct

		if not rangeStruct then
			return nil
		end

		local colorSequenceKeypoints = {}

		for k, v8 in rangeStruct.range do
			local v9 = (k - 1) / (#rangeStruct.range - 1)
			table.insert(colorSequenceKeypoints, (ColorSequenceKeypoint.new(v9, v8)))
		end

		local colorSequence = ColorSequence.new(colorSequenceKeypoints)

		local v8 = { Color3 = self:getCustomKnobColorLower(), Transparency = 0.5 }

		local createElement = Roact.createElement
		local v10 = {
			["Size"] = nil,
			Size = self.props.gridAndSidebarFrameSizeBinding:map(function(p3)
				return UDim2.new(1, -2 * module.SkinColorSliderPadding, 0, -p3.Y.Offset)
			end),
			Position = self.props.gridAndSidebarFrameSizeBinding:map(function(p3)
				return UDim2.new(0, module.SkinColorSliderPadding, 1, p3.Y.Offset)
			end),
			BorderSizePixel = 0,
			BackgroundColor3 = theme.BackgroundDefault.Color
		}
		local ref = Roact.Ref
		local v11 = if not defineFastFlag then self.containerRef else nil
		v10[ref] = v11
		local v12 = {
			Divider1 = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = theme.Divider.Color,
				BackgroundTransparency = theme.Divider.Transparency
			}),
			SliderBar = 0
		}

		local createElement2 = React.createElement
		local view = Foundation.View
		local v13 = {
			tag = "auto-y size-full-0 radius-circle stroke-standard stroke-emphasis",
			backgroundStyle = tokens.Color.Extended.White.White_100,
			Position = UDim2.new(0, 0, 0, module.BodyColorsSliderFrameHeight / 2),
			containerRef = 0
		}

		local v14 = if not defineFastFlag then self.containerRef else nil
		v13.containerRef = v14
		v12.SliderBar = createElement2(view, v13, {
			Gradient = React.createElement("UIGradient", { Color = colorSequence }),
			ColorSlider = React.createElement(Foundation.Slider, {
				value = sliderValue,
				range = NumberRange.new(0, 1),
				size = inputSize.Medium,
				variant = sliderVariant.Utility,
				isContained = true,
				isDisabled = self.props.disabled,
				knob = React.createElement(Foundation.Knob, {
					size = inputSize.Medium,
					style = v8,
					stroke = {
						Color = tokens.Color.System.Neutral.Color3,
						Transparency = tokens.Color.System.Neutral.Transparency,
						Thickness = tokens.Stroke.Thick
					},
					hasShadow = true
				}),
				knobVisibility = visibility.Always,
				onValueChanged = self.onSliderChanged,
				width = UDim.new(1, 0),
				onDragEnded = self.onDragEnd,
				ref = self.props.sliderRef,
				NextSelectionUp = self.props.NextSelectionUp,
				step = fFlagAXMakeSlidersSmoothWithGamepad and 0.01 or nil
			})
		})
		return createElement("Frame", v10, v12)
	else
		local createElement = Roact.createElement
		local v9 = {
			["Size"] = nil,
			Size = self.props.gridAndSidebarFrameSizeBinding:map(function(p3)
				return UDim2.new(1, -2 * module.SkinColorSliderPadding, 0, -p3.Y.Offset)
			end),
			Position = self.props.gridAndSidebarFrameSizeBinding:map(function(p3)
				return UDim2.new(0, module.SkinColorSliderPadding, 1, p3.Y.Offset)
			end),
			BorderSizePixel = 0,
			BackgroundColor3 = theme.BackgroundDefault.Color
		}
		local ref = Roact.Ref
		local v10 = if not defineFastFlag then self.containerRef else nil
		v9[ref] = v10
		local v11 = {
			Divider1 = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = theme.Divider.Color,
				BackgroundTransparency = theme.Divider.Transparency
			}),
			SliderBar = 0
		}

		local createElement2 = Roact.createElement
		local sliderRefsByRef = {
			min = 0,
			max = 1,
			stepInterval = 0.01,
			value = sliderValue,
			isDisabled = self.props.disabled,
			onValueChanged = self.onSliderChanged,
			onDragEnd = self.onDragEnd,
			width = UDim.new(1, 0),
			position = UDim2.new(0.5, 0, 0, module.BodyColorsSliderFrameHeight / 2),
			anchorPoint = Vector2.new(0.5, 0.5),
			customTrack = self:renderTrack(),
			customKnobColorLower = self:getCustomKnobColorLower(),
			customPressedKnobShadowTransparencyLower = 0.5,
			customKnobBorderSize = 1,
			customKnobBorderColor = color,
			[Roact.Ref] = self.props.sliderRef,
			NextSelectionUp = self.props.NextSelectionUp
		}

		local v13 = if not defineFastFlag then self.containerRef else nil
		sliderRefsByRef.containerRef = v13
		v11.SliderBar = createElement2(systemSlider, sliderRefsByRef)
		return createElement("Frame", v9, v11)
	end
end

function extended:willUnmount()
	self.isMounted = false
end

local v8 = roactServices.connect({ analytics = module3 })(extended)

local v9 = RoactRodux.connect(function(p2, data)
	local avatarExperience = p2.AvatarExperience
	local defaultBodyColorRanges = data.defaultBodyColorRanges

	local rangeIdForSelectedBodyParts = data.rangeIdForSelectedBodyParts
	assert(rangeIdForSelectedBodyParts, "rangeIdForSelectedBodyParts ~= nil.")

	local rangeStructForRangeId = module2.getRangeStructForRangeId(
		rangeIdForSelectedBodyParts,
		defaultBodyColorRanges
	)
	assert(rangeStructForRangeId, "rangeStruct ~= nil.")
	local v10 = module7(p2)
	local v11

	if v10 then
		v11 = 0.5
	elseif fFlagAXUseSignalsForBodyColorPickerSettings then
		v11 = module2.getSliderValueForBodyPartIndex(
			data.pickerSelectedBodyPartIndex,
			data.pickerBodyPartsToSliderAndColor3Values
		)
	else
		v11 = module4(avatarExperience, rangeIdForSelectedBodyParts)
	end

	return { rangeStruct = rangeStructForRangeId, sliderValue = v11, disabled = v10 }
end, function(callback)
	return {
		setBodyColor3 = function(p2, p3, p4, p5)
			callback(module5(p2, p3, p4, p5))
		end
	}
end)(v8)

local v10 = v9

local function BodyColorsSliderFrameWithSignals(p2)
	local v11 = v5(false)
	local v12 = useSignalState(v11.getBodyPartsToSliderAndColor3ValuesForRange(p2.rangeIdForSelectedBodyParts))

	local v13 = useSignalState(v11.getSelectedBodyPartIndex)
	return React.createElement(
		v10,
		Cryo.Dictionary.union(p2, {
			pickerSelectedBodyPartIndex = v13,
			pickerBodyPartsToSliderAndColor3Values = v12
		})
	)
end

if fFlagAXUseSignalsForBodyColorPickerSettings then
	v9 = React.memo(BodyColorsSliderFrameWithSignals)
end

return function(p2)
	local v11 = module6()
	local joined = Cryo.Dictionary.join(v11, p2)

	if fFlagAXMigrateSystemSliderToFoundationSlider then
		local v12 = useTokens()
		joined = Cryo.Dictionary.join({ tokens = v12 }, joined)
	end

	return React.createElement(v9, joined)
end
