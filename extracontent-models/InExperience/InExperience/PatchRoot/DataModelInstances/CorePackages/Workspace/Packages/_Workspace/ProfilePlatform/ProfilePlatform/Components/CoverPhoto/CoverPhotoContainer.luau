local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local UserLib = require(parent.UserLib)
local Constants = UserLib.Utils.Constants

local Enums = require(ProfilePlatform.Common.Enums)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileScrollContext = require(ProfilePlatform.Contexts.ProfileScrollContext.useProfileScrollContext)

local CoverPhoto = require(ProfilePlatform.Components.CoverPhoto.CoverPhoto)

local function CoverPhotoContainer(p)
	local v = useProfileJsonComponent(Enums.Components.CoverPhoto) or {}
	local profileFormFactorInfo = useProfileFormFactor()
	local v2 = useProfileScrollContext()
	local parallaxOffset = v2.scrollY / 2

	if v.coverPhotoId == nil then
		return nil
	end

	local coverPhotoThumbnail = string.format(
		"rbxthumb://type=%s&id=%s&w=%d&h=%d",
		Constants.RbxthumbTypes.Asset,
		v.coverPhotoId,
		1440,
		456
	)

	return React.createElement(CoverPhoto, {
		layoutOrder = p.layoutOrder,
		coverPhotoThumbnail = coverPhotoThumbnail,
		profileFormFactorInfo = profileFormFactorInfo,
		parallaxOffset = parallaxOffset,
		peekViewOpenPercent = v2.peekViewOpenPercent
	})
end

return CoverPhotoContainer
