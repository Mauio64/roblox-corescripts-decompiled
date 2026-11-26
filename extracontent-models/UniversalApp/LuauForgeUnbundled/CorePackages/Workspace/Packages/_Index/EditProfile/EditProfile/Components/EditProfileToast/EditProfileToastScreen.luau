local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local EditProfileToast = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Components/EditProfileToast/EditProfileToast")

local function EditProfileToastScreen(p2)
	local param = p2.navigation.getParam("text", "")

	return React.createElement(EditProfileToast, { text = param })
end

return EditProfileToastScreen
