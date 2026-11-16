local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local parent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Constants = require(parent.Constants)
local UtilityFunctions = require(parent.UtilityFunctions)
local FavoritesButton = require(parent.Components.FavoritesButton)
local TryOnButton = require(parent.Components.TryOnButton)
local BuyButton = require(parent.Components.BuyButton)
local InspectAndBuyControllerBar = require(parent.Components.InspectAndBuyControllerBar)
local GetIsFavorite = require(parent.Selectors.GetIsFavorite)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local tutils = require(CorePackages.Packages.tutils)

local GetFFlagIBGateUGC4ACollectibleAssetsBundles = require(parent.Flags.GetFFlagIBGateUGC4ACollectibleAssetsBundles)

local GetFFlagIBEnableCollectiblesSystemSupport = require(parent.Flags.GetFFlagIBEnableCollectiblesSystemSupport)

local extended = Roact.PureComponent:extend("DetailsButtons")

local function isAnimationAsset(assetTypeId): boolean -- 1 equivalent call inferred from this helper
	return Constants.AnimationAssetTypes[assetTypeId] ~= nil
end

local function getBuyText(data, p, p2, collectibleLowestResalePrice)
	local price = nil

	local isLimited = data.isLimited or GetFFlagIBEnableCollectiblesSystemSupport() and data.isLimitedUnique

	if collectibleLowestResalePrice then
		return (RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Action.FromResale", p, {
			PRICE = tostring(collectibleLowestResalePrice)
		}))
	end

	if p2 and data.isForSale then
		return (RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Action.LimitReached", p))
	end

	if data.price ~= nil and data.productType == Constants.ProductType.CollectibleItem and data.isForSale then
		return data.price
	end

	if data.owned then
		return (RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Label.Owned", p))
	end

	if isLimited then
		return (RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Label.Limited", p))
	end

	if not (data.isForSale or isLimited) then
		return (RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Label.Offsale", p))
	end

	if not data.isForSale then
		return price
	end

	if data.premiumPricing == nil then
		price = data.price

		return price
	end

	if Players.LocalPlayer.MembershipType == Enum.MembershipType.Premium then
		return data.premiumPricing.premiumPriceInRobux
	end

	if data.price == nil then
		return (RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Label.PremiumOnly", p))
	end

	return data.price
end

function extended:init()
	self.tryOnButtonRef = Roact.createRef()
	self.buyButtonRef = Roact.createRef()
	self.favoriteButtonRef = Roact.createRef()
end

function extended.didUpdate(data, p)
	local detailsInformation = data.props.detailsInformation
	local gamepadEnabled = data.props.gamepadEnabled

	if detailsInformation.viewingDetails then
		local visible = data.props.visible

		if gamepadEnabled and visible then
			GuiService.SelectedCoreObject = data.favoriteButtonRef.current
		end
	elseif data.props.assetInfo.bundlesAssetIsIn == nil and detailsInformation.viewingDetails and gamepadEnabled then
		GuiService.SelectedCoreObject = nil
	end

	local overlay = data.props.overlay
	local overlay2 = p.overlay

	if gamepadEnabled and overlay and overlay.overlay == nil and overlay2 and overlay2.overlay ~= nil then
		GuiService.SelectedCoreObject = data.tryOnButtonRef.current
	end
end

function extended:calculateBuyStatusForLimitedItem(data, p, _)
	local limited2Point0_Or_LimitedCollectible = UtilityFunctions.isLimited2Point0_Or_LimitedCollectible(data)
	local v = UtilityFunctions.isLimited1Point0(data) or UtilityFunctions.isLimited1Point0_LimitedUnique(data)
	local collectibleQuantityLimitReached = nil
	local collectibleLowestResalePrice = nil
	local collectibleLowestAvailableResaleItemInstanceId = nil
	local collectibleLowestAvailableResaleProductId = nil
	local collectibleItemId = nil
	local forSale

	if limited2Point0_Or_LimitedCollectible then
		forSale = data.isForSale

		local resellableInstances = self.props.resellableInstances

		collectibleQuantityLimitReached = resellableInstances
			and resellableInstances[data.collectibleItemId]
			and tutils.fieldCount(resellableInstances[data.collectibleItemId])

		if collectibleQuantityLimitReached then
			if data.collectibleQuantityLimitPerUser == nil or not (data.collectibleQuantityLimitPerUser > 0) then
				collectibleQuantityLimitReached = false
			else
				collectibleQuantityLimitReached = data.collectibleQuantityLimitPerUser <= collectibleQuantityLimitReached
			end
		end

		local v2 = data.collectibleLowestAvailableResaleProductId
			and data.collectibleLowestAvailableResaleProductId ~= ""
		local v3

		if data.remaining > 0 then
			v3 = v2 and (data.price or 0) > data.collectibleLowestResalePrice
		else
			v3 = v2 and data.collectibleLowestResalePrice
		end

		if v2 then
			if not forSale or collectibleQuantityLimitReached or v3 then
				collectibleLowestResalePrice = data.collectibleLowestResalePrice
				collectibleLowestAvailableResaleItemInstanceId = data.collectibleLowestAvailableResaleItemInstanceId
				collectibleLowestAvailableResaleProductId = data.collectibleLowestAvailableResaleProductId
				collectibleItemId = data.collectibleItemId
				forSale = true
			end
		elseif collectibleQuantityLimitReached then
			forSale = false
		end
	else
		forSale = data.isForSale and not (data.owned or v)
	end

	if forSale and data.price == nil and data.premiumPricing ~= nil then
		forSale = Players.LocalPlayer.MembershipType == Enum.MembershipType.Premium
	end

	local buyText = getBuyText(data, p, collectibleQuantityLimitReached, collectibleLowestResalePrice)
	local showRobuxIcon

	if data.price == nil or data.owned or not forSale then
		if collectibleLowestResalePrice == nil then
			if data.price == nil then
				showRobuxIcon = false
			elseif data.productType == Constants.ProductType.CollectibleItem then
				showRobuxIcon = forSale
			else
				showRobuxIcon = false
			end
		else
			showRobuxIcon = true
		end
	else
		showRobuxIcon = forSale
	end

	return {
		buyText = buyText,
		showRobuxIcon = showRobuxIcon,
		forSale = forSale,
		collectibleQuantityLimitReached = collectibleQuantityLimitReached,
		collectibleLowestResalePrice = collectibleLowestResalePrice,
		collectibleLowestAvailableResaleItemInstanceId = collectibleLowestAvailableResaleItemInstanceId,
		collectibleLowestAvailableResaleProductId = collectibleLowestAvailableResaleProductId,
		collectibleItemId = collectibleItemId
	}
end

function extended:render()
	local locale = self.props.locale
	local assetInfo = self.props.assetInfo

	local forSale = nil
	local bundleId = nil
	local v, partOfBundleAndOffsale, itemType, itemId, buyText, showRobuxIcon, collectibleLowestResalePrice, collectibleLowestAvailableResaleProductId, collectibleLowestAvailableResaleItemInstanceId, collectibleItemId, showTryOn

	if assetInfo then
		v = assetInfo.parentBundleId ~= nil

		partOfBundleAndOffsale = v and not assetInfo.isForSale

		if v then
			bundleId = UtilityFunctions.getBundleId(assetInfo)
			itemType = Constants.ItemType.Bundle
			itemId = bundleId
		else
			itemType = Constants.ItemType.Asset
			itemId = assetInfo.assetId
		end

		local buyStatusForLimitedItem = self:calculateBuyStatusForLimitedItem(assetInfo, locale, forSale)

		buyText = buyStatusForLimitedItem.buyText
		showRobuxIcon = buyStatusForLimitedItem.showRobuxIcon
		forSale = buyStatusForLimitedItem.forSale
		local _collectibleQuantityLimitReached = buyStatusForLimitedItem.collectibleQuantityLimitReached
		collectibleLowestResalePrice = buyStatusForLimitedItem.collectibleLowestResalePrice
		collectibleLowestAvailableResaleProductId = buyStatusForLimitedItem.collectibleLowestAvailableResaleProductId
		collectibleLowestAvailableResaleItemInstanceId = buyStatusForLimitedItem.collectibleLowestAvailableResaleItemInstanceId
		collectibleItemId = buyStatusForLimitedItem.collectibleItemId

		local animationAsset = isAnimationAsset(assetInfo.assetTypeId) -- inferred equivalent call

		if
			Constants.AssetTypeIdStringToHumanoidDescriptionProp[assetInfo.assetTypeId] == nil
			and Constants.AssetTypeIdToAccessoryTypeEnum[assetInfo.assetTypeId] == nil
		then
			showTryOn = false
		else
			showTryOn = not animationAsset
		end
	else
		showTryOn = false
		showRobuxIcon = false
	end

	local v2

	if GetFFlagIBGateUGC4ACollectibleAssetsBundles() then
		v2 = UtilityFunctions.isUnlimitedCollectibleAsset(itemType, assetInfo)
			or UtilityFunctions.isLimitedBundle(itemType, assetInfo)
			or UtilityFunctions.isUnlimitedCollectibleBundle(itemType, assetInfo)
	end

	if assetInfo then
		collectibleItemId = assetInfo.collectibleItemId

		local assetBundle = self.props.assetBundles[assetInfo.assetId]
		v2 = v and #assetBundle > 1
	end

	local gamepadEnabled = self.props.detailsInformation.viewingDetails and self.props.gamepadEnabled

	local createElement = Roact.createElement
	local v3 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 51),
		Position = UDim2.new(0, 0, 1, -51)
	}
	local v4 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		ControllerBar = gamepadEnabled and Roact.createElement(InspectAndBuyControllerBar, {
			showTryOn = showTryOn,
			tryingOn = self.props.tryingOn,
			showFavorite = true,
			isFavorited = self.props.isFavorited
		}),
		FavoriteButton = Roact.createElement(FavoritesButton, {
			favoriteButtonRef = self.favoriteButtonRef
		}),
		TryOnButton = Roact.createElement(TryOnButton, {
			showTryOn = showTryOn,
			assetInfo = assetInfo,
			partOfBundleAndOffsale = partOfBundleAndOffsale,
			bundleId = bundleId,
			tryOnButtonRef = self.tryOnButtonRef,
			localPlayerModel = self.props.localPlayerModel
		}),
		TryOnFiller = Roact.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
			Size = UDim2.new(0.5, -32, 0, 44),
			Visible = not showTryOn,
			LayoutOrder = 2,
			Image = "",
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(5, 5, 120, 20)
		}),
		BuyButton = 0
	}
	local buyButton

	if not (GetFFlagIBGateUGC4ACollectibleAssetsBundles() and v2) then
		buyButton = Roact.createElement(BuyButton, {
			itemType = itemType,
			itemId = itemId,
			showRobuxIcon = showRobuxIcon,
			forSale = forSale,
			buyText = buyText,
			buyButtonRef = self.buyButtonRef,
			collectibleItemId = collectibleItemId,
			collectibleLowestAvailableResaleProductId = collectibleLowestAvailableResaleProductId,
			collectibleLowestAvailableResaleItemInstanceId = collectibleLowestAvailableResaleItemInstanceId,
			collectibleLowestResalePrice = collectibleLowestResalePrice
		})
	end

	v4.BuyButton = buyButton
	return createElement("Frame", v3, v4)
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	local assetId = data.detailsInformation.assetId

	local isFavorited = GetIsFavorite(data)

	return {
		visible = data.visible,
		assetInfo = data.assets[assetId] or {},
		assetBundles = data.assetBundles,
		detailsInformation = data.detailsInformation,
		bundleInfo = data.bundles,
		locale = data.locale,
		gamepadEnabled = data.gamepadEnabled,
		isFavorited = isFavorited,
		tryingOn = data.tryingOnInfo.tryingOn,
		resellableInstances = data.collectibleResellableInstances,
		overlay = data.overlay
	}
end)(extended)
