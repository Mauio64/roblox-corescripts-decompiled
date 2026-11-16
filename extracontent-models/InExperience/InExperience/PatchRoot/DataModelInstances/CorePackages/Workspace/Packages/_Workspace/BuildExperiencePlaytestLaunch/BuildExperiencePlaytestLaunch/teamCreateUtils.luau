local BuildExperiencePlaytestLaunch = script:FindFirstAncestor("BuildExperiencePlaytestLaunch")
local SharedFlags = require(BuildExperiencePlaytestLaunch.Parent.SharedFlags)
local FFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary

return {
	isViewer = function(p)
		local v = p or game
		local v2 = FFlagBuildExperienceLibrary and v:GetEngineFeature("IsTeamCreateViewerEnabled")

		if v2 then
			local RunService = v:GetService("RunService")
			return (RunService:IsTeamCreateViewer())
		end

		return v2
	end
}
