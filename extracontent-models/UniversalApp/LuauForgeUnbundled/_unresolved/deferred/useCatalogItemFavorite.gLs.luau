local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module = require("@luauforge/bundled/dSY")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local module2 = require("@luauforge/bundled/egt")
local itemType = require("@luauforge/bundled/dPN").ItemType

local function getFavoriteStore(p2)
	if p2 == itemType.Asset then
		return module.MarketplaceItemFavorite.getMarketplaceAssetFavoriteStore(false)
	end

	if p2 == itemType.Bundle then
		return module.MarketplaceItemFavorite.getMarketplaceBundleFavoriteStore(false)
	end

	return nil
end

local function getNoFavorite(p2): nil
	return nil
end

local function useCatalogItemFavorite(p2, p3, p4)
	local v5 = useDispatch()

	local v7 = useSignalState((React.useMemo(function()
		local v7 = p3
		local v8

		if v7 == itemType.Asset then
			v8 = module.MarketplaceItemFavorite.getMarketplaceAssetFavoriteStore(false)
		elseif v7 == itemType.Bundle then
			v8 = module.MarketplaceItemFavorite.getMarketplaceBundleFavoriteStore(false)
		end

		if v8 then
			return v8.getAndFetchFavorite(p2).data
		end

		return getNoFavorite
	end, { p2, p3 })))

	local v8 = React.useCallback(function()
		local v9 = p3
		local v10

		if v9 == itemType.Asset then
			v10 = module.MarketplaceItemFavorite.getMarketplaceAssetFavoriteStore(false)
		elseif v9 == itemType.Bundle then
			v10 = module.MarketplaceItemFavorite.getMarketplaceBundleFavoriteStore(false)
		end

		if v10 == nil then
			return
		end

		v10.toggleFavorite(p2, {
			onWriteStart = function(p5)
				p4.clickFavoriteItemButton(p2, p3, p5)
			end,
			onSettled = function(p5)
				if p5.type == "error" then
					v5(module2({ HttpError = Enum.HttpError.OK }))
				end
			end
		})
	end, { p2, p3, p4, v5 })

	local v10 = if v7 then v7.isFavorited else nil
	return { isFavorited = v10, toggleFavorite = v8 }
end

return useCatalogItemFavorite
