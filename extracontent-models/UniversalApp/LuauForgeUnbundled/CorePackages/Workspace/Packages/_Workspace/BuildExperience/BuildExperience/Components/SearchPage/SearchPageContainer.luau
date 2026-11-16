local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local SearchPageView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SearchPage/SearchPageView")
local useSearchPageViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SearchPage/useSearchPageViewModel")

local function SearchPageContainer(p2, p3)
	local v5 = useSearchPageViewModel(p2, p3)
	return React.createElement(SearchPageView, v5)
end

return React.forwardRef(SearchPageContainer)
