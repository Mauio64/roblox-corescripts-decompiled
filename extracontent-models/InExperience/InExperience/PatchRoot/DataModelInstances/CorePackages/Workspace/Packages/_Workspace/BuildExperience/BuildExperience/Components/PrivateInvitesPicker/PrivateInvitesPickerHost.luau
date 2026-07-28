local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local PrivateInvitesPickerContainer = require(BuildExperience.Components.PrivateInvitesPicker.PrivateInvitesPickerContainer)

local function PrivateInvitesPickerHost(t1: {[any]: any}) -- line: 18
	-- upvalues: React (copy), PrivateInvitesPickerContainer (copy)
	return React.createElement(PrivateInvitesPickerContainer, {
		universeId = t1.universeId,
		onClose = t1.onClose,
		onInvitesSent = t1.onInvitesSent,
		testId = t1.testId
	})
end

return PrivateInvitesPickerHost
