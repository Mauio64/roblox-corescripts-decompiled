local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local MyCreationsFilterView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MyCreationsFilter/MyCreationsFilterView")
local useMyCreationsFilterViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MyCreationsFilter/useMyCreationsFilterViewModel")

local function MyCreationsFilterContainer(p2)
	local v5 = useMyCreationsFilterViewModel(p2)
	return React.createElement(MyCreationsFilterView, v5)
end

return MyCreationsFilterContainer
