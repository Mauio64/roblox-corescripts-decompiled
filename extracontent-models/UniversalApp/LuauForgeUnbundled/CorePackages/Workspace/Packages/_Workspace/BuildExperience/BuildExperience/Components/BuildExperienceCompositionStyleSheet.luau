local AppComposition = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/AppComposition")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local compositionStyleSheet = AppComposition.CompositionStyleSheet

local function BuildExperienceCompositionStyleSheet()
	if compositionStyleSheet then
		return (React.createElement(compositionStyleSheet))
	end

	return nil
end

return BuildExperienceCompositionStyleSheet
