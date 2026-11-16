local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local FFlagEditProfileFramesEnabled = SharedFlags.FFlagEditProfileFramesEnabled

local Enums = require(AvatarExperienceProfilePictureEditor.Common.Enums)
local editProfileImageHelpers = require(AvatarExperienceProfilePictureEditor.Utils.editProfileImageHelpers)

local function useEditProfileImageNavigation(p)
	local state, setState = React.useState((editProfileImageHelpers.getInitialActiveView(p.mode)))
	local onTitleBack = editProfileImageHelpers.hasOnTitleBack(state, p.mode)
	local isFramesOnlyEntry = FFlagEditProfileFramesEnabled

	if isFramesOnlyEntry then
		if state == "frames" then
			isFramesOnlyEntry = p.mode == Enums.EditProfileImageMode.FramesOnly
		else
			isFramesOnlyEntry = false
		end
	end

	local onExpandEmotes = React.useCallback(function()
		setState("emotes")
	end, {})
	local onExpandFrames = React.useCallback(function()
		setState("frames")
	end, {})
	local v = React.useCallback(function()
		setState("combined")
	end, {})

	local v2 = {
		activeView = state,
		isFramesOnlyEntry = isFramesOnlyEntry,
		titleBackAvailable = onTitleBack,
		onExpandEmotes = onExpandEmotes,
		onExpandFrames = onExpandFrames,
		onReturnToCombined = v,
		onTitleBack = nil
	}

	if not onTitleBack then
		v = nil
	end

	v2.onTitleBack = v
	return v2
end

return useEditProfileImageNavigation
