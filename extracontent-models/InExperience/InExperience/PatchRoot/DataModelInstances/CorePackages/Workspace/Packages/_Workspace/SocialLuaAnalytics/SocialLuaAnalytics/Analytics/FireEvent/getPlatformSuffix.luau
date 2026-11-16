local parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent
local AppCommonLib = require(parent.AppCommonLib)

local IsVRAppBuild = AppCommonLib.IsVRAppBuild
local getUserInputService = require(script.Parent.getUserInputService)
local PlatformBuckets = require(script.Parent.Parent.Enums.PlatformBuckets)
local PlatformSpecificity = require(script.Parent.Parent.Enums.PlatformSpecificity)

local v = {
	[Enum.Platform.Windows] = PlatformBuckets.Windows,
	[Enum.Platform.OSX] = PlatformBuckets.Mac,
	[Enum.Platform.IOS] = PlatformBuckets.IOS,
	[Enum.Platform.Android] = PlatformBuckets.Android,
	[Enum.Platform.UWP] = PlatformBuckets.Windows,
	[Enum.Platform.XBox360] = PlatformBuckets.XBox,
	[Enum.Platform.XBoxOne] = PlatformBuckets.XBox,
	[Enum.Platform.PS3] = PlatformBuckets.Playstation,
	[Enum.Platform.PS4] = PlatformBuckets.Playstation,
	[Enum.Platform.PS5] = PlatformBuckets.Playstation,
	[Enum.Platform.None] = PlatformBuckets.None
}

return function(p)
	local userInputService = getUserInputService()
	local platform = nil
	pcall(function()
		platform = userInputService:GetPlatform() or Enum.Platform.None
	end)

	if p == PlatformSpecificity.All then
		if IsVRAppBuild() then
			return PlatformBuckets.Quest
		end

		return tostring(platform):match(".*%.(.*)") or PlatformBuckets.None
	end

	if p ~= PlatformSpecificity.BucketsOnly then
		return ""
	end

	if IsVRAppBuild() then
		return PlatformBuckets.Quest
	end

	return v[platform] or PlatformBuckets.None
end
