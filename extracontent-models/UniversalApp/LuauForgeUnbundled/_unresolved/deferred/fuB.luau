local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module3 = require("@luauforge/bundled/dMx")
local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local module4 = require("@luauforge/bundled/fuC")
local module5 = require("@luauforge/deferred/fuT")

local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local function buildEditProfileImageAvatarRoute(p2)
	local v5 = { fromProfile = p2 }

	return {
		current = {
			name = avatarScreen.EditProfileImage,
			key = avatarScreen.EditProfileImage,
			params = v5
		},
		opaque = {
			name = avatarScreen.EditProfileImage,
			key = avatarScreen.EditProfileImage,
			params = v5
		},
		previousPages = {},
		isVisible = true,
		isOverlayVisible = false
	}
end

return function(p2, p3, p4, p5, p6, p7, p8, p9)
	return function(object)
		local asset = module3.ItemType.Asset
		local v5 = p5

		if not (v5 and v5.opaque) then
			v5 = buildEditProfileImageAvatarRoute(p8)
		end

		if p9 == false then
			return object:dispatch(module4(p2, p3, p6, asset))
		end

		local function openItemPrompt()
			object:dispatch(module5(p2, p3, p7, p4, v5, p6, asset))
		end

		if itemData(object:getState().AvatarExperience.Common, p6, asset) then
			object:dispatch(module5(p2, p3, p7, p4, v5, p6, asset))

			return Promise.resolve()
		end

		local v6 = object:dispatch(module4(p2, p3, p6, asset))

		if v6 and v6.andThen then
			return v6:andThen(openItemPrompt)
		end

		object:dispatch(module5(p2, p3, p7, p4, v5, p6, asset))

		return Promise.resolve()
	end
end
