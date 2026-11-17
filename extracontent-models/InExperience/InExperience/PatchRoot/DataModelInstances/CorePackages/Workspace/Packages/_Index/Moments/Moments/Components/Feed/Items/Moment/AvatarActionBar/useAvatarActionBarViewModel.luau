local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Localization = require(parent.Localization)
local SharedFlags = require(parent.SharedFlags)
local SignalsReact = require(parent.SignalsReact)

local LocalizationService = game:GetService("LocalizationService")

local useLocalization = Localization.Hooks.useLocalization
local useSignalState = SignalsReact.useSignalState

local useAvatarLook = require(Moments.Hooks.useAvatarLook)
local MomentContext = require(script.Parent.Parent.MomentContext)
local MomentsHostContext = require(Moments.MomentsHostContext)
local useMomentsHost = MomentsHostContext.useMomentsHost

require(script.Parent.AvatarActionBar)

local FFlagAXEnableUnifiedLoggingAvatarMoment = SharedFlags.FFlagAXEnableUnifiedLoggingAvatarMoment
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed
local FFlagMomentsHideUnavailableAvatarActionBar = require(Moments.Flags.FFlagMomentsHideUnavailableAvatarActionBar)
local FFlagMomentsAvatarActionBarOutfitThumbnail = require(Moments.Flags.FFlagMomentsAvatarActionBarOutfitThumbnail)

local function getLookThumbnail(lookId: string) -- 1 equivalent call inferred from this helper
	return `rbxthumb://type=Look&id={lookId}&w={150}&h={150}`
end

local function getOutfitThumbnail(p: number) -- 1 equivalent call inferred from this helper
	return `rbxthumb://type=Outfit&id={p}&w={150}&h={150}&includeBackground=true`
end

local function useAvatarActionBarViewModel(p)
	local store = MomentContext.useMoment().store
	local data = store.getData(false)
	local outfit

	if FFlagMomentsRenderAvatarPostsInFeed and data.kind == "avatar" then
		outfit = data.outfit
	end

	local outfitId

	if data.kind == "experience" then
		outfitId = data.outfitId
	elseif outfit == nil or outfit.source.type ~= "outfit" then
		outfitId = nil
	else
		outfitId = outfit.source.id
	end

	local openAvatarLookTryOn = useMomentsHost().openAvatarLookTryOn
	local v = useAvatarLook(outfitId)
	local isShopDisabled = useSignalState(store.getIsModerated)

	local v2 = outfit ~= nil
		and outfit.source.type == "look"
		and { lookId = outfit.source.id, totalPrice = outfit.price, itemCount = outfit.itemCount }
		or nil

	local v3 = v2 or v.look
	local v4 = useLocalization({
		shop = "Feature.Avatar.Action.Shop",
		itemCount = {
			"Feature.Catalog.Label.TotalItemsParenthesis",
			itemCount = v3 == nil and 0 or v3.itemCount
		}
	})
	local lookId

	if v3 == nil then
		lookId = nil
	else
		lookId = v3.lookId
	end

	local v5 = {
		LayoutOrder = p.LayoutOrder,
		hasLookError = 0,
		isLoading = 0,
		thumbnailImage = 0,
		priceText = 0,
		itemCountText = 0,
		shopText = 0,
		showShopButton = 0,
		isShopDisabled = 0,
		onShop = 0
	}
	local hasLookError = FFlagMomentsHideUnavailableAvatarActionBar

	if hasLookError then
		if data.kind == "avatar" and v2 == nil then
			hasLookError = v.status == "Unavailable"
		else
			hasLookError = false
		end
	end

	v5.hasLookError = hasLookError

	v5.isLoading = v2 == nil and v.status ~= "Ready"
	local thumbnailImage

	if FFlagMomentsAvatarActionBarOutfitThumbnail and outfitId ~= nil then
		thumbnailImage = getOutfitThumbnail(outfitId) -- inferred equivalent call
	elseif lookId ~= nil then
		thumbnailImage = getLookThumbnail(lookId) -- inferred equivalent call
	end

	v5.thumbnailImage = thumbnailImage
	local priceText

	if not (v3 == nil or v3.totalPrice == nil) then
		priceText = Localization.NumberLocalization.localize(v3.totalPrice, LocalizationService.RobloxLocaleId)
	end

	v5.priceText = priceText

	v5.itemCountText = v4.itemCount
	v5.shopText = v4.shop
	v5.showShopButton = openAvatarLookTryOn ~= nil
	v5.isShopDisabled = isShopDisabled
	function v5.onShop()
		if openAvatarLookTryOn ~= nil and lookId ~= nil then
			if FFlagAXEnableUnifiedLoggingAvatarMoment then
				openAvatarLookTryOn(lookId, {
					feedItemId = data.feedItemId,
					feedSessionId = data.feedSessionId,
					outfitId = outfitId
				})
			else
				openAvatarLookTryOn(lookId)
			end
		end
	end

	return v5
end

return useAvatarActionBarViewModel
