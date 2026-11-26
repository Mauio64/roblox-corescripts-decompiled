local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")

local context = React.createContext(nil)

return {
	Context = context,
	Provider = context.Provider,
	useEditProfileImageActions = function()
		local v5 = React.useContext(context)

		if v5 == nil then
			error("useEditProfileImageActions must be used within an EditProfileImageActions Provider")
		end

		return v5
	end
}
