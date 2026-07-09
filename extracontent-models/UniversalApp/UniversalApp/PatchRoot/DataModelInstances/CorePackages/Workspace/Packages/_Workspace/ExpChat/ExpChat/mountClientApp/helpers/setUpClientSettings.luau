local UserGameSettings = UserSettings():GetService("UserGameSettings")
local Actions = script:FindFirstAncestor("ExpChat").Actions
local ClientSettingsLoaded = require(Actions.ClientSettingsLoaded)
local ClientSettingsChanged = require(Actions.ClientSettingsChanged)

return function(p1) -- line: 9
	-- upvalues: ClientSettingsLoaded (copy), UserGameSettings (copy), ClientSettingsChanged (copy)
	p1:dispatch(ClientSettingsLoaded({
		preferredTransparency = UserGameSettings.PreferredTransparency
	}))
	UserGameSettings:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() -- line: 14
		-- upvalues: p1 (copy), ClientSettingsChanged (copy), UserGameSettings (copy)
		p1:dispatch(ClientSettingsChanged("preferredTransparency", UserGameSettings.PreferredTransparency))
	end)
end
