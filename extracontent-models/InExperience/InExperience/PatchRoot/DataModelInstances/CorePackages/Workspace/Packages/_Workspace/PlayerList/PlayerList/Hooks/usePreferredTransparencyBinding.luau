local UserGameSettings = UserSettings():GetService("UserGameSettings")

local parent = script.Parent.Parent.Parent

local React = require(parent.React)

local function usePreferredTransparencyBinding()
	local v, v2 = React.useBinding(UserGameSettings.PreferredTransparency)

	React.useEffect(function()
		v2(UserGameSettings.PreferredTransparency)
		local preferredTransparencyChangedConnection = UserGameSettings:GetPropertyChangedSignal("PreferredTransparency"):Connect(function()
			v2(UserGameSettings.PreferredTransparency)
		end)
		return function()
			preferredTransparencyChangedConnection:Disconnect()
		end
	end, {})

	return v
end

return usePreferredTransparencyBinding
