local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module = require("@luauforge/bundled/dMx")
local itemData = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.ItemData
local module2 = require("@luauforge/bundled/dwB")
local module3 = require("@luauforge/bundled/dCh")
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock

local v5 = {
	toastMessage = "Feature.Avatar.Message.AlreadyAcquired",
	isLocalized = false,
	toastType = module2.InformationMessage
}

return function(onOverlayClosed, p2, p3, p4, p5)
	return function(object)
		local state = object:getState()
		local name = p3.opaque.name

		local v6 = nil
		local v7 = itemData(state.AvatarExperience.Common, p4, p5)

		if p5 == module.ItemType.Asset then
			v6 = v7.assetType
		elseif p5 == module.ItemType.Bundle then
			v6 = v7.bundleType
		end

		if name == avatarScreen.AvatarEditor then
			return object:dispatch(module3(v5))
		end

		object:dispatch(navigateWithLock(function()
			p2.navigate(avatarScreen.LeaveCatalogToAvatarPrompt, {
				itemType = p5,
				itemSubType = v6,
				onOverlayClosed = onOverlayClosed
			})
		end))
	end
end
