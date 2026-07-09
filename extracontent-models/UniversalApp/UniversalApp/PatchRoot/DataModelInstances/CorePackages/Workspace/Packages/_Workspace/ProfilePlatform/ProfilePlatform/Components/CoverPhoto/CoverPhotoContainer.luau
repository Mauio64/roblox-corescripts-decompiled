local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Constants = require(ProfilePlatformParent.UserLib).Utils.Constants
local Enums = require(ProfilePlatform.Common.Enums)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileScrollContext = require(ProfilePlatform.Contexts.ProfileScrollContext.useProfileScrollContext)
local CoverPhoto = require(ProfilePlatform.Components.CoverPhoto.CoverPhoto)

local function CoverPhotoContainer(t1: {[any]: any}) -- line: 22
	-- upvalues: useProfileJsonComponent (copy), Enums (copy), useProfileFormFactor (copy), useProfileScrollContext (copy), Constants (copy), React (copy), CoverPhoto (copy)
	local v12 = useProfileJsonComponent(Enums.Components.CoverPhoto) or {}
	local v13 = useProfileFormFactor()
	local v14 = useProfileScrollContext()
	local v15 = v14.scrollY / 2

	if v12.coverPhotoId == nil then
		return nil
	end

	local v16 = string.format("rbxthumb://type=%s&id=%s&w=%d&h=%d", Constants.RbxthumbTypes.Asset, v12.coverPhotoId, 1440, 456)

	return React.createElement(CoverPhoto, {
		layoutOrder = t1.layoutOrder,
		coverPhotoThumbnail = v16,
		profileFormFactorInfo = v13,
		parallaxOffset = v15,
		peekViewOpenPercent = v14.peekViewOpenPercent
	})
end

return CoverPhotoContainer
