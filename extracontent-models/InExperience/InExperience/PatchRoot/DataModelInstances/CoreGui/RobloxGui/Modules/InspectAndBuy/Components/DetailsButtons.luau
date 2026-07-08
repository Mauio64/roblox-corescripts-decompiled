local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ParentParent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Constants = require(ParentParent.Constants)
local UtilityFunctions = require(ParentParent.UtilityFunctions)
local FavoritesButton = require(ParentParent.Components.FavoritesButton)
local TryOnButton = require(ParentParent.Components.TryOnButton)
local BuyButton = require(ParentParent.Components.BuyButton)
local InspectAndBuyControllerBar = require(ParentParent.Components.InspectAndBuyControllerBar)
local GetIsFavorite = require(ParentParent.Selectors.GetIsFavorite)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local tutils = require(CorePackages.Packages.tutils)
local GetFFlagIBGateUGC4ACollectibleAssetsBundles = require(ParentParent.Flags.GetFFlagIBGateUGC4ACollectibleAssetsBundles)
local GetFFlagIBEnableCollectiblesSystemSupport = require(ParentParent.Flags.GetFFlagIBEnableCollectiblesSystemSupport)
local v18 = Roact.PureComponent:extend("DetailsButtons")

local function isAnimationAsset(p1) -- line: 35
	-- upvalues: Constants (copy)
	return Constants.AnimationAssetTypes[p1] ~= nil
end
local function getBuyText(p2, p3, p4, p5) -- line: 39
	-- upvalues: GetFFlagIBEnableCollectiblesSystemSupport (copy), RobloxTranslator (copy), Constants (copy), Players (copy)
	local price = nil
	local v27 = p2.isLimited or GetFFlagIBEnableCollectiblesSystemSupport() and p2.isLimitedUnique

	if p5 then
		return (RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Action.FromResale", p3, {
			PRICE = tostring(p5)
		}))
	end

	if p4 and p2.isForSale then
		return (RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Action.LimitReached", p3))
	end

	if p2.price ~= nil and p2.productType == Constants.ProductType.CollectibleItem and p2.isForSale then
		return p2.price
	end

	if p2.owned then
		return (RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Label.Owned", p3))
	end

	if v27 then
		return (RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Label.Limited", p3))
	end

	if not p2.isForSale and not v27 then
		return (RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Label.Offsale", p3))
	end

	if p2.isForSale then
		if p2.premiumPricing ~= nil then
			if Players.LocalPlayer.MembershipType == Enum.MembershipType.Premium then
				return p2.premiumPricing.premiumPriceInRobux
			end

			if p2.price == nil then
				return (RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Label.PremiumOnly", p3))
			end

			return p2.price
		end

		price = p2.price
	end

	return price
end

function v18.init(p6) -- line: 83
	-- upvalues: Roact (copy)
	p6.tryOnButtonRef = Roact.createRef()
	p6.buyButtonRef = Roact.createRef()
	p6.favoriteButtonRef = Roact.createRef()
end
function v18.didUpdate(p7, p8) -- line: 89
	-- upvalues: GuiService (copy)
	local detailsInformation = p7.props.detailsInformation
	local gamepadEnabled = p7.props.gamepadEnabled

	if detailsInformation.viewingDetails then
		local visible = p7.props.visible

		if gamepadEnabled and visible then
			GuiService.SelectedCoreObject = p7.favoriteButtonRef.current
		end
	elseif p7.props.assetInfo.bundlesAssetIsIn == nil and detailsInformation.viewingDetails and gamepadEnabled then
		GuiService.SelectedCoreObject = nil
	end

	local overlay = p7.props.overlay
	local overlay2 = p8.overlay

	if gamepadEnabled and overlay and overlay.overlay == nil and overlay2 and overlay2.overlay ~= nil then
		GuiService.SelectedCoreObject = p7.tryOnButtonRef.current
	end
end
function v18.calculateBuyStatusForLimitedItem(p9, p10, p11, _) -- line: 113
	-- upvalues: UtilityFunctions (copy), tutils (copy), Players (copy), getBuyText (copy), Constants (copy)
	local v40 = UtilityFunctions.isLimited2Point0_Or_LimitedCollectible(p10)
	local v41 = UtilityFunctions.isLimited1Point0(p10) or UtilityFunctions.isLimited1Point0_LimitedUnique(p10)
	local v42 = nil
	local collectibleLowestResalePrice = nil
	local collectibleLowestAvailableResaleItemInstanceId = nil
	local collectibleLowestAvailableResaleProductId = nil
	local collectibleItemId = nil
	local isForSale

	if v40 then
		isForSale = p10.isForSale

		local resellableInstances = p9.props.resellableInstances
		local v49 = resellableInstances and (resellableInstances[p10.collectibleItemId] and tutils.fieldCount(resellableInstances[p10.collectibleItemId]))

		v42 = v49 and (p10.collectibleQuantityLimitPerUser ~= nil and (p10.collectibleQuantityLimitPerUser > 0 and v49 >= p10.collectibleQuantityLimitPerUser))

		local v50 = p10.collectibleLowestAvailableResaleProductId and p10.collectibleLowestAvailableResaleProductId ~= ""
		local v51 = if not (p10.remaining > 0) then v50 and p10.collectibleLowestResalePrice else v50 and (p10.price or 0) > p10.collectibleLowestResalePrice

		if v50 then
			if not isForSale or v42 or v51 then
				collectibleLowestResalePrice = p10.collectibleLowestResalePrice
				collectibleLowestAvailableResaleItemInstanceId = p10.collectibleLowestAvailableResaleItemInstanceId
				collectibleLowestAvailableResaleProductId = p10.collectibleLowestAvailableResaleProductId
				collectibleItemId = p10.collectibleItemId
				isForSale = true
			end
		elseif v42 then
			isForSale = false
		end
	else
		isForSale = p10.isForSale and (not p10.owned and not v41)
	end

	if isForSale and p10.price == nil and p10.premiumPricing ~= nil then
		isForSale = Players.LocalPlayer.MembershipType == Enum.MembershipType.Premium
	end

	local v52 = getBuyText(p10, p11, v42, collectibleLowestResalePrice)
	local v53 = p10.price ~= nil and (not p10.owned and isForSale) or (collectibleLowestResalePrice ~= nil or p10.price ~= nil and (p10.productType == Constants.ProductType.CollectibleItem and isForSale))

	return {
		buyText = v52,
		showRobuxIcon = v53,
		forSale = isForSale,
		collectibleQuantityLimitReached = v42,
		collectibleLowestResalePrice = collectibleLowestResalePrice,
		collectibleLowestAvailableResaleItemInstanceId = collectibleLowestAvailableResaleItemInstanceId,
		collectibleLowestAvailableResaleProductId = collectibleLowestAvailableResaleProductId,
		collectibleItemId = collectibleItemId
	}
end
function v18.render(p13) -- line: 188
	-- upvalues: UtilityFunctions (copy), Constants (copy), GetFFlagIBGateUGC4ACollectibleAssetsBundles (copy), Roact (copy), InspectAndBuyControllerBar (copy), FavoritesButton (copy), TryOnButton (copy), BuyButton (copy)
	local locale = p13.props.locale
	local assetInfo = p13.props.assetInfo
	local v57 = false
	local v58 = false
	local buyText = nil
	local forSale = nil
	local v61 = nil
	local v62 = nil
	local Bundle = nil
	local v64 = nil
	local v65 = nil
	local collectibleItemId = nil
	local collectibleLowestResalePrice = nil
	local collectibleLowestAvailableResaleProductId = nil
	local collectibleLowestAvailableResaleItemInstanceId = nil

	if assetInfo then
		v61 = assetInfo.parentBundleId ~= nil
		v65 = v61 and not assetInfo.isForSale

		if v61 then
			v62 = UtilityFunctions.getBundleId(assetInfo)
			Bundle = Constants.ItemType.Bundle
			v64 = v62
		else
			Bundle = Constants.ItemType.Asset
			v64 = assetInfo.assetId
		end

		local v70 = p13:calculateBuyStatusForLimitedItem(assetInfo, locale, forSale)

		buyText = v70.buyText
		v57 = v70.showRobuxIcon
		forSale = v70.forSale

		local _ = v70.collectibleQuantityLimitReached

		collectibleLowestResalePrice = v70.collectibleLowestResalePrice
		collectibleLowestAvailableResaleProductId = v70.collectibleLowestAvailableResaleProductId
		collectibleLowestAvailableResaleItemInstanceId = v70.collectibleLowestAvailableResaleItemInstanceId
		collectibleItemId = v70.collectibleItemId

		local assetTypeId = assetInfo.assetTypeId

		v58 = Constants.AnimationAssetTypes[assetTypeId] == nil

		if Constants.AssetTypeIdStringToHumanoidDescriptionProp[assetInfo.assetTypeId] == nil and Constants.AssetTypeIdToAccessoryTypeEnum[assetInfo.assetTypeId] == nil then
			v58 = false
		end
	end

	local v73 = nil

	if GetFFlagIBGateUGC4ACollectibleAssetsBundles() then
		v73 = UtilityFunctions.isUnlimitedCollectibleAsset(Bundle, assetInfo) or (UtilityFunctions.isLimitedBundle(Bundle, assetInfo) or UtilityFunctions.isUnlimitedCollectibleBundle(Bundle, assetInfo))
	end

	if assetInfo then
		collectibleItemId = assetInfo.collectibleItemId

		local v74 = p13.props.assetBundles[assetInfo.assetId]

		v73 = v61 and #v74 > 1
	end

	local v75 = p13.props.detailsInformation.viewingDetails and p13.props.gamepadEnabled

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 51),
		Position = UDim2.new(0, 0, 1, -51)
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		ControllerBar = v75 and Roact.createElement(InspectAndBuyControllerBar, {
			showFavorite = true,
			showTryOn = v58,
			tryingOn = p13.props.tryingOn,
			isFavorited = p13.props.isFavorited
		}),
		FavoriteButton = Roact.createElement(FavoritesButton, {
			favoriteButtonRef = p13.favoriteButtonRef
		}),
		TryOnButton = Roact.createElement(TryOnButton, {
			showTryOn = v58,
			assetInfo = assetInfo,
			partOfBundleAndOffsale = v65,
			bundleId = v62,
			tryOnButtonRef = p13.tryOnButtonRef,
			localPlayerModel = p13.props.localPlayerModel
		}),
		TryOnFiller = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Image = "",
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.new(0.5, -32, 0, 44),
			Visible = not v58,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(5, 5, 120, 20)
		}),
		BuyButton = if not GetFFlagIBGateUGC4ACollectibleAssetsBundles() or not v73 then Roact.createElement(BuyButton, {
			itemType = Bundle,
			itemId = v64,
			showRobuxIcon = v57,
			forSale = forSale,
			buyText = buyText,
			buyButtonRef = p13.buyButtonRef,
			collectibleItemId = collectibleItemId,
			collectibleLowestAvailableResaleProductId = collectibleLowestAvailableResaleProductId,
			collectibleLowestAvailableResaleItemInstanceId = collectibleLowestAvailableResaleItemInstanceId,
			collectibleLowestResalePrice = collectibleLowestResalePrice
		}) else nil
	})
end

return RoactRodux.UNSTABLE_connect2(function(p14, _) -- line: 315
	-- upvalues: GetIsFavorite (copy)
	local assetId = p14.detailsInformation.assetId
	local v79 = GetIsFavorite(p14)

	return {
		visible = p14.visible,
		assetInfo = p14.assets[assetId] or {},
		assetBundles = p14.assetBundles,
		detailsInformation = p14.detailsInformation,
		bundleInfo = p14.bundles,
		locale = p14.locale,
		gamepadEnabled = p14.gamepadEnabled,
		isFavorited = v79,
		tryingOn = p14.tryingOnInfo.tryingOn,
		resellableInstances = p14.collectibleResellableInstances,
		overlay = p14.overlay
	}
end)(v18)
