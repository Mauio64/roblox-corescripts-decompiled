local UserGameSettings = UserSettings():GetService("UserGameSettings")

local function getUserSettings()
	return UserGameSettings
end

return getUserSettings
