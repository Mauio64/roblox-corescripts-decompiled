local Parent = script:FindFirstAncestor("EditProfile").Parent
local React = require(Parent.React)
local EditProfileToast = require(script.Parent.EditProfileToast)

local function EditProfileToastScreen(t1: {[any]: any}) -- line: 10
	-- upvalues: React (copy), EditProfileToast (copy)
	local v6 = t1.navigation.getParam("text", "")

	return React.createElement(EditProfileToast, {
		text = v6
	})
end

return EditProfileToastScreen
