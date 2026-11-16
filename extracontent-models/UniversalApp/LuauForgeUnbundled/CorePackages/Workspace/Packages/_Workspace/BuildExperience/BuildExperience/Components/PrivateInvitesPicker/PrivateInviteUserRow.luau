local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useUserProfileInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/UserPicker/useUserProfileInfo")

local text = Foundation.Text

local function PrivateInviteUserRow(props)
	local v5 = useUserProfileInfo(props.userId)
	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.layoutOrder,
		Text = 0,
		tag = "size-full-0 auto-y text-body-medium text-align-x-left content-default"
	}
	local v8 = if v5.displayName == "" then props.unknownText else v5.displayName
	v7.Text = v8
	return createElement(text, v7)
end

return PrivateInviteUserRow
