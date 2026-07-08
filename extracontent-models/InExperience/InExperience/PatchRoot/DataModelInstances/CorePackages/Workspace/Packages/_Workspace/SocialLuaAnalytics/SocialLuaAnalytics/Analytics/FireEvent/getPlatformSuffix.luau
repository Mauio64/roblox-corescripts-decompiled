local Parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent
local IsVRAppBuild = require(Parent.AppCommonLib).IsVRAppBuild
local getUserInputService = require(script.Parent.getUserInputService)
local PlatformBuckets = require(script.Parent.Parent.Enums.PlatformBuckets)
local PlatformSpecificity = require(script.Parent.Parent.Enums.PlatformSpecificity)
local t1 = {
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

return function(p1) -- line: 24
	-- upvalues: getUserInputService (copy), PlatformSpecificity (copy), IsVRAppBuild (copy), PlatformBuckets (copy), t1 (copy)
	local v8 = getUserInputService()
	local u9 = nil

	pcall(function() -- line: 29
		-- upvalues: u9 (ref), v8 (copy)
		u9 = v8:GetPlatform() or Enum.Platform.None
	end)

	if p1 == PlatformSpecificity.All then
		if IsVRAppBuild() then
			return PlatformBuckets.Quest
		end

		local v10 = tostring(u9):match(".*%.(.*)")

		if not v10 then
			return PlatformBuckets.None
		end

		return v10
	end

	if p1 == PlatformSpecificity.BucketsOnly then
		if IsVRAppBuild() then
			return PlatformBuckets.Quest
		end

		return t1[u9] or PlatformBuckets.None
	end

	return ""
end
