local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local PriceFooter = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/AssetsCarousel/PriceFooter")

local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserLib")
local constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local fFlagProfilePlatformEnableBundlesInAssetsCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableBundlesInAssetsCarousel

local FFlagProfilePlatformFixResaleLimitedPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformFixResaleLimitedPrice")

local itemTile = UIBlox.Tile.ItemTile

local function AssetTile(props)
	local v5

	if
		fFlagProfilePlatformEnableBundlesInAssetsCarousel
		and props.itemType
		and props.itemType == Enums.ItemTypes.Bundle
	then
		v5 = constants.RbxthumbTypes.BundleThumbnail
	else
		v5 = constants.RbxthumbTypes.Asset
	end

	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(props.assetId, v5, 150)

	local createElement = React.createElement
	local v7 = {
		name = props.name,
		thumbnail = rbxthumbWithTypeSizeAndOptions,
		onActivated = props.onActivated,
		useMaxTitleHeight = false,
		titleTextLineCount = 1,
		footer = 0,
		Selectable = true
	}

	local createElement2 = React.createElement
	local v9 = {
		price = props.price,
		isOffSale = props.isOffSale,
		lowestResalePrice = 0
	}
	local v10 = if FFlagProfilePlatformFixResaleLimitedPrice then props.lowestResalePrice else nil
	v9.lowestResalePrice = v10
	v7.footer = createElement2(PriceFooter, v9)
	return createElement(itemTile, v7)
end

return AssetTile
