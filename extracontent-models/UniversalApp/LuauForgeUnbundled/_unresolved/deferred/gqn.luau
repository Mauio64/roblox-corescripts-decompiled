local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local module2 = require("@luauforge/bundled/dTG")
local fFlagAXUseSignalsForLayeredClothingEntryPage = AvatarExperienceFlags.FFlagAXUseSignalsForLayeredClothingEntryPage
local getLayeredClothingEntryPageStore

if fFlagAXUseSignalsForLayeredClothingEntryPage then
	getLayeredClothingEntryPageStore = require("@luauforge/bundled/dMd").Stores.getLayeredClothingEntryPageStore
else
	getLayeredClothingEntryPageStore = nil
end

local module3 = require("@luauforge/bundled/dTI")

local fFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice = AvatarExperienceFlags.FFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice
local module4 = require("@luauforge/deferred/ggf")
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock

return function(p2, p3, p4, callback)
	return function(object)
		local state = object:getState()

		if
			state.AvatarExperience.AvatarScene.Character.WaitingOnLayeredClothingUpdates
			or not state.AvatarExperience.AvatarEditor.Character.EquippedAssets
		then
			return
		end

		if fFlagAXUseSignalsForLayeredClothingEntryPage then
			getLayeredClothingEntryPageStore(false).setEntryPage(p3.opaque.name)
		else
			object:dispatch(module2(p3.opaque.name))
		end

		object:dispatch(module4(p4.avatarRefineButtonTap))

		if callback then
			callback()
		end

		object:dispatch(navigateWithLock(function()
			if not fFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice then
				object:dispatch(module3())
			end

			p2.navigate(avatarScreen.AvatarRefinement)
		end))
	end
end
