local UserGameSettings = UserSettings():GetService("UserGameSettings")

local actions = script:FindFirstAncestor("ExpChat").Actions
local ClientSettingsLoaded = require(actions.ClientSettingsLoaded)
local ClientSettingsChanged = require(actions.ClientSettingsChanged)

return function(object)
	object:dispatch(ClientSettingsLoaded({
		preferredTransparency = UserGameSettings.PreferredTransparency
	}))

	UserGameSettings:GetPropertyChangedSignal("PreferredTransparency"):Connect(function()
		object:dispatch(ClientSettingsChanged("preferredTransparency", UserGameSettings.PreferredTransparency))
	end)
end
