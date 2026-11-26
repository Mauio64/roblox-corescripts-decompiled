local CorePackages = game:GetService("CorePackages")

local UserGameSettings = UserSettings():GetService("UserGameSettings")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local inputSize = Foundation.Enums.InputSize
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local module = require("@luauforge/deferred/fGx")
local module2 = require("@luauforge/bundled/fGw")
local fFlagEnableSettingsTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSettingsTelemetry

local toggle = Foundation.Toggle

local function HapticsToggle(p2)
	local state, setState = React.useState(UserGameSettings.HapticStrength)
	local v5 = useStyle()
	local v6 = useLocalization({
		hapticToggleDescription = "Feature.Accessibility.Description.Haptics",
		hapticHeader = "Feature.Accessibility.Header.Haptics"
	})

	local v7 = React.useCallback(function()
		if not fFlagEnableSettingsTelemetry then
			UserGameSettings.HapticStrength = UserGameSettings.HapticStrength == 1 and 0 or 1

			return
		end

		local hapticStrength = UserGameSettings.HapticStrength
		local v8 = hapticStrength == 1 and 0 or 1
		UserGameSettings.HapticStrength = v8
		module2.reportSettingToggle("Haptics", hapticStrength, v8)
	end, {})

	React.useEffect(function()
		local hapticStrengthChangedConnection = UserGameSettings:GetPropertyChangedSignal("HapticStrength"):Connect(function()
			setState(UserGameSettings.HapticStrength)
		end)
		return function()
			if hapticStrengthChangedConnection then
				hapticStrengthChangedConnection:Disconnect()
			end
		end
	end)

	return React.createElement(module, {
		style = v5,
		header = v6.hapticHeader,
		description = v6.hapticToggleDescription,
		layoutOrder = p2.layoutOrder,
		Control = React.createElement(toggle, {
			isChecked = state ~= 0,
			onActivated = v7,
			label = "",
			size = inputSize.Large
		})
	})
end

return HapticsToggle
