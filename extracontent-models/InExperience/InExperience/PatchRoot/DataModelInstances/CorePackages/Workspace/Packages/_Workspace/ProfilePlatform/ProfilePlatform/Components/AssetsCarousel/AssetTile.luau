local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local PriceFooter = require(script.Parent.PriceFooter)
local UserLib = require(ProfilePlatformParent.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local UIBlox = require(ProfilePlatformParent.UIBlox)
local Enums = require(ProfilePlatform.Common.Enums)
local FFlagProfilePlatformEnableBundlesInAssetsCarousel = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableBundlesInAssetsCarousel
local FFlagProfilePlatformFixResaleLimitedPrice = require(ProfilePlatform.Flags.FFlagProfilePlatformFixResaleLimitedPrice)
local ItemTile = UIBlox.Tile.ItemTile

local function AssetTile(t1: {[any]: any}) -- line: 36
	-- upvalues: FFlagProfilePlatformEnableBundlesInAssetsCarousel (copy), Enums (copy), Constants (copy), getRbxthumbWithTypeSizeAndOptions (copy), React (copy), ItemTile (copy), PriceFooter (copy), FFlagProfilePlatformFixResaleLimitedPrice (copy)
	local v15 = if not FFlagProfilePlatformEnableBundlesInAssetsCarousel or (not t1.itemType or t1.itemType ~= Enums.ItemTypes.Bundle) then Constants.RbxthumbTypes.Asset else Constants.RbxthumbTypes.BundleThumbnail
	local v16 = getRbxthumbWithTypeSizeAndOptions(t1.assetId, v15, 150)

	return React.createElement(ItemTile, {
		useMaxTitleHeight = false,
		titleTextLineCount = 1,
		Selectable = true,
		name = t1.name,
		thumbnail = v16,
		onActivated = t1.onActivated,
		footer = React.createElement(PriceFooter, {
			price = t1.price,
			isOffSale = t1.isOffSale,
			lowestResalePrice = if not FFlagProfilePlatformFixResaleLimitedPrice then nil else t1.lowestResalePrice
		})
	})
end

return AssetTile
