local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local SearchBarView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SearchBar/SearchBarView")
local useSearchBarViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SearchBar/useSearchBarViewModel")

local function SearchBarContainer(p2)
	local v5 = useSearchBarViewModel(p2)
	return React.createElement(SearchBarView, v5)
end

return SearchBarContainer
