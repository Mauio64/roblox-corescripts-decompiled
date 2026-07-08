local Parent = script:FindFirstAncestor("BuildExperience").Parent
local AppComposition = require(Parent.AppComposition)
local React = require(Parent.React)
local CompositionStyleSheet = AppComposition.CompositionStyleSheet

local function BuildExperienceCompositionStyleSheet() -- line: 9
	-- upvalues: CompositionStyleSheet (copy), React (copy)
	if CompositionStyleSheet then
		return (React.createElement(CompositionStyleSheet))
	end

	return nil
end

return BuildExperienceCompositionStyleSheet
