local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local Constants = require(Modules.LuaApp.Constants)
local DeviceSettingsPageSetting = require(Modules.LuaApp.Components.More.DeviceSettings.DeviceSettingsPageSetting)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ContextualSlider = UIBlox.App.Slider.ContextualSlider

local function VolumeSettings(t1: {[any]: any}) -- line: 30
	-- upvalues: useStyle (copy), useLocalization (copy), FormFactor (copy), React (copy), DeviceSettingsPageSetting (copy), Constants (copy), ContextualSlider (copy)
	local v14 = useStyle()
	local v15 = useLocalization({
		volumeSliderDescription = t1.volumeSliderDescriptionKey,
		volumeHeader = t1.volumeHeaderKey
	})
	local v16 = t1.formFactor == FormFactor.WIDE
	local v17 = v14.Font.BaseSize * v14.Font.CaptionBody.RelativeSize
	local CaptionBodyFont = v14.Font.CaptionBody.Font
	local v19 = v14.Tokens.Stroke.Standard * 310

	return React.createElement(DeviceSettingsPageSetting, {
		style = v14,
		header = v15.volumeHeader,
		description = v15.volumeSliderDescription,
		layoutOrder = t1.layoutOrder,
		topToBottom = not v16,
		Control = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = if not v16 then UDim2.fromScale(1, 0) else UDim2.new(0, v19, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.Name,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, Constants.MORE_PAGE_SECTION_PADDING)
			}),
			ContextualSlider = if t1.value == nil then nil else React.createElement(ContextualSlider, {
				stepInterval = 1,
				min = 0,
				max = 10,
				width = UDim.new(1, 0),
				containerRef = t1.sliderGuiObjectRef,
				value = math.clamp(t1.value * 10, 0, 10),
				onValueChanged = t1.onValueChanged
			}),
			Frame = React.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, -10)
				}),
				LeftText = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					Size = UDim2.fromScale(1, 0),
					Text = tostring(0),
					Font = CaptionBodyFont,
					TextSize = v17,
					TextColor3 = v14.Theme.TextMuted.Color,
					TextTransparency = v14.Theme.TextMuted.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				RightText = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 2,
					Size = UDim2.fromScale(1, 0),
					Text = tostring(10),
					Font = CaptionBodyFont,
					TextSize = v17,
					TextColor3 = v14.Theme.TextMuted.Color,
					TextTransparency = v14.Theme.TextMuted.Transparency,
					TextXAlignment = Enum.TextXAlignment.Right
				})
			})
		})
	})
end

return (RoactRodux.connect(function(p1, _) -- line: 110
	return {
		formFactor = p1.FormFactor
	}
end)(VolumeSettings))
