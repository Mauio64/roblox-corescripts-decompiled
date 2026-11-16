local UserInputService = game:GetService("UserInputService")

local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/AppCommonLib").IsVRAppBuild
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RobloxAppEnums").AppPage

local v5 = "Other"
pcall(function()
	local platform = UserInputService:GetPlatform()

	if platform == Enum.Platform.Android then
		v5 = "Android"
	elseif platform == Enum.Platform.IOS then
		v5 = "iOS"
	elseif platform == Enum.Platform.Windows then
		v5 = "Win"
	elseif platform == Enum.Platform.UWP then
		v5 = "UWP"
	elseif platform == Enum.Platform.OSX then
		v5 = "Mac"
	elseif platform == Enum.Platform.XBox360 or platform == Enum.Platform.XBoxOne then
		v5 = "XBox"
	elseif
		platform == Enum.Platform.PS4
		or game:GetEngineFeature("PlatformEnumPS5") and platform == Enum.Platform.PS5
	then
		v5 = "PS"
	end
end)

return function(p2, p3, p4, p5)
	if not (p2 and p2.Diag and p3) then
		return
	end

	local v6 = "Other"
	local v7

	if p3 == appPage.Home or p3 == appPage.Games then
		if p5 == 1 then
			v7 = "GamesList"
		elseif p3 == appPage.Home then
			v7 = "Home"
		else
			assert(p3 == appPage.Games, `{p3} should always be Games here`)
			v7 = "Games"
		end
	else
		v7 = p3 == "recommended" and "GameDetail" or p3 == appPage.SearchPage and "SearchPage" or v6
	end

	local v8 = v5

	local v9 = (isVRAppBuild() and "VR" or v8) .. "-GameImps-" .. v7
	p2.Diag:reportCounterSimple(v9, p4)
end
