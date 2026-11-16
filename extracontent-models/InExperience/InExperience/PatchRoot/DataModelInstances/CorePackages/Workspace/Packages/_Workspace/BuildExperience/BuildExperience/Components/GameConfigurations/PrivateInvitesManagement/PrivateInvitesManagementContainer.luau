local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local PrivateInvitesManagementView = require(script.Parent.PrivateInvitesManagementView)
local usePrivateInvitesManagementViewModel = require(script.Parent.usePrivateInvitesManagementViewModel)

local function PrivateInvitesManagementContainer(p)
	local v = usePrivateInvitesManagementViewModel(p)
	return React.createElement(PrivateInvitesManagementView, v)
end

return PrivateInvitesManagementContainer
