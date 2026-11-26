local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local module = require("@luauforge/bundled/dzD")
local module2 = require("@luauforge/deferred/fGx")
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local contextualSlider = UIBlox.App.Slider.ContextualSlider
local fFlagUnifyConsoleSettingsPage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUnifyConsoleSettingsPage

local function VolumeSettings(props)
	local v5 = useStyle()
	local v6 = useLocalization({
		volumeSliderDescription = props.volumeSliderDescriptionKey,
		volumeHeader = props.volumeHeaderKey
	})

	local v7 = props.formFactor == formFactor.WIDE
	local v8 = v5.Font.BaseSize * v5.Font.CaptionBody.RelativeSize
	local v9 = v5.Tokens.Stroke.Standard * 310

	local createElement = React.createElement
	local v11 = {
		style = v5,
		header = v6.volumeHeader,
		description = v6.volumeSliderDescription,
		layoutOrder = props.layoutOrder,
		topToBottom = not v7,
		Control = 0
	}

	local createElement2 = React.createElement
	local v14 = if v7 then UDim2.new(0, v9, 0, 0) else UDim2.fromScale(1, 0)
	local v13 = {
		Size = v14,
		AutomaticSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}

	local v15 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.Name,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, module.MORE_PAGE_SECTION_PADDING)
		}),
		ContextualSlider = 0,
		Frame = 0
	}

	local v16 = if props.value ~= nil then React.createElement(contextualSlider, {
		width = UDim.new(1, 0),
		stepInterval = 1,
		min = 0,
		max = 10,
		containerRef = props.sliderGuiObjectRef,
		value = math.clamp(props.value * 10, 0, 10),
		onValueChanged = props.onValueChanged
	}) else nil
	v15.ContextualSlider = v16

	v15.Frame = React.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			BackgroundTransparency = 1
		},
		{
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, fFlagUnifyConsoleSettingsPage and 0 or -10)
			}),
			LeftText = React.createElement("TextLabel", {
				Size = UDim2.fromScale(1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = tostring(0),
				FontFace = normalizeFontFace(v5.Tokens.Typography.BodySmall.Font),
				TextSize = v8,
				TextColor3 = v5.Theme.TextMuted.Color,
				TextTransparency = v5.Theme.TextMuted.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1
			}),
			RightText = React.createElement("TextLabel", {
				Size = UDim2.fromScale(1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = tostring(10),
				FontFace = normalizeFontFace(v5.Tokens.Typography.BodySmall.Font),
				TextSize = v8,
				TextColor3 = v5.Theme.TextMuted.Color,
				TextTransparency = v5.Theme.TextMuted.Transparency,
				TextXAlignment = Enum.TextXAlignment.Right,
				LayoutOrder = 2
			})
		}
	)
	v11.Control = createElement2("Frame", v13, v15)
	return createElement(module2, v11)
end

return (RoactRodux.connect(function(p2, p3)
	return { formFactor = p2.FormFactor }
end)(VolumeSettings))
