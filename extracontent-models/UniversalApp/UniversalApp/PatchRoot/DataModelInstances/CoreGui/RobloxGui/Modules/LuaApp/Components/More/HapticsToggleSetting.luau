local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local InputSize = Foundation.Enums.InputSize
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local DeviceSettingsPageSetting = require(Modules.LuaApp.Components.More.DeviceSettings.DeviceSettingsPageSetting)
local Toggle = Foundation.Toggle

local function HapticsToggle(t1: {[any]: any}) -- line: 18
	-- upvalues: React (copy), UserGameSettings (copy), useStyle (copy), useLocalization (copy), DeviceSettingsPageSetting (copy), Toggle (copy), InputSize (copy)
	local v14, v15 = React.useState(UserGameSettings.HapticStrength)
	local v16 = useStyle()
	local v17 = useLocalization({
		hapticToggleDescription = "Feature.Accessibility.Description.Haptics",
		hapticHeader = "Feature.Accessibility.Header.Haptics"
	})
	local v18 = React.useCallback(function() -- line: 26
		-- upvalues: UserGameSettings (copy)
		UserGameSettings.HapticStrength = UserGameSettings.HapticStrength ~= 1 and 1 or 0
	end, {})

	React.useEffect(function() -- line: 31
		-- upvalues: UserGameSettings (copy), v15 (copy)
		local connection = UserGameSettings:GetPropertyChangedSignal("HapticStrength"):Connect(function() -- line: 33
			-- upvalues: v15 (copy), UserGameSettings (copy)
			v15(UserGameSettings.HapticStrength)
		end)

		return function() -- line: 36
			-- upvalues: connection (copy)
			if connection then
				connection:Disconnect()
			end
		end
	end)

	return React.createElement(DeviceSettingsPageSetting, {
		style = v16,
		header = v17.hapticHeader,
		description = v17.hapticToggleDescription,
		layoutOrder = t1.layoutOrder,
		Control = React.createElement(Toggle, {
			label = "",
			isChecked = v14 ~= 0,
			onActivated = v18,
			size = InputSize.Large
		})
	})
end

return HapticsToggle
