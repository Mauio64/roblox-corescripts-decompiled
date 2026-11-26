local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Navigation").useNavigation

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Components/OutfitDetails/ActionBar/OutfitDetailsActionBar")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceNavigation").Enums.AvatarScreen

local function useOutfitDetailsActionBarProps(p2)
	local v5 = useNavigation()
	local outfitId = p2.outfitId

	local v6 = useLocalization({
		rename = "Feature.Avatar.Action.Rename",
		delete = "Feature.Avatar.Action.Delete"
	})

	local v7 = React.useCallback(function()
		v5.navigate(avatarScreen.RenameOutfitDialog, { outfitId = outfitId })
	end, { v5, outfitId })

	local v8 = React.useCallback(function()
		v5.navigate(avatarScreen.DeleteOutfitDialog, {
			outfitIds = { outfitId }
		})
	end, { v5, outfitId })

	return {
		renameText = v6.rename,
		deleteText = v6.delete,
		onRenameOutfit = v7,
		onDeleteOutfit = v8,
		LayoutOrder = p2.LayoutOrder
	}
end

return useOutfitDetailsActionBarProps
