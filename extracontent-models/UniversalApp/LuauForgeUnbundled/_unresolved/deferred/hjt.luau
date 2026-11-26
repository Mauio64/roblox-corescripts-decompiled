local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local fFlagAXAvatarFoldersEnabled = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAvatarFoldersEnabled

local module = require("@luauforge/deferred/hju")
local module2 = require("@luauforge/deferred/hjy")

return React.forwardRef(function(props, p2)
	local v6 = {
		outfitType = props.outfitType,
		isEditable = props.isEditable,
		onToggleOutfitCard = props.onToggleOutfitCard,
		selectedOutfits = props.selectedOutfits,
		setSelectedOutfits = props.setSelectedOutfits,
		setCanScroll = props.setCanScroll,
		multiSelect = props.multiSelect,
		goBack = props.goBack,
		pageOwner = props.pageOwner,
		bottomContentPadding = props.bottomContentPadding,
		forwardRef = p2,
		itemIdsFilter = 0
	}

	local v7 = if fFlagAXAvatarFoldersEnabled then props.itemIdsFilter else nil
	v6.itemIdsFilter = v7
	local v8 = module(v6)

	return React.createElement(module2, v8)
end)
