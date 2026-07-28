local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useNavigation = require(Parent.Navigation).useNavigation

require(script.Parent.OutfitDetailsActionBar)

local AvatarScreen = require(Parent.AvatarExperienceNavigation).Enums.AvatarScreen

local function useOutfitDetailsActionBarProps(t1: {[any]: any}) -- line: 17
	-- upvalues: useNavigation (copy), useLocalization (copy), React (copy), AvatarScreen (copy)
	local v8 = useNavigation()
	local outfitId = t1.outfitId
	local v10 = useLocalization({
		rename = "Feature.Avatar.Action.Rename",
		delete = "Feature.Avatar.Action.Delete"
	})
	local v11 = React.useCallback(function() -- line: 26
		-- upvalues: v8 (copy), AvatarScreen (copy), outfitId (copy)
		v8.navigate(AvatarScreen.RenameOutfitDialog, {
			outfitId = outfitId
		})
	end, {
		v8,
		outfitId
	})
	local v12 = React.useCallback(function() -- line: 32
		-- upvalues: v8 (copy), AvatarScreen (copy), outfitId (copy)
		v8.navigate(AvatarScreen.DeleteOutfitDialog, {
			outfitIds = { outfitId }
		})
	end, {
		v8,
		outfitId
	})

	return {
		renameText = v10.rename,
		deleteText = v10.delete,
		onRenameOutfit = v11,
		onDeleteOutfit = v12,
		LayoutOrder = t1.LayoutOrder
	}
end

return useOutfitDetailsActionBarProps
