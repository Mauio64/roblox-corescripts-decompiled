local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local fFlagEditProfileFramesEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/SharedFlags").FFlagEditProfileFramesEnabled

local Enums = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/Enums")
local editProfileImageHelpers = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/editProfileImageHelpers")

local function useEditProfileImageNavigation(p2)
	local state, setState = React.useState(editProfileImageHelpers.getInitialActiveView(p2.mode))
	local onTitleBack = editProfileImageHelpers.hasOnTitleBack(state, p2.mode)
	local v5 = fFlagEditProfileFramesEnabled

	if v5 then
		v5 = state == "frames" and p2.mode == Enums.EditProfileImageMode.FramesOnly
	end

	local v6 = React.useCallback(function()
		setState("emotes")
	end, {})
	local v7 = React.useCallback(function()
		setState("frames")
	end, {})
	local v8 = React.useCallback(function()
		setState("combined")
	end, {})

	local v9 = {
		activeView = state,
		isFramesOnlyEntry = v5,
		titleBackAvailable = onTitleBack,
		onExpandEmotes = v6,
		onExpandFrames = v7,
		onReturnToCombined = v8,
		onTitleBack = nil
	}

	if not onTitleBack then
		v8 = nil
	end

	v9.onTitleBack = v8
	return v9
end

return useEditProfileImageNavigation
