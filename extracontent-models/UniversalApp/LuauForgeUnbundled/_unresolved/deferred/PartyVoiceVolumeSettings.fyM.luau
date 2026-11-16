local CorePackages = game:GetService("CorePackages")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/fyN")

local function PartyVoiceVolumeSettings(props)
	local state, setState = React.useState(UserGameSettings.PartyVoiceVolume)

	local v5 = React.useCallback(function(p2)
		UserGameSettings.PartyVoiceVolume = p2 / 10
	end, {})

	React.useEffect(function()
		local partyVoiceVolumeChangedConnection = UserGameSettings:GetPropertyChangedSignal("PartyVoiceVolume"):Connect(function()
			setState(UserGameSettings.PartyVoiceVolume)
		end)
		return function()
			if partyVoiceVolumeChangedConnection then
				partyVoiceVolumeChangedConnection:Disconnect()
			end
		end
	end)

	return React.createElement(module, {
		formFactor = props.formFactor,
		layoutOrder = props.layoutOrder,
		sliderGuiObjectRef = props.sliderGuiObjectRef,
		value = state,
		onValueChanged = v5,
		volumeHeaderKey = "CoreScripts.InGameMenu.GameSettings.PartyVoiceVolume",
		volumeSliderDescriptionKey = "Application.Settings.PartyVoiceVolumeSliderDescription"
	})
end

return PartyVoiceVolumeSettings
