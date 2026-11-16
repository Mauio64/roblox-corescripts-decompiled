local parent = script:FindFirstAncestor("BuildExperience").Parent

local AppComposition = require(parent.AppComposition)
local React = require(parent.React)

local CompositionStyleSheet = AppComposition.CompositionStyleSheet

local function BuildExperienceCompositionStyleSheet()
	if CompositionStyleSheet then
		return (React.createElement(CompositionStyleSheet))
	end

	return nil
end

return BuildExperienceCompositionStyleSheet
