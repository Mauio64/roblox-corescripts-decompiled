local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local module = require("@luauforge/bundled/dwA")
local module2 = require("@luauforge/deferred/fyH")
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
	local font = v5.Font.CaptionBody.Font
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

	local createElement3 = React.createElement
	local v18 = {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}

	local children = {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, fFlagUnifyConsoleSettingsPage and 0 or -10)
		}),
		LeftText = 0,
		RightText = 0
	}

	local createElement4 = React.createElement
	local v20 = {
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = tostring(0),
		Font = if not foundationFontFaceMigration then font else nil,
		FontFace = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextXAlignment = 0,
		LayoutOrder = 1
	}

	local v22 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.BodySmall.Font) else nil
	v20.FontFace = v22

	v20.TextSize = v8
	v20.TextColor3 = v5.Theme.TextMuted.Color
	v20.TextTransparency = v5.Theme.TextMuted.Transparency
	v20.TextXAlignment = Enum.TextXAlignment.Left
	children.LeftText = createElement4("TextLabel", v20)

	local createElement5 = React.createElement
	local v24 = {
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = tostring(10),
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextXAlignment = 0,
		LayoutOrder = 2
	}

	if foundationFontFaceMigration then
		font = nil
	end

	v24.Font = font

	local v25 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.BodySmall.Font) else nil
	v24.FontFace = v25

	v24.TextSize = v8
	v24.TextColor3 = v5.Theme.TextMuted.Color
	v24.TextTransparency = v5.Theme.TextMuted.Transparency
	v24.TextXAlignment = Enum.TextXAlignment.Right
	children.RightText = createElement5("TextLabel", v24)
	v15.Frame = createElement3("Frame", v18, children)
	v11.Control = createElement2("Frame", v13, v15)
	return createElement(module2, v11)
end

return (RoactRodux.connect(function(p2, p3)
	return { formFactor = p2.FormFactor }
end)(VolumeSettings))
