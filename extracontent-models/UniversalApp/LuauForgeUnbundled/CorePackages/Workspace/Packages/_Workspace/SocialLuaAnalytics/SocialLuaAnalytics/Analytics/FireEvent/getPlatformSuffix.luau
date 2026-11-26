local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/AppCommonLib").IsVRAppBuild
local getUserInputService = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/FireEvent/getUserInputService")
local PlatformBuckets = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums/PlatformBuckets")
local PlatformSpecificity = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums/PlatformSpecificity")

local v5 = {
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

return function(p2)
	local v6 = getUserInputService()
	local platform = nil
	pcall(function()
		platform = v6:GetPlatform() or Enum.Platform.None
	end)

	if p2 == PlatformSpecificity.All then
		if isVRAppBuild() then
			return PlatformBuckets.Quest
		end

		local match = tostring(platform):match(".*%.(.*)")

		if match then
			return match
		end

		return PlatformBuckets.None
	end

	if p2 ~= PlatformSpecificity.BucketsOnly then
		return ""
	end

	if isVRAppBuild() then
		return PlatformBuckets.Quest
	end

	return v5[platform] or PlatformBuckets.None
end
