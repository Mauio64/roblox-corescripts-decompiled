local BuildExperiencePlaytestLaunch = script:FindFirstAncestor("BuildExperiencePlaytestLaunch")
local parent = BuildExperiencePlaytestLaunch.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local canViewBuild = require(BuildExperiencePlaytestLaunch.canViewBuild)
local openDeepLink = require(BuildExperiencePlaytestLaunch.openDeepLink)

local function goToBuild(flag: boolean, p)
	if not canViewBuild(UniversalAppPolicy.getAppFeaturePolicies()) then
		Logger:warning("goToBuild: dropped a request because the user cannot view Build")
		return
	end

	if flag then
		openDeepLink("roblox://navigation/build", true)

		return
	end

	if p == nil then
		error("goToBuild needs a navigation object outside an experience")
	end

	p.navigate(AppPage.Build)
end

return goToBuild
