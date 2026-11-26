local fFlagBuildExperienceLibrary = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/SharedFlags").FFlagBuildExperienceLibrary

return {
	isViewer = function(p2)
		local v5 = p2 or game
		local v6 = fFlagBuildExperienceLibrary and v5:GetEngineFeature("IsTeamCreateViewerEnabled")

		if v6 then
			local RunService = v5:GetService("RunService")
			v6 = RunService:IsTeamCreateViewer()
		end

		return v6
	end
}
