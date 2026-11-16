local UserInputService = game:GetService("UserInputService")
local parent = script:FindFirstAncestor("GameCollections").Parent
local AppCommonLib = require(parent.AppCommonLib)
local IsVRAppBuild = AppCommonLib.IsVRAppBuild
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local v = "Other"
pcall(function()
	local platform = UserInputService:GetPlatform()

	if platform == Enum.Platform.Android then
		v = "Android"
	elseif platform == Enum.Platform.IOS then
		v = "iOS"
	elseif platform == Enum.Platform.Windows then
		v = "Win"
	elseif platform == Enum.Platform.UWP then
		v = "UWP"
	elseif platform == Enum.Platform.OSX then
		v = "Mac"
	elseif platform == Enum.Platform.XBox360 or platform == Enum.Platform.XBoxOne then
		v = "XBox"
	elseif
		platform == Enum.Platform.PS4
		or game:GetEngineFeature("PlatformEnumPS5") and platform == Enum.Platform.PS5
	then
		v = "PS"
	end
end)

return function(p, p2: string, p3: number, p4: number?)
	if not (p and p.Diag and p2) then
		return
	end

	local v2 = "Other"
	local v3

	if p2 == AppPage.Home or p2 == AppPage.Games then
		if p4 == 1 then
			v3 = "GamesList"
		elseif p2 == AppPage.Home then
			v3 = "Home"
		else
			assert(p2 == AppPage.Games, `{p2} should always be Games here`)
			v3 = "Games"
		end
	else
		v3 = p2 == "recommended" and "GameDetail" or p2 == AppPage.SearchPage and "SearchPage" or v2
	end

	local v4 = v

	local v5 = (IsVRAppBuild() and "VR" or v4) .. "-GameImps-" .. v3
	p.Diag:reportCounterSimple(v5, p3)
end
