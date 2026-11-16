local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module = require("@luauforge/bundled/dPI")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local module2 = require("@luauforge/bundled/ecW")
local itemType = require("@luauforge/bundled/dMx").ItemType

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

	local v6 = useSignalState((React.useMemo(function()
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

	local v7 = React.useCallback(function()
		local v8 = p3
		local v9

		if v8 == itemType.Asset then
			v9 = module.MarketplaceItemFavorite.getMarketplaceAssetFavoriteStore(false)
		elseif v8 == itemType.Bundle then
			v9 = module.MarketplaceItemFavorite.getMarketplaceBundleFavoriteStore(false)
		end

		if v9 == nil then
			return
		end

		v9.toggleFavorite(p2, {
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

	local v9 = if v6 then v6.isFavorited else nil
	return { isFavorited = v9, toggleFavorite = v7 }
end

return useCatalogItemFavorite
