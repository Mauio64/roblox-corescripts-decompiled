local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent

local React = require(parent.React)

local context = React.createContext(nil)

return {
	Context = context,
	Provider = context.Provider,
	useEditProfileImageActions = function()
		local v = React.useContext(context)

		if v == nil then
			error("useEditProfileImageActions must be used within an EditProfileImageActions Provider")
		end

		return v
	end
}
