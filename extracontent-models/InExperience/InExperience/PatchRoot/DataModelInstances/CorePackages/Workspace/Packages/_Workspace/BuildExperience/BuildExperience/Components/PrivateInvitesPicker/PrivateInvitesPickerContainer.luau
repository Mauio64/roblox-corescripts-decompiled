local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local PrivateInvitesPickerView = require(script.Parent.PrivateInvitesPickerView)
local usePrivateInvitesPickerViewModel = require(script.Parent.usePrivateInvitesPickerViewModel)

local function PrivateInvitesPickerContainer(p)
	local v = usePrivateInvitesPickerViewModel(p)
	return React.createElement(PrivateInvitesPickerView, v)
end

return PrivateInvitesPickerContainer
