local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local VersionTitleDescriptionPageView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionTitleDescriptionPage/VersionTitleDescriptionPageView")
local useVersionTitleDescriptionPageViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionTitleDescriptionPage/useVersionTitleDescriptionPageViewModel")

local function VersionTitleDescriptionPageContainer(p2)
	local v5 = useVersionTitleDescriptionPageViewModel(p2)
	return React.createElement(VersionTitleDescriptionPageView, v5)
end

return VersionTitleDescriptionPageContainer
