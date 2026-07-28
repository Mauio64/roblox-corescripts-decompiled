local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("GameCollections").Parent
local IsVRAppBuild = require(Parent.AppCommonLib).IsVRAppBuild
local AppPage = require(Parent.RobloxAppEnums).AppPage
local s1 = "Other"

pcall(function() -- line: 11
	-- upvalues: UserInputService (copy), s1 (ref)
	local Platform = UserInputService:GetPlatform()

	if Platform == Enum.Platform.Android then
		s1 = "Android"

		return
	end

	if Platform == Enum.Platform.IOS then
		s1 = "iOS"

		return
	end

	if Platform == Enum.Platform.Windows then
		s1 = "Win"

		return
	end

	if Platform == Enum.Platform.UWP then
		s1 = "UWP"

		return
	end

	if Platform == Enum.Platform.OSX then
		s1 = "Mac"

		return
	end

	if Platform == Enum.Platform.XBox360 or Platform == Enum.Platform.XBoxOne then
		s1 = "XBox"

		return
	end

	if Platform == Enum.Platform.PS4 or game:GetEngineFeature("PlatformEnumPS5") and Platform == Enum.Platform.PS5 then
		s1 = "PS"
	end
end)

return function(p1, s2: string, n1: number, n2: number?) -- line: 32
	-- upvalues: AppPage (copy), s1 (ref), IsVRAppBuild (copy)
	if not p1 or not p1.Diag then
		return
	end

	if not s2 then
		return
	end

	local s3 = "Other"

	if s2 == AppPage.Home or s2 == AppPage.Games then
		if n2 == 1 then
			s3 = "GamesList"
		elseif s2 == AppPage.Home then
			s3 = "Home"
		else
			assert(s2 == AppPage.Games, `{ s2 } should always be Games here`)
			s3 = "Games"
		end
	elseif s2 == "recommended" then
		s3 = "GameDetail"
	elseif s2 == AppPage.SearchPage then
		s3 = "SearchPage"
	end

	local v12 = s1

	if IsVRAppBuild() then
		v12 = "VR"
	end

	local v13 = v12 .. "-GameImps-" .. s3

	p1.Diag:reportCounterSimple(v13, n1)
end
