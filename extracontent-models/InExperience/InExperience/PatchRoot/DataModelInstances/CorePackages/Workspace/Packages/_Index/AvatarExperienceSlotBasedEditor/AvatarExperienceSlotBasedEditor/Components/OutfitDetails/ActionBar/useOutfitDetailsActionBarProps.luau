local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization

require(script.Parent.OutfitDetailsActionBar)

local function useOutfitDetailsActionBarProps(t1: {[any]: any}) -- line: 15
	-- upvalues: useLocalization (copy), React (copy)
	local outfitId = t1.outfitId
	local v7 = useLocalization({
		rename = "Feature.Avatar.Action.Rename",
		delete = "Feature.Avatar.Action.Delete"
	})
	local v8 = React.useCallback(function() -- line: 23
		-- upvalues: outfitId (copy)
		print("Open rename outfit prompt", outfitId)
	end, { outfitId })
	local v9 = React.useCallback(function() -- line: 27
		-- upvalues: outfitId (copy)
		print("Open delete outfit prompt", outfitId)
	end, { outfitId })

	return {
		renameText = v7.rename,
		deleteText = v7.delete,
		onRenameOutfit = v8,
		onDeleteOutfit = v9,
		LayoutOrder = t1.LayoutOrder
	}
end

return useOutfitDetailsActionBarProps
