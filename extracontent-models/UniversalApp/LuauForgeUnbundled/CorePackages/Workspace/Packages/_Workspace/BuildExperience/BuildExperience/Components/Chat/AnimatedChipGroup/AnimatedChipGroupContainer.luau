local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local AnimatedChipGroupView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/AnimatedChipGroup/AnimatedChipGroupView")
local useAnimatedChipGroupViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/AnimatedChipGroup/useAnimatedChipGroupViewModel")

local function AnimatedChipGroupContainer(p2)
	local v5 = useAnimatedChipGroupViewModel(p2)
	return React.createElement(AnimatedChipGroupView, v5)
end

return AnimatedChipGroupContainer
