local UserGameSettings = UserSettings():GetService("UserGameSettings")

local function getUserSettings() -- line: 3
	-- upvalues: UserGameSettings (copy)
	return UserGameSettings
end

return getUserSettings
