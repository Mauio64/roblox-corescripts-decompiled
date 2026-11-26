local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/RobloxAppEnums").AppPage
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/Loggers").Logger
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/UniversalAppPolicy")
local canViewBuild = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/BuildExperiencePlaytestLaunch/canViewBuild")
local openDeepLink = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/BuildExperiencePlaytestLaunch/openDeepLink")

local function goToBuild(p2, p3)
	if not canViewBuild(UniversalAppPolicy.getAppFeaturePolicies()) then
		logger:warning("goToBuild: dropped a request because the user cannot view Build")
		return
	end

	if p2 then
		openDeepLink("roblox://navigation/build", true)

		return
	end

	if p3 == nil then
		error("goToBuild needs a navigation object outside an experience")
	end

	p3.navigate(appPage.Build)
end

return goToBuild
