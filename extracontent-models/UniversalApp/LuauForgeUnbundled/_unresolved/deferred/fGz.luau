local CorePackages = game:GetService("CorePackages")

local UserGameSettings = UserSettings():GetService("UserGameSettings")
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local soundManager = require("@luauforge/bundled/fGA").SoundManager
local sounds = require("@luauforge/bundled/fGA").Sounds
local soundGroups = require("@luauforge/bundled/fGA").SoundGroups
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local module = require("@luauforge/bundled/dzD")
local module2 = require("@luauforge/deferred/fGx")
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local slider = Foundation.Slider

local getFFlagEnableVolumeSliderQOLFix = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableVolumeSliderQOLFix
local fFlagUnifyConsoleSettingsPage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUnifyConsoleSettingsPage

local module3 = require("@luauforge/deferred/fGB")

local function MasterVolumeSetting(p2)
	local state, setState = React.useState(UserGameSettings.MasterVolume)
	local v5 = useStyle()
	local v6 = useLocalization({
		volumeSliderDescription = "Application.Settings.VolumeSliderDescription",
		volumeHeader = "CoreScripts.InGameMenu.GameSettings.Volume"
	})

	local v7 = p2.formFactor == formFactor.WIDE
	local v8 = v5.Font.BaseSize * v5.Font.CaptionBody.RelativeSize
	local v9 = v5.Tokens.Stroke.Standard * 310

	local v10 = React.useCallback(function(p3)
		UserGameSettings.MasterVolume = p3 / 10
	end, {})
	local v11

	if getFFlagEnableVolumeSliderQOLFix then
		v11 = React.useCallback(function()
			soundManager:PlaySound(sounds.Select.Name, {}, soundGroups.AppBackground)
		end, {})
	end

	React.useEffect(function()
		local masterVolumeChangedConnection = UserGameSettings:GetPropertyChangedSignal("MasterVolume"):Connect(function()
			setState(UserGameSettings.MasterVolume)

			if not getFFlagEnableVolumeSliderQOLFix() then
				soundManager:PlaySound(sounds.VolumeTest.Name, {}, soundGroups.AppBackground)
			end
		end)
		return function()
			if masterVolumeChangedConnection then
				masterVolumeChangedConnection:Disconnect()
			end
		end
	end)

	local createElement = React.createElement
	local v13 = {
		style = v5,
		header = v6.volumeHeader,
		description = v6.volumeSliderDescription,
		layoutOrder = p2.layoutOrder,
		topToBottom = not v7,
		Control = 0
	}

	local createElement2 = React.createElement
	local v16 = if v7 then UDim2.new(0, v9, 0, 0) else UDim2.fromScale(1, 0)
	local v15 = {
		Size = v16,
		AutomaticSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}

	local children = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.Name,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, module.MORE_PAGE_SECTION_PADDING)
		}),
		ContextualVolumeSlider = 0,
		Frame = 0
	}

	local createElement3 = React.createElement
	local v18 = {
		width = UDim.new(1, 0),
		step = 1,
		range = NumberRange.new(0, 10),
		value = math.clamp(state * 10, 0, 10),
		size = Foundation.Enums.InputSize.Large,
		knobVisibility = Foundation.Enums.ScrollBarVisibility.Always,
		variant = 0,
		onValueChanged = 0,
		onDragEnded = 0
	}

	local v19 = if module3 then Foundation.Enums.SliderVariant.Standard else Foundation.Enums.SliderVariant.Emphasis
	v18.variant = v19

	v18.onValueChanged = v10
	v18.onDragEnded = v11
	children.ContextualVolumeSlider = createElement3(slider, v18)

	children.Frame = React.createElement(
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
	v13.Control = createElement2("Frame", v15, children)
	return createElement(module2, v13)
end

return (RoactRodux.connect(function(p2, p3)
	return { formFactor = p2.FormFactor }
end)(MasterVolumeSetting))
