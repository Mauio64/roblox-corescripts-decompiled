local UserInputService = require(script.Parent.Parent.Services).UserInputService
local Platform = require(script.Parent.Platform)
local t1 = {
	ps4 = Platform.PS4,
	ps5 = Platform.PS5,
	xbox = Platform.Xbox
}

local function getInputPlatform() -- line: 10
	-- upvalues: UserInputService (copy), t1 (copy), Platform (copy)
	local ImageForKeyCode = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonStart)

	for v6, v7 in t1 do
		if ImageForKeyCode:find(v6) then
			return v7
		end
	end

	if UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonA) == "ButtonCross" then
		return Platform.PS5
	end

	return Platform.Xbox
end

return getInputPlatform
