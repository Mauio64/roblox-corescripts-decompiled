local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local PriceFooter = require(script.Parent.PriceFooter)

local UserLib = require(parent.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local UIBlox = require(parent.UIBlox)

local Enums = require(ProfilePlatform.Common.Enums)

local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformEnableBundlesInAssetsCarousel = SharedFlags.FFlagProfilePlatformEnableBundlesInAssetsCarousel

local FFlagProfilePlatformFixResaleLimitedPrice = require(ProfilePlatform.Flags.FFlagProfilePlatformFixResaleLimitedPrice)

local ItemTile = UIBlox.Tile.ItemTile

local function AssetTile(props)
	local v

	if
		FFlagProfilePlatformEnableBundlesInAssetsCarousel
		and props.itemType
		and props.itemType == Enums.ItemTypes.Bundle
	then
		v = Constants.RbxthumbTypes.BundleThumbnail
	else
		v = Constants.RbxthumbTypes.Asset
	end

	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(props.assetId, v, 150)

	local createElement = React.createElement
	local v2 = {
		name = props.name,
		thumbnail = rbxthumbWithTypeSizeAndOptions,
		onActivated = props.onActivated,
		useMaxTitleHeight = false,
		titleTextLineCount = 1,
		footer = 0,
		Selectable = true
	}

	local createElement2 = React.createElement
	local v3 = { price = props.price, isOffSale = props.isOffSale, lowestResalePrice = 0 }
	local lowestResalePrice

	if FFlagProfilePlatformFixResaleLimitedPrice then
		lowestResalePrice = props.lowestResalePrice
	end

	v3.lowestResalePrice = lowestResalePrice
	v2.footer = createElement2(PriceFooter, v3)
	return createElement(ItemTile, v2)
end

return AssetTile
