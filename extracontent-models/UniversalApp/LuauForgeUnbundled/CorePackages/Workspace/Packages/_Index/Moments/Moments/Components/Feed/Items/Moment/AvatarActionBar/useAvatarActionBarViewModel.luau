local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local LocalizationService = game:GetService("LocalizationService")

local useLocalization = Localization.Hooks.useLocalization
local useSignalState = SignalsReact.useSignalState

local useAvatarLook = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useAvatarLook")
local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
local useMomentsHost = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/MomentsHostContext").useMomentsHost

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/AvatarActionBar/AvatarActionBar")

local fFlagAXEnableUnifiedLoggingAvatarMoment = SharedFlags.FFlagAXEnableUnifiedLoggingAvatarMoment
local fFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed

local function getLookThumbnail(p2)
	return `rbxthumb://type=Look&id={p2}&w={150}&h={150}`
end

local function useAvatarActionBarViewModel(p2)
	local store = MomentContext.useMoment().store
	local data = store.getData(false)
	local outfit = if fFlagMomentsRenderAvatarPostsInFeed and data.kind == "avatar" then data.outfit else nil
	local v5

	if data.kind == "experience" then
		v5 = data.outfitId
	else
		v5 = if not (outfit == nil or outfit.source.type ~= "outfit") then outfit.source.id else nil
	end

	local openAvatarLookTryOn = useMomentsHost().openAvatarLookTryOn
	local v6 = useAvatarLook(v5)
	local v7 = useSignalState(store.getIsModerated)

	local v8 = outfit ~= nil
		and outfit.source.type == "look"
		and {
			lookId = outfit.source.id,
			totalPrice = outfit.price,
			itemCount = outfit.itemCount
		}
		or nil

	local v9 = v8 or v6.look
	local v10 = useLocalization({
		shop = "Feature.Avatar.Action.Shop",
		itemCount = {
			"Feature.Catalog.Label.TotalItemsParenthesis",
			itemCount = v9 == nil and 0 or v9.itemCount
		}
	})

	local lookId = if v9 ~= nil then v9.lookId else nil
	local v11 = {
		LayoutOrder = p2.LayoutOrder,
		isLoading = v8 == nil and v6.status ~= "Ready",
		thumbnailImage = 0,
		priceText = 0,
		itemCountText = 0,
		shopText = 0,
		showShopButton = 0,
		isShopDisabled = 0,
		onShop = 0
	}
	local v13 = if lookId ~= nil then `rbxthumb://type=Look&id={lookId}&w={150}&h={150}` else nil

	v11.thumbnailImage = v13
	local v14 = if v9 ~= nil and v9.totalPrice ~= nil then Localization.NumberLocalization.localize(
		v9.totalPrice,
		LocalizationService.RobloxLocaleId
	) else nil
	v11.priceText = v14

	v11.itemCountText = v10.itemCount
	v11.shopText = v10.shop
	v11.showShopButton = openAvatarLookTryOn ~= nil
	v11.isShopDisabled = v7
	function v11.onShop()
		if openAvatarLookTryOn ~= nil and lookId ~= nil then
			if fFlagAXEnableUnifiedLoggingAvatarMoment then
				openAvatarLookTryOn(lookId, {
					feedItemId = data.feedItemId,
					feedSessionId = data.feedSessionId,
					outfitId = v5
				})
			else
				openAvatarLookTryOn(lookId)
			end
		end
	end

	return v11
end

return useAvatarActionBarViewModel
