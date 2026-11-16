local Services = require(script.Parent.Parent.Services)
local UserInputService = Services.UserInputService
local Platform = require(script.Parent.Platform)

local v = { ["ps4"] = Platform.PS4, ps5 = Platform.PS5, xbox = Platform.Xbox }

local function getInputPlatform()
	local imageForKeyCode = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonStart)

	for k, v2 in v do
		if imageForKeyCode:find(k) then
			return v2
		end
	end

	if UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonA) == "ButtonCross" then
		return Platform.PS5
	end

	return Platform.Xbox
end

return getInputPlatform
