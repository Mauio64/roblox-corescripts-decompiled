local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local PrivateInvitesManagementView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/PrivateInvitesManagement/PrivateInvitesManagementView")
local usePrivateInvitesManagementViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/GameConfigurations/PrivateInvitesManagement/usePrivateInvitesManagementViewModel")

local function PrivateInvitesManagementContainer(p2)
	local v5 = usePrivateInvitesManagementViewModel(p2)
	return React.createElement(PrivateInvitesManagementView, v5)
end

return PrivateInvitesManagementContainer
