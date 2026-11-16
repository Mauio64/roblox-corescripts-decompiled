local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local useUserProfileInfo = require(BuildExperience.Components.UserPicker.useUserProfileInfo)

local Text = Foundation.Text

local function PrivateInviteUserRow(props)
	local v = useUserProfileInfo(props.userId)
	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.layoutOrder,
		Text = 0,
		tag = "size-full-0 auto-y text-body-medium text-align-x-left content-default"
	}
	local text

	if v.displayName == "" then
		text = props.unknownText
	else
		text = v.displayName
	end

	v2.Text = text
	return createElement(Text, v2)
end

return PrivateInviteUserRow
