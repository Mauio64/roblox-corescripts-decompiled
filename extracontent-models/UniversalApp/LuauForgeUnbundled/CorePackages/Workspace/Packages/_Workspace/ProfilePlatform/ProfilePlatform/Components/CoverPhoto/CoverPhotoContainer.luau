local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserLib").Utils.Constants

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useProfileFormFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileFormFactor")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local useProfileScrollContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/ProfileScrollContext/useProfileScrollContext")

local CoverPhoto = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CoverPhoto/CoverPhoto")

local function CoverPhotoContainer(p2)
	local v5 = useProfileJsonComponent(Enums.Components.CoverPhoto) or {}
	local v6 = useProfileFormFactor()
	local v7 = useProfileScrollContext()
	local v8 = v7.scrollY / 2

	if v5.coverPhotoId == nil then
		return nil
	end

	local v9 = string.format(
		"rbxthumb://type=%s&id=%s&w=%d&h=%d",
		constants.RbxthumbTypes.Asset,
		v5.coverPhotoId,
		1440,
		456
	)

	return React.createElement(CoverPhoto, {
		layoutOrder = p2.layoutOrder,
		coverPhotoThumbnail = v9,
		profileFormFactorInfo = v6,
		parallaxOffset = v8,
		peekViewOpenPercent = v7.peekViewOpenPercent
	})
end

return CoverPhotoContainer
