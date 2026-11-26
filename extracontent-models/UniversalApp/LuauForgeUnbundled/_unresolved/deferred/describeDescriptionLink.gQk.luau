local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/Foundation")
require("@luauforge/deferred/gQa")
local module2 = require("@luauforge/deferred/gQi")
local itemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/AvatarExperienceModel").Enums.ItemTypeEnum

local iconName = Foundation.Enums.IconName

local v5 = {
	labelKey = "Feature.Catalog.Label.DescriptionLinkViewAsset",
	icon = iconName.ClothesHanger
}

local v6 = {
	labelKey = "Feature.Catalog.Label.DescriptionLinkViewBundle",
	icon = iconName.ShirtPants
}

local v7 = {
	labelKey = "Feature.Catalog.Label.DescriptionLinkSearchMarketplace",
	icon = iconName.MagnifyingGlass
}

local v8 = {
	labelKey = "Feature.Catalog.Label.DescriptionLinkViewCommunity",
	icon = iconName.ThreePeople
}

local v9 = {
	labelKey = "Feature.Catalog.Label.DescriptionLinkViewCommunityStore",
	icon = iconName.BuildingStore
}

local v10 = {
	labelKey = "Feature.Catalog.Label.DescriptionLinkInvalid",
	icon = iconName.ChainLinkSlash
}

local function describeDescriptionLink(p2)
	if p2.kind == module2.Item then
		if p2.itemType == itemTypeEnum.Bundle then
			return v6
		end

		return v5
	end

	if p2.kind == module2.Search then
		return v7
	end

	if p2.kind == module2.Community then
		return v8
	end

	if p2.kind == module2.CommunityStore then
		return v9
	end

	return v10
end

return describeDescriptionLink
