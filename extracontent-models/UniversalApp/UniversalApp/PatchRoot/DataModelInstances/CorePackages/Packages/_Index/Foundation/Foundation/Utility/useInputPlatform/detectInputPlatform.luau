local Foundation = script:FindFirstAncestor("Foundation")

local Services = require(Foundation.Utility.Wrappers.Services)
local UserInputService = Services.UserInputService

local InputPlatform = require(Foundation.Enums.InputPlatform)

local function hasConnectedGamepad()
	local success, result = pcall(function()
		return UserInputService:GetConnectedGamepads()
	end)

	if success then
		if typeof(result) == "table" then
			success = #result > 0
		else
			success = false
		end
	end

	return success
end

local v = {
	Enum.KeyCode.ButtonStart,
	Enum.KeyCode.ButtonSelect,
	Enum.KeyCode.ButtonA,
	Enum.KeyCode.ButtonL1,
	Enum.KeyCode.DPadUp
}

local function getPlatformFromImage(p)
	local success, result = pcall(function()
		return UserInputService:GetImageForKeyCode(p)
	end)

	if not success or typeof(result) ~= "string" or result == "" then
		return nil
	end

	local lower = result:lower()

	if lower:find("ps5") then
		return InputPlatform.PS5
	end

	if lower:find("ps4") then
		return InputPlatform.PS4
	end

	return if lower:find("xbox") then InputPlatform.Xbox else nil
end

local function getPlatformFromGamepadAssets()
	for _, v2 in v do
		local platformFromImage = getPlatformFromImage(v2)

		if platformFromImage ~= nil then
			return platformFromImage
		end
	end

	return nil
end

local function isPlaystation()
	local success, result = pcall(function()
		return UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonA)
	end)

	return success and result == "ButtonCross"
end

local function detectInputPlatform()
	local success, result = pcall(function()
		return UserInputService:GetConnectedGamepads()
	end)

	if success then
		if typeof(result) == "table" then
			success = #result > 0
		else
			success = false
		end
	end

	if not success then
		return InputPlatform.Default
	end

	local flag = true
	local v2

	for _, v3 in v do
		v2 = getPlatformFromImage(v3)

		if v2 ~= nil then
			flag = false
			break
		end
	end

	if flag then
		v2 = nil
	end

	if v2 ~= nil then
		return v2
	end

	local success2, result2 = pcall(function()
		return UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonA)
	end)

	if success2 and result2 == "ButtonCross" then
		return InputPlatform.PS5
	end

	return InputPlatform.Xbox
end

return detectInputPlatform
