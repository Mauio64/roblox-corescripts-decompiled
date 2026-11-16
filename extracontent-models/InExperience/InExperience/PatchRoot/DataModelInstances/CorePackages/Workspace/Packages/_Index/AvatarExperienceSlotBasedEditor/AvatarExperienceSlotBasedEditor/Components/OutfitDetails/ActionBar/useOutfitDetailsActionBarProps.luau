local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

require(script.Parent.OutfitDetailsActionBar)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local function useOutfitDetailsActionBarProps(p)
	local v = useNavigation()
	local outfitId = p.outfitId

	local v2 = useLocalization({
		rename = "Feature.Avatar.Action.Rename",
		delete = "Feature.Avatar.Action.Delete"
	})

	local onRenameOutfit = React.useCallback(function()
		v.navigate(AvatarScreen.RenameOutfitDialog, { outfitId = outfitId })
	end, { v, outfitId })

	local onDeleteOutfit = React.useCallback(function()
		v.navigate(AvatarScreen.DeleteOutfitDialog, {
			outfitIds = { outfitId }
		})
	end, { v, outfitId })

	return {
		renameText = v2.rename,
		deleteText = v2.delete,
		onRenameOutfit = onRenameOutfit,
		onDeleteOutfit = onDeleteOutfit,
		LayoutOrder = p.LayoutOrder
	}
end

return useOutfitDetailsActionBarProps
