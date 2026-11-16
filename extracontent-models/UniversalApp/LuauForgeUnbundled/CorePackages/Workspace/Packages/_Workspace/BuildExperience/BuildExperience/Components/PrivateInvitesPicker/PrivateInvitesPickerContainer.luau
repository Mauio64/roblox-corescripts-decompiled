local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local PrivateInvitesPickerView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PrivateInvitesPicker/PrivateInvitesPickerView")
local usePrivateInvitesPickerViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PrivateInvitesPicker/usePrivateInvitesPickerViewModel")

local function PrivateInvitesPickerContainer(p2)
	local v5 = usePrivateInvitesPickerViewModel(p2)
	return React.createElement(PrivateInvitesPickerView, v5)
end

return PrivateInvitesPickerContainer
