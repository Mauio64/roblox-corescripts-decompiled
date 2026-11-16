local UserInputService = game:GetService("UserInputService")

local isSpatial = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AppCommonLib").isSpatial

local function getAvatarEventCounterNameWithPlatform(p2)
	local platform = UserInputService:GetPlatform()

	if isSpatial() then
		return "VR" .. p2
	end

	if platform == Enum.Platform.Android then
		return "Android" .. p2
	end

	if platform == Enum.Platform.IOS then
		return "IOS" .. p2
	end

	if platform == Enum.Platform.Windows then
		return "Windows" .. p2
	end

	if platform == Enum.Platform.OSX then
		return "OSX" .. p2
	end

	if platform == Enum.Platform.PS4 or platform == Enum.Platform.PS5 then
		return "PlayStation" .. p2
	end

	if platform == Enum.Platform.XBoxOne or platform == Enum.Platform.XBox360 then
		p2 = "Xbox-" .. p2
	end

	return p2
end

return getAvatarEventCounterNameWithPlatform
