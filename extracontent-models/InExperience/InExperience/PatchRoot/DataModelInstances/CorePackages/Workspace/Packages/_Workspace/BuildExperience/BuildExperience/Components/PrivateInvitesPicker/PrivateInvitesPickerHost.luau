local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

local PrivateInvitesPickerContainer = require(BuildExperience.Components.PrivateInvitesPicker.PrivateInvitesPickerContainer)

local function PrivateInvitesPickerHost(props)
	return React.createElement(PrivateInvitesPickerContainer, {
		universeId = props.universeId,
		onClose = props.onClose,
		onInvitesSent = props.onInvitesSent,
		testId = props.testId
	})
end

return PrivateInvitesPickerHost
