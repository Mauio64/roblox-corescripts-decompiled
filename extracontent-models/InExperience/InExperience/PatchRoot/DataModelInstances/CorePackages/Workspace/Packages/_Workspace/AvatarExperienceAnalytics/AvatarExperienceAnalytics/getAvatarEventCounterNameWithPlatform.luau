local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local AppCommonLib = require(parent.AppCommonLib)
local isSpatial = AppCommonLib.isSpatial

local function getAvatarEventCounterNameWithPlatform(p: string)
	local platform = UserInputService:GetPlatform()

	if isSpatial() then
		return "VR" .. p
	end

	if platform == Enum.Platform.Android then
		return "Android" .. p
	end

	if platform == Enum.Platform.IOS then
		return "IOS" .. p
	end

	if platform == Enum.Platform.Windows then
		return "Windows" .. p
	end

	if platform == Enum.Platform.OSX then
		return "OSX" .. p
	end

	if platform == Enum.Platform.PS4 or platform == Enum.Platform.PS5 then
		return "PlayStation" .. p
	end

	if platform == Enum.Platform.XBoxOne or platform == Enum.Platform.XBox360 then
		p = "Xbox-" .. p
	end

	return p
end

return getAvatarEventCounterNameWithPlatform
