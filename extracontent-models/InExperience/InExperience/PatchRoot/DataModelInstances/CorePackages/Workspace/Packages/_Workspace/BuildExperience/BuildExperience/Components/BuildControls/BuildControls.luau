local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local View = Foundation.View

require(BuildExperience.Components.BuildOverflowSheetButton.BuildOverflowSheetButton)

local function BuildControls(_: {[any]: any}) -- line: 20
	-- upvalues: React (copy), View (copy)
	return React.createElement(View, {
		tag = "row align-y-center gap-medium auto-xy padding-x-xlarge padding-y-small",
		testId = "build-controls"
	}, {
		Overflow = nil
	})
end

return BuildControls
