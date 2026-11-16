local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local PublishConfigurationContentView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PublishConfigurationContent/PublishConfigurationContentView")
local usePublishConfigurationContentViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PublishConfigurationContent/usePublishConfigurationContentViewModel")

local function PublishConfigurationContentContainer(p2)
	local v5 = usePublishConfigurationContentViewModel(p2)
	return React.createElement(PublishConfigurationContentView, v5)
end

return PublishConfigurationContentContainer
