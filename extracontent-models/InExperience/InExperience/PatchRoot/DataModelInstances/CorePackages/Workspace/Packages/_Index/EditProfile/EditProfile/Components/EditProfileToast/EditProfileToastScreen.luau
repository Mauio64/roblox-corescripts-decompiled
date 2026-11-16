local parent = script:FindFirstAncestor("EditProfile").Parent
local React = require(parent.React)
local EditProfileToast = require(script.Parent.EditProfileToast)

local function EditProfileToastScreen(p)
	local param = p.navigation.getParam("text", "")

	return React.createElement(EditProfileToast, { text = param })
end

return EditProfileToastScreen
