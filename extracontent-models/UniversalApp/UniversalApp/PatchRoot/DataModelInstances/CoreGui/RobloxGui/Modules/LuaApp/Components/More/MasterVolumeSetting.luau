local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local SoundManager = require(CorePackages.Workspace.Packages.SoundManager).SoundManager
local Sounds = require(CorePackages.Workspace.Packages.SoundManager).Sounds
local SoundGroups = require(CorePackages.Workspace.Packages.SoundManager).SoundGroups
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local Constants = require(Modules.LuaApp.Constants)
local DeviceSettingsPageSetting = require(Modules.LuaApp.Components.More.DeviceSettings.DeviceSettingsPageSetting)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Slider = Foundation.Slider
local GetFFlagEnableVolumeSliderQOLFix = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableVolumeSliderQOLFix

local function MasterVolumeSetting(t1: {[any]: any}) -- line: 34
	-- upvalues: React (copy), UserGameSettings (copy), useStyle (copy), useLocalization (copy), FormFactor (copy), GetFFlagEnableVolumeSliderQOLFix (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy), DeviceSettingsPageSetting (copy), Constants (copy), Slider (copy), Foundation (copy)
	local v20, v21 = React.useState(UserGameSettings.MasterVolume)
	local v22 = useStyle()
	local v23 = useLocalization({
		volumeSliderDescription = "Application.Settings.VolumeSliderDescription",
		volumeHeader = "CoreScripts.InGameMenu.GameSettings.Volume"
	})
	local v24 = t1.formFactor == FormFactor.WIDE
	local v25 = v22.Font.BaseSize * v22.Font.CaptionBody.RelativeSize
	local CaptionBodyFont = v22.Font.CaptionBody.Font
	local v27 = v22.Tokens.Stroke.Standard * 310
	local v28 = React.useCallback(function(n1: number) -- line: 49
		-- upvalues: UserGameSettings (copy)
		UserGameSettings.MasterVolume = n1 / 10
	end, {})
	local v29 = nil

	if GetFFlagEnableVolumeSliderQOLFix then
		v29 = React.useCallback(function() -- line: 56
			-- upvalues: SoundManager (copy), Sounds (copy), SoundGroups (copy)
			SoundManager:PlaySound(Sounds.Select.Name, {}, SoundGroups.AppBackground)
		end, {})
	end

	React.useEffect(function() -- line: 61
		-- upvalues: UserGameSettings (copy), v21 (copy), GetFFlagEnableVolumeSliderQOLFix (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy)
		local connection = UserGameSettings:GetPropertyChangedSignal("MasterVolume"):Connect(function() -- line: 62
			-- upvalues: UserGameSettings (copy), v21 (copy), GetFFlagEnableVolumeSliderQOLFix (copy), SoundManager (copy), Sounds (copy), SoundGroups (copy)
			local MasterVolume = UserGameSettings.MasterVolume

			v21(MasterVolume)

			if not GetFFlagEnableVolumeSliderQOLFix() then
				SoundManager:PlaySound(Sounds.VolumeTest.Name, {}, SoundGroups.AppBackground)
			end
		end)

		return function() -- line: 69
			-- upvalues: connection (copy)
			if connection then
				connection:Disconnect()
			end
		end
	end)

	return React.createElement(DeviceSettingsPageSetting, {
		style = v22,
		header = v23.volumeHeader,
		description = v23.volumeSliderDescription,
		layoutOrder = t1.layoutOrder,
		topToBottom = not v24,
		Control = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = if not v24 then UDim2.fromScale(1, 0) else UDim2.new(0, v27, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.Name,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, Constants.MORE_PAGE_SECTION_PADDING)
			}),
			ContextualVolumeSlider = React.createElement(Slider, {
				step = 1,
				width = UDim.new(1, 0),
				range = NumberRange.new(0, 10),
				value = math.clamp(v20 * 10, 0, 10),
				size = Foundation.Enums.InputSize.Large,
				knobVisibility = Foundation.Enums.ScrollBarVisibility.Always,
				variant = Foundation.Enums.SliderVariant.Emphasis,
				onValueChanged = v28,
				onDragEnded = v29
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
					TextSize = v25,
					TextColor3 = v22.Theme.TextMuted.Color,
					TextTransparency = v22.Theme.TextMuted.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				RightText = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 2,
					Size = UDim2.fromScale(1, 0),
					Text = tostring(10),
					Font = CaptionBodyFont,
					TextSize = v25,
					TextColor3 = v22.Theme.TextMuted.Color,
					TextTransparency = v22.Theme.TextMuted.Transparency,
					TextXAlignment = Enum.TextXAlignment.Right
				})
			})
		})
	})
end

return (RoactRodux.connect(function(p1, _) -- line: 142
	return {
		formFactor = p1.FormFactor
	}
end)(MasterVolumeSetting))
