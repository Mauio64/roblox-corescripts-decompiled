local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)
local PrivateInvitesManagementView = require(script.Parent.PrivateInvitesManagementView)
local usePrivateInvitesManagementViewModel = require(script.Parent.usePrivateInvitesManagementViewModel)

local function PrivateInvitesManagementContainer(p1) -- line: 14
	-- upvalues: usePrivateInvitesManagementViewModel (copy), React (copy), PrivateInvitesManagementView (copy)
	local v7 = usePrivateInvitesManagementViewModel(p1)

	return React.createElement(PrivateInvitesManagementView, v7)
end

return PrivateInvitesManagementContainer
