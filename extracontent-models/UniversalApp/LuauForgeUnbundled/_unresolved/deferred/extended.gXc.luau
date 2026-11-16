local CorePackages = game:GetService("CorePackages")

local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local module = require("@luauforge/bundled/dCn")

local focusable = RoactGamepad.Focusable
local withStyle = UIBlox.Style.withStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local systemSlider = UIBlox.App.Slider.SystemSlider

local fFlagAXMigrateSystemSliderToFoundationSlider = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXMigrateSystemSliderToFoundationSlider
local fFlagAXMakeSlidersSmoothWithGamepad = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMakeSlidersSmoothWithGamepad

local extended = Roact.PureComponent:extend("SliderWithLabelAndIcons")

extended.validateProps = t.strictInterface({
	layoutOrder = t.number,
	text = t.string,
	leftIcon = t.table,
	rightIcon = t.table,
	value = t.number,
	onSliderChanged = t.callback,
	min = t.number,
	max = t.number,
	baseRef = t.table,
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table)
})

function extended:init()
	self.sliderRef = Roact.createRef()

	if fFlagAXMigrateSystemSliderToFoundationSlider then
		function self.convertPositionValueToSliderValue(p3, p4, p5)
			if p5 <= p4 then
				module("SliderWithLabelAndIcons.lua convertPositionValueToSliderValue argument error: posMaxVal must be greater than posMinVal.")

				return 0.5
			end

			return (p3 - p4) / (p5 - p4)
		end

		function self.convertSliderValueToPositionValue(p3, p4, p5)
			return p3 * (p5 - p4) + p4
		end
	end
end

function extended.render(data)
	return withStyle(function(props)
		local font = props.Font
		local baseSize = font.BaseSize
		local v5 = font.CaptionHeader.RelativeSize * baseSize
		local font2 = font.CaptionHeader.Font
		local v6 = 50 - v5

		if fFlagAXMigrateSystemSliderToFoundationSlider then
			local createElement = Roact.createElement
			local v8 = {
				Size = UDim2.new(0.9, 0, 0, 50),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = data.props.layoutOrder
			}

			local createElement2 = Roact.createElement
			local v10 = {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v5)
			}

			local createElement3 = Roact.createElement
			local v13 = {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Text = data.props.text,
				Size = UDim2.new(1, -2 * v6, 1, 0),
				Position = UDim2.fromOffset(v6, 0),
				TextColor3 = props.Theme.TextEmphasis.Color,
				Font = 0,
				FontFace = 0,
				TextSize = 0,
				TextXAlignment = 0
			}

			if foundationFontFaceMigration then
				font2 = nil
			end

			v13.Font = font2

			local v14 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font) else nil
			v13.FontFace = v14

			v13.TextSize = v5
			v13.TextXAlignment = Enum.TextXAlignment.Left
			return createElement("Frame", v8, {
				TopFrame = createElement2("Frame", v10, {
					SliderLabel = createElement3("TextLabel", v13)
				}),
				BottomFrame = Roact.createElement(
					"Frame",
					{
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v6),
						Position = UDim2.fromOffset(0, v5)
					},
					{
						LeftIcon = Roact.createElement(imageSetLabel, {
							BackgroundTransparency = 1,
							Image = data.props.leftIcon,
							Size = UDim2.fromOffset(v6, v6),
							Position = UDim2.fromOffset(0, 0),
							ImageColor3 = props.Theme.TextEmphasis.Color
						}),
						SliderBar = Roact.createElement(Foundation.Slider, {
							range = NumberRange.new(0, 1),
							value = data.convertPositionValueToSliderValue(
								data.props.value,
								data.props.min,
								data.props.max
							),
							onValueChanged = function(p2)
								local convertSliderValueToPositionValue = data.convertSliderValueToPositionValue(
									p2,
									data.props.min,
									data.props.max
								)
								data.props.onSliderChanged(convertSliderValueToPositionValue)
							end,
							width = UDim.new(1, -2 * v6),
							Position = UDim2.new(0, v6, 0, 4),
							anchorPoint = Vector2.new(0, 0.5),
							NextSelectionUp = data.props.NextSelectionUp,
							NextSelectionDown = data.props.NextSelectionDown,
							[Roact.Ref] = data.props.baseRef,
							step = fFlagAXMakeSlidersSmoothWithGamepad and 0.01 or nil
						}),
						RightIcon = Roact.createElement(imageSetLabel, {
							BackgroundTransparency = 1,
							Image = data.props.rightIcon,
							AnchorPoint = Vector2.new(1, 0),
							Size = UDim2.fromOffset(v6, v6),
							Position = UDim2.fromScale(1, 0),
							ImageColor3 = props.Theme.TextEmphasis.Color
						})
					}
				)
			})
		else
			local createElement = Roact.createElement
			local frame = focusable.Frame
			local baseRefsByRef = {
				Size = UDim2.new(0.9, 0, 0, 50),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = data.props.layoutOrder,
				defaultChild = data.sliderRef,
				[Roact.Ref] = data.props.baseRef
			}

			local createElement2 = Roact.createElement
			local v8 = {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v5)
			}

			local createElement3 = Roact.createElement
			local v11 = {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Text = data.props.text,
				Size = UDim2.new(1, -2 * v6, 1, 0),
				Position = UDim2.fromOffset(v6, 0),
				TextColor3 = props.Theme.TextEmphasis.Color,
				Font = 0,
				FontFace = 0,
				TextSize = 0,
				TextXAlignment = 0
			}

			if foundationFontFaceMigration then
				font2 = nil
			end

			v11.Font = font2

			local v12 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font) else nil
			v11.FontFace = v12

			v11.TextSize = v5
			v11.TextXAlignment = Enum.TextXAlignment.Left
			return createElement(frame, baseRefsByRef, {
				TopFrame = createElement2("Frame", v8, {
					SliderLabel = createElement3("TextLabel", v11)
				}),
				BottomFrame = Roact.createElement(
					"Frame",
					{
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v6),
						Position = UDim2.fromOffset(0, v5)
					},
					{
						LeftIcon = Roact.createElement(imageSetLabel, {
							BackgroundTransparency = 1,
							Image = data.props.leftIcon,
							Size = UDim2.fromOffset(v6, v6),
							Position = UDim2.fromOffset(0, 0),
							ImageColor3 = props.Theme.TextEmphasis.Color
						}),
						SliderBar = Roact.createElement(systemSlider, {
							min = data.props.min,
							max = data.props.max,
							stepInterval = 1,
							value = data.props.value,
							onValueChanged = data.props.onSliderChanged,
							width = UDim.new(1, -2 * v6),
							position = UDim2.new(0, v6, 0.5, 0),
							anchorPoint = Vector2.new(0, 0.5),
							NextSelectionUp = data.props.NextSelectionUp,
							NextSelectionDown = data.props.NextSelectionDown,
							[Roact.Ref] = data.sliderRef
						}),
						RightIcon = Roact.createElement(imageSetLabel, {
							BackgroundTransparency = 1,
							Image = data.props.rightIcon,
							AnchorPoint = Vector2.new(1, 0),
							Size = UDim2.fromOffset(v6, v6),
							Position = UDim2.fromScale(1, 0),
							ImageColor3 = props.Theme.TextEmphasis.Color
						})
					}
				)
			})
		end
	end)
end

return extended
