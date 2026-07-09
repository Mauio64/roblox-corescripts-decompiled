local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local InputSize = Foundation.Enums.InputSize
local Visibility = Foundation.Enums.Visibility
local SliderVariant = Foundation.Enums.SliderVariant
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Core.Style.withStyle
local SystemSlider = UIBlox.App.Slider.SystemSlider
local Cryo = require(CorePackages.Packages.Cryo)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local selectButtonSliderValue = require(Modules.AvatarExperience.AvatarEditor.Selectors.selectButtonSliderValue)
local SetBodyColor3 = require(Modules.AvatarExperience.AvatarEditor.Thunks.SetBodyColor3)
local useBodyDataCallbacksContext = require(Modules.AvatarExperience.Common.Context.useBodyDataCallbacksContext)
local selectDefaultTryOnBodyColorsToggled = require(Modules.AvatarExperience.Common.Selectors.selectDefaultTryOnBodyColorsToggled)
local v24 = game:DefineFastFlag("ColorPickerVRFix2", false)
local FFlagAXMigrateSystemSliderToFoundationSlider = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateSystemSliderToFoundationSlider
local FFlagAXMakeSlidersSmoothWithGamepad = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMakeSlidersSmoothWithGamepad
local color3 = Color3.new(0.75, 0.75, 0.75)
local v28 = Roact.PureComponent:extend("BodyColorsSliderFrame")

v28.validateProps = t.strictInterface({
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
	tokens = if not FFlagAXMigrateSystemSliderToFoundationSlider then nil else t.table,
	analytics = t.table
})

function v28.init(p1) -- line: 64
	-- upvalues: Utils (copy), v24 (copy), Roact (copy)
	p1.state = {
		sliderValue = p1.props.sliderValue
	}

	function p1.onSliderChanged(p2) -- line: 69
		-- upvalues: Utils (copy), p1 (copy)
		local v72 = Utils.getColor3AtValueForRangeId(p1.props.rangeIdForSelectedBodyParts, p2, p1.props.defaultBodyColorRanges)

		p1:setState({
			sliderValue = p2
		})
		p1.props.setBodyColors(v72)
	end
	function p1.onDragEnd() -- line: 81
		-- upvalues: p1 (copy), Utils (copy)
		if p1.isMounted then
			local sliderValue = p1.state.sliderValue
			local v74 = Utils.getColor3AtValueForRangeId(p1.props.rangeIdForSelectedBodyParts, sliderValue, p1.props.defaultBodyColorRanges)

			p1.props.setBodyColors(nil)
			p1.props.setBodyColor3(v74, p1.props.rangeIdForSelectedBodyParts, sliderValue, p1.props.analytics)
		end
	end

	p1.containerRef = if not v24 then Roact.createRef() else nil
end
function v28.didMount(p3) -- line: 100
	p3:setState({
		sliderValue = p3.props.sliderValue
	})
	p3.isMounted = true
end
function v28.didUpdate(p4, p5) -- line: 107
	if p5.sliderValue ~= p4.props.sliderValue then
		p4:setState({
			sliderValue = p4.props.sliderValue
		})
	end
end
function v28.getCustomKnobColorLower(p6) -- line: 115
	-- upvalues: Utils (copy)
	local sliderValue = p6.state.sliderValue

	return (Utils.getColor3AtValueForRangeId(p6.props.rangeIdForSelectedBodyParts, sliderValue, p6.props.defaultBodyColorRanges))
end

if not FFlagAXMigrateSystemSliderToFoundationSlider then
	function v28.renderTrack(p7) -- line: 126
		-- upvalues: Roact (copy), Constants (copy), color3 (copy)
		local rangeStruct = p7.props.rangeStruct

		if not rangeStruct then
			return nil
		end

		local t1 = {}

		for v40, v41 in rangeStruct.range do
			local v42 = (v40 - 1) / (#rangeStruct.range - 1)

			table.insert(t1, (ColorSequenceKeypoint.new(v42, v41)))
		end

		local colorSequence = ColorSequence.new(t1)

		return Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 0, 0, Constants.BodyColorsSliderTrackHeight),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundColor3 = color3
		}, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			}),
			TrackContent = Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(1, -2, 0, Constants.BodyColorsSliderTrackHeight - 2),
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
		})
	end
end

function v28.render(p8) -- line: 172
	-- upvalues: withStyle (copy)
	return withStyle(function(p9) -- line: 173
		-- upvalues: p8 (copy)
		return p8:renderWithProviders(p9)
	end)
end
function v28.renderWithProviders(p10, p11) -- line: 178
	-- upvalues: FFlagAXMigrateSystemSliderToFoundationSlider (copy), Roact (copy), Constants (copy), v24 (copy), React (copy), Foundation (copy), InputSize (copy), SliderVariant (copy), Visibility (copy), FFlagAXMakeSlidersSmoothWithGamepad (copy), SystemSlider (copy), color3 (copy)
	local Theme = p11.Theme
	local sliderValue = p10.state.sliderValue

	if FFlagAXMigrateSystemSliderToFoundationSlider then
		local tokens = p10.props.tokens
		local rangeStruct = p10.props.rangeStruct

		if not rangeStruct then
			return nil
		end

		local t2 = {}

		for v52, v53 in rangeStruct.range do
			local v54 = (v52 - 1) / (#rangeStruct.range - 1)

			table.insert(t2, (ColorSequenceKeypoint.new(v54, v53)))
		end

		local colorSequence = ColorSequence.new(t2)
		local t3 = {
			Transparency = 0.5,
			Color3 = p10:getCustomKnobColorLower()
		}

		return Roact.createElement("Frame", {
			Size = p10.props.gridAndSidebarFrameSizeBinding:map(function(p12) -- line: 204
				-- upvalues: Constants (copy)
				return UDim2.new(1, -2 * Constants.SkinColorSliderPadding, 0, -p12.Y.Offset)
			end),
			Position = p10.props.gridAndSidebarFrameSizeBinding:map(function(p13) -- line: 207
				-- upvalues: Constants (copy)
				return UDim2.new(0, Constants.SkinColorSliderPadding, 1, p13.Y.Offset)
			end),
			BorderSizePixel = 0,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			[Roact.Ref] = if not v24 then p10.containerRef else nil
		}, {
			Divider1 = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = Theme.Divider.Color,
				BackgroundTransparency = Theme.Divider.Transparency
			}),
			SliderBar = React.createElement(Foundation.View, {
				tag = "auto-y size-full-0 radius-circle stroke-standard stroke-emphasis",
				backgroundStyle = tokens.Color.Extended.White.White_100,
				Position = UDim2.new(0, 0, 0, Constants.BodyColorsSliderFrameHeight / 2),
				containerRef = if not v24 then p10.containerRef else nil
			}, {
				Gradient = React.createElement("UIGradient", {
					Color = colorSequence
				}),
				ColorSlider = React.createElement(Foundation.Slider, {
					isContained = true,
					value = sliderValue,
					range = NumberRange.new(0, 1),
					size = InputSize.Medium,
					variant = SliderVariant.Utility,
					isDisabled = p10.props.disabled,
					knob = React.createElement(Foundation.Knob, {
						hasShadow = true,
						size = InputSize.Medium,
						style = t3,
						stroke = {
							Color = tokens.Color.System.Neutral.Color3,
							Transparency = tokens.Color.System.Neutral.Transparency,
							Thickness = tokens.Stroke.Thick
						}
					}),
					knobVisibility = Visibility.Always,
					onValueChanged = p10.onSliderChanged,
					width = UDim.new(1, 0),
					onDragEnded = p10.onDragEnd,
					ref = p10.props.sliderRef,
					NextSelectionUp = p10.props.NextSelectionUp,
					step = if not FFlagAXMakeSlidersSmoothWithGamepad then nil else 0.01
				})
			})
		})
	end

	return Roact.createElement("Frame", {
		Size = p10.props.gridAndSidebarFrameSizeBinding:map(function(p14) -- line: 260
			-- upvalues: Constants (copy)
			return UDim2.new(1, -2 * Constants.SkinColorSliderPadding, 0, -p14.Y.Offset)
		end),
		Position = p10.props.gridAndSidebarFrameSizeBinding:map(function(p15) -- line: 263
			-- upvalues: Constants (copy)
			return UDim2.new(0, Constants.SkinColorSliderPadding, 1, p15.Y.Offset)
		end),
		BorderSizePixel = 0,
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		[Roact.Ref] = if not v24 then p10.containerRef else nil
	}, {
		Divider1 = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = Theme.Divider.Color,
			BackgroundTransparency = Theme.Divider.Transparency
		}),
		SliderBar = Roact.createElement(SystemSlider, {
			min = 0,
			max = 1,
			stepInterval = 0.01,
			value = sliderValue,
			isDisabled = p10.props.disabled,
			onValueChanged = p10.onSliderChanged,
			onDragEnd = p10.onDragEnd,
			width = UDim.new(1, 0),
			position = UDim2.new(0.5, 0, 0, Constants.BodyColorsSliderFrameHeight / 2),
			anchorPoint = Vector2.new(0.5, 0.5),
			customTrack = p10:renderTrack(),
			customKnobColorLower = p10:getCustomKnobColorLower(),
			customPressedKnobShadowTransparencyLower = 0.5,
			customKnobBorderSize = 1,
			customKnobBorderColor = color3,
			[Roact.Ref] = p10.props.sliderRef,
			NextSelectionUp = p10.props.NextSelectionUp,
			containerRef = if not v24 then p10.containerRef else nil
		})
	})
end
function v28.willUnmount(p16) -- line: 300
	p16.isMounted = false
end

local v29 = RoactServices.connect({
	analytics = Analytics
})(v28)
local u30 = RoactRodux.connect(function(p17, p18) -- line: 308
	-- upvalues: Utils (copy), selectDefaultTryOnBodyColorsToggled (copy), selectButtonSliderValue (copy)
	local AvatarExperience = p17.AvatarExperience
	local defaultBodyColorRanges = p18.defaultBodyColorRanges
	local rangeIdForSelectedBodyParts = p18.rangeIdForSelectedBodyParts

	assert(rangeIdForSelectedBodyParts, "rangeIdForSelectedBodyParts ~= nil.")

	local v63 = Utils.getRangeStructForRangeId(rangeIdForSelectedBodyParts, defaultBodyColorRanges)

	assert(v63, "rangeStruct ~= nil.")

	local v64 = selectDefaultTryOnBodyColorsToggled(p17)
	local v65 = if not v64 then selectButtonSliderValue(AvatarExperience, rangeIdForSelectedBodyParts) else 0.5

	return {
		rangeStruct = v63,
		sliderValue = v65,
		disabled = v64
	}
end, function(p19) -- line: 333
	-- upvalues: SetBodyColor3 (copy)
	return {
		setBodyColor3 = function(p20, p21, p22, p23) -- line: 335
			-- upvalues: p19 (copy), SetBodyColor3 (copy)
			p19(SetBodyColor3(p20, p21, p22, p23))
		end
	}
end)(v29)

return function(p24) -- line: 343
	-- upvalues: useBodyDataCallbacksContext (copy), Cryo (copy), FFlagAXMigrateSystemSliderToFoundationSlider (copy), useTokens (copy), React (copy), u30 (ref)
	local v68 = useBodyDataCallbacksContext()
	local v69 = Cryo.Dictionary.join(v68, p24)

	if FFlagAXMigrateSystemSliderToFoundationSlider then
		local v70 = useTokens()

		v69 = Cryo.Dictionary.join({
			tokens = v70
		}, v69)
	end

	return React.createElement(u30, v69)
end
