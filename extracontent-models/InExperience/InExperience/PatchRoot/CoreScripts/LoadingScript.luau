local CoreGui = game:GetService("CoreGui")
CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules")
local CorePackages = game:GetService("CorePackages")

local v = game.PlaceId
local v2 = select("#", ...)

if v <= 0 and v2 > 0 then
	v = select(1, ...)
end

if game:DefineFastFlag("EnableExperienceGenericChallengeRenderingOnLoadingScript", false) then
	coroutine.wrap(function()
		local GenericChallenges = require(CorePackages.Workspace.Packages.GenericChallenges)
		GenericChallenges.Middleware.InitExperienceChallengeInterceptor()
	end)()
end

local teamCreateUtils = require(CorePackages.Workspace.Packages.BuildExperiencePlaytestLaunch.teamCreateUtils)

if teamCreateUtils.isViewer() then
	local UIBlox = require(CorePackages.Packages.UIBlox)
	local init = UIBlox.init
	local CoreScriptsInitializer = require(CorePackages.Workspace.Packages.CoreScriptsInitializer)
	init(CoreScriptsInitializer.UIBloxInGameConfig)
	local mountTeamCreateViewer = require(CorePackages.Workspace.Packages.BuildExperience.mountTeamCreateViewer)
	mountTeamCreateViewer(v)
else
	local ExperienceLoadingScript = require(CorePackages.Workspace.Packages.ExperienceLoadingScript)
	local loadingScript = ExperienceLoadingScript.loadingScript
	coroutine.wrap(loadingScript)(v, 72)
end
