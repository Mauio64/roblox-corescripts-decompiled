local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Foundation = require(CorePackages.Packages.Foundation)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local mutedError = require(Modules.LuaApp.mutedError)
local Focusable = RoactGamepad.Focusable
local withStyle = UIBlox.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local SystemSlider = UIBlox.App.Slider.SystemSlider
local FFlagAXMigrateSystemSliderToFoundationSlider = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateSystemSliderToFoundationSlider
local FFlagAXMakeSlidersSmoothWithGamepad = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMakeSlidersSmoothWithGamepad
local v15 = Roact.PureComponent:extend("SliderWithLabelAndIcons")

v15.validateProps = t.strictInterface({
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

function v15.init(p1) -- line: 44
	-- upvalues: Roact (copy), FFlagAXMigrateSystemSliderToFoundationSlider (copy), mutedError (copy)
	p1.sliderRef = Roact.createRef()

	if FFlagAXMigrateSystemSliderToFoundationSlider then
		function p1.convertPositionValueToSliderValue(n1: number, n2: number, n3: number) -- line: 48
			-- upvalues: mutedError (copy)
			if n3 <= n2 then
				mutedError("SliderWithLabelAndIcons.lua convertPositionValueToSliderValue argument error: posMaxVal must be greater than posMinVal.")

				return 0.5
			end

			return (n1 - n2) / (n3 - n2)
		end
		function p1.convertSliderValueToPositionValue(n4: number, n5: number, n6: number) -- line: 58
			return n4 * (n6 - n5) + n5
		end
	end
end
function v15.render(p2) -- line: 64
	-- upvalues: withStyle (copy), FFlagAXMigrateSystemSliderToFoundationSlider (copy), Roact (copy), ImageSetLabel (copy), Foundation (copy), FFlagAXMakeSlidersSmoothWithGamepad (copy), Focusable (copy), SystemSlider (copy)
	return withStyle(function(p3) -- line: 65
		-- upvalues: FFlagAXMigrateSystemSliderToFoundationSlider (copy), Roact (copy), p2 (copy), ImageSetLabel (copy), Foundation (copy), FFlagAXMakeSlidersSmoothWithGamepad (copy), Focusable (copy), SystemSlider (copy)
		local p3Font = p3.Font
		local BaseSize = p3Font.BaseSize
		local v27 = p3Font.CaptionHeader.RelativeSize * BaseSize
		local CaptionHeaderFont = p3Font.CaptionHeader.Font
		local v29 = 50 - v27

		if FFlagAXMigrateSystemSliderToFoundationSlider then
			return Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(0.9, 0, 0, 50),
				LayoutOrder = p2.props.layoutOrder
			}, {
				TopFrame = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, v27)
				}, {
					SliderLabel = Roact.createElement("TextLabel", {
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						Text = p2.props.text,
						Size = UDim2.new(1, -2 * v29, 1, 0),
						Position = UDim2.fromOffset(v29, 0),
						TextColor3 = p3.Theme.TextEmphasis.Color,
						Font = CaptionHeaderFont,
						TextSize = v27,
						TextXAlignment = Enum.TextXAlignment.Left
					})
				}),
				BottomFrame = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, v29),
					Position = UDim2.fromOffset(0, v27)
				}, {
					LeftIcon = Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						Image = p2.props.leftIcon,
						Size = UDim2.fromOffset(v29, v29),
						Position = UDim2.fromOffset(0, 0),
						ImageColor3 = p3.Theme.TextEmphasis.Color
					}),
					SliderBar = Roact.createElement(Foundation.Slider, {
						range = NumberRange.new(0, 1),
						value = p2.convertPositionValueToSliderValue(p2.props.value, p2.props.min, p2.props.max),
						onValueChanged = function(n7: number) -- line: 116
							-- upvalues: p2 (copy)
							local v31 = p2.convertSliderValueToPositionValue(n7, p2.props.min, p2.props.max)

							p2.props.onSliderChanged(v31)
						end,
						width = UDim.new(1, -2 * v29),
						Position = UDim2.new(0, v29, 0, 4),
						anchorPoint = Vector2.new(0, 0.5),
						NextSelectionUp = p2.props.NextSelectionUp,
						NextSelectionDown = p2.props.NextSelectionDown,
						[Roact.Ref] = p2.props.baseRef,
						step = if not FFlagAXMakeSlidersSmoothWithGamepad then nil else 0.01
					}),
					RightIcon = Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						Image = p2.props.rightIcon,
						AnchorPoint = Vector2.new(1, 0),
						Size = UDim2.fromOffset(v29, v29),
						Position = UDim2.fromScale(1, 0),
						ImageColor3 = p3.Theme.TextEmphasis.Color
					})
				})
			})
		end

		return Roact.createElement(Focusable.Frame, {
			Size = UDim2.new(0.9, 0, 0, 50),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = p2.props.layoutOrder,
			defaultChild = p2.sliderRef,
			[Roact.Ref] = p2.props.baseRef
		}, {
			TopFrame = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v27)
			}, {
				SliderLabel = Roact.createElement("TextLabel", {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Text = p2.props.text,
					Size = UDim2.new(1, -2 * v29, 1, 0),
					Position = UDim2.fromOffset(v29, 0),
					TextColor3 = p3.Theme.TextEmphasis.Color,
					Font = CaptionHeaderFont,
					TextSize = v27,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			}),
			BottomFrame = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v29),
				Position = UDim2.fromOffset(0, v27)
			}, {
				LeftIcon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = p2.props.leftIcon,
					Size = UDim2.fromOffset(v29, v29),
					Position = UDim2.fromOffset(0, 0),
					ImageColor3 = p3.Theme.TextEmphasis.Color
				}),
				SliderBar = Roact.createElement(SystemSlider, {
					min = p2.props.min,
					max = p2.props.max,
					stepInterval = 1,
					value = p2.props.value,
					onValueChanged = p2.props.onSliderChanged,
					width = UDim.new(1, -2 * v29),
					position = UDim2.new(0, v29, 0.5, 0),
					anchorPoint = Vector2.new(0, 0.5),
					NextSelectionUp = p2.props.NextSelectionUp,
					NextSelectionDown = p2.props.NextSelectionDown,
					[Roact.Ref] = p2.sliderRef
				}),
				RightIcon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = p2.props.rightIcon,
					AnchorPoint = Vector2.new(1, 0),
					Size = UDim2.fromOffset(v29, v29),
					Position = UDim2.fromScale(1, 0),
					ImageColor3 = p3.Theme.TextEmphasis.Color
				})
			})
		})
	end)
end

return v15
