local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local PrivateInvitesPickerContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PrivateInvitesPicker/PrivateInvitesPickerContainer")

local function PrivateInvitesPickerHost(props)
	return React.createElement(PrivateInvitesPickerContainer, {
		universeId = props.universeId,
		onClose = props.onClose,
		onInvitesSent = props.onInvitesSent,
		testId = props.testId
	})
end

return PrivateInvitesPickerHost
