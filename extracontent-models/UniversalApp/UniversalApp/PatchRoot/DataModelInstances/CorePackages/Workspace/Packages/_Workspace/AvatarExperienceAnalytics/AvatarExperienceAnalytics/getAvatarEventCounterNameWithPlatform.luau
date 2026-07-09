local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local isSpatial = require(Parent.AppCommonLib).isSpatial

local function getAvatarEventCounterNameWithPlatform(s1: string) -- line: 8
	-- upvalues: UserInputService (copy), isSpatial (copy)
	local Platform = UserInputService:GetPlatform()

	if isSpatial() then
		return "VR" .. s1
	end

	if Platform == Enum.Platform.Android then
		return "Android" .. s1
	end

	if Platform == Enum.Platform.IOS then
		return "IOS" .. s1
	end

	if Platform == Enum.Platform.Windows then
		return "Windows" .. s1
	end

	if Platform == Enum.Platform.OSX then
		return "OSX" .. s1
	end

	if Platform == Enum.Platform.PS4 or Platform == Enum.Platform.PS5 then
		return "PlayStation" .. s1
	end

	if Platform == Enum.Platform.XBoxOne or Platform == Enum.Platform.XBox360 then
		s1 = "Xbox-" .. s1
	end

	return s1
end

return getAvatarEventCounterNameWithPlatform
