local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)
local PrivateInvitesPickerView = require(script.Parent.PrivateInvitesPickerView)
local usePrivateInvitesPickerViewModel = require(script.Parent.usePrivateInvitesPickerViewModel)

local function PrivateInvitesPickerContainer(p1) -- line: 15
	-- upvalues: usePrivateInvitesPickerViewModel (copy), React (copy), PrivateInvitesPickerView (copy)
	local v7 = usePrivateInvitesPickerViewModel(p1)

	return React.createElement(PrivateInvitesPickerView, v7)
end

return PrivateInvitesPickerContainer
