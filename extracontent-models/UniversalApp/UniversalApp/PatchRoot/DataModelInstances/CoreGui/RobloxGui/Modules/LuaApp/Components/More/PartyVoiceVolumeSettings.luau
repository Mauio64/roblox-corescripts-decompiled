local CorePackages = game:GetService("CorePackages")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local React = require(CorePackages.Packages.React)
local VolumeSettings = require(script.Parent.VolumeSettings)

local function PartyVoiceVolumeSettings(t1: {[any]: any}) -- line: 15
	-- upvalues: React (copy), UserGameSettings (copy), VolumeSettings (copy)
	local v7, v8 = React.useState(UserGameSettings.PartyVoiceVolume)
	local v9 = React.useCallback(function(n1: number) -- line: 18
		-- upvalues: UserGameSettings (copy)
		UserGameSettings.PartyVoiceVolume = n1 / 10
	end, {})

	React.useEffect(function() -- line: 23
		-- upvalues: UserGameSettings (copy), v8 (copy)
		local connection = UserGameSettings:GetPropertyChangedSignal("PartyVoiceVolume"):Connect(function() -- line: 25
			-- upvalues: v8 (copy), UserGameSettings (copy)
			v8(UserGameSettings.PartyVoiceVolume)
		end)

		return function() -- line: 28
			-- upvalues: connection (copy)
			if connection then
				connection:Disconnect()
			end
		end
	end)

	return React.createElement(VolumeSettings, {
		volumeHeaderKey = "CoreScripts.InGameMenu.GameSettings.PartyVoiceVolume",
		volumeSliderDescriptionKey = "Application.Settings.PartyVoiceVolumeSliderDescription",
		formFactor = t1.formFactor,
		layoutOrder = t1.layoutOrder,
		sliderGuiObjectRef = t1.sliderGuiObjectRef,
		value = v7,
		onValueChanged = v9
	})
end

return PartyVoiceVolumeSettings
