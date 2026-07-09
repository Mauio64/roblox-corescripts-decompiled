local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local tutils = require(CorePackages.Packages.tutils)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local SelectItemPromptType = require(Modules.AvatarExperience.Common.Selectors.SelectItemPromptType)
local OpenPurchasePrompt = require(Modules.AvatarExperience.Catalog.Thunks.OpenPurchasePrompt)
local OpenPremiumUpsellPrompt = require(Modules.AvatarExperience.Catalog.Thunks.OpenPremiumUpsellPrompt)
local OpenGoToAvatarEditorPrompt = require(Modules.AvatarExperience.Catalog.Thunks.OpenGoToAvatarEditorPrompt)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ApiFetchEconomyCurrency = require(Modules.LuaApp.Thunks.ApiFetchEconomyCurrency)
local GetFFlagCollectiblesCatalogFollowUpForSaleLocation = require(Modules.AvatarExperience.Flags.GetFFlagCollectiblesCatalogFollowUpForSaleLocation)
local FFlagPurchasePromptSubtitleForTimedOptions = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPurchasePromptSubtitleForTimedOptions
local t1 = {
	toastMessage = "Feature.Catalog.LabelNoResellers",
	toastSubMessage = "Feature.Catalog.Label.NoSellersWarning",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}
local t2 = {
	toastMessage = "Feature.Catalog.Heading.NotForSale",
	toastSubMessage = "Feature.Catalog.Label.NoLongerAvailable",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}
local t3 = {
	toastMessage = "Feature.Catalog.Heading.InExperienceOnly",
	toastSubMessage = "Feature.Catalog.Label.InExperienceOnly",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}
local t4 = {
	toastMessage = "Feature.Catalog.Heading.QuantityLimitReached",
	toastSubMessage = "Feature.Catalog.Label.QuantityLimitReached",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}

local function fetchRobuxBalance(p1, p2, p3) -- line: 56
	-- upvalues: ApiFetchEconomyCurrency (copy)
	local LocalUserId = p2.LocalUserId

	if typeof(LocalUserId) == "string" and LocalUserId ~= "" then
		p1:dispatch(ApiFetchEconomyCurrency(p3, LocalUserId, false))
	end
end
local function clickDisabledButton(p4, p5, p6, p7) -- line: 64
	-- upvalues: CatalogUtils (copy), ApiFetchEconomyCurrency (copy), GetFFlagCollectiblesCatalogFollowUpForSaleLocation (copy), SetCurrentToastMessage (copy), t3 (copy), t2 (copy), t4 (copy), t1 (copy)
	local v31 = p6 and p6.resellerUserAssetIds
	local v32 = CatalogUtils.IsResellable(p6)
	local v33 = p6 and p6.collectibleItemId
	local v34 = v31 and v31[1]
	local v35 = p5.AvatarExperience.Catalog.UserAssets[v34]
	local v36 = v32 and v35 == nil

	if p5.UserRobux[p5.LocalUserId] == nil then
		local LocalUserId = p5.LocalUserId

		if typeof(LocalUserId) == "string" and LocalUserId ~= "" then
			p4:dispatch(ApiFetchEconomyCurrency(p7, LocalUserId, false))
		end

		return
	end

	local v38 = false

	if v33 then
		local v39 = p5.AvatarExperience.Common.Collectibles.CollectiblesItemInfo[v33]

		v38 = not CatalogUtils.isOriginalStockSellableInShop(v39)
		v36 = not v39 or not v39.hasResellers
	end

	local v40 = false

	if v33 then
		local v41 = p5.AvatarExperience.Common.Collectibles.CollectiblesItemInfo[v33]
		local v42 = p5.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances[v33]

		v36 = not v41 or not v41.hasResellers
		v40 = v36 and CatalogUtils.reachQuantityLimit(v41, v42)
	end

	if v38 then
		if GetFFlagCollectiblesCatalogFollowUpForSaleLocation() then
			return p4:dispatch(SetCurrentToastMessage(t3))
		end

		return p4:dispatch(SetCurrentToastMessage(t2))
	end

	if v40 then
		return p4:dispatch(SetCurrentToastMessage(t4))
	end

	if v32 and v36 then
		return p4:dispatch(SetCurrentToastMessage(t1))
	end

	return p4:dispatch(SetCurrentToastMessage(t2))
end

return function(p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, b1: boolean?) -- line: 129
	-- upvalues: SelectItemPromptType (copy), tutils (copy), Constants (copy), OpenPurchasePrompt (copy), FFlagPurchasePromptSubtitleForTimedOptions (copy), OpenGoToAvatarEditorPrompt (copy), OpenPremiumUpsellPrompt (copy), ItemData (copy), clickDisabledButton (copy)
	return function(p19) -- line: 146
		-- upvalues: p13 (copy), p14 (copy), p12 (copy), SelectItemPromptType (copy), tutils (copy), Constants (copy), OpenPurchasePrompt (copy), p8 (copy), p10 (copy), p11 (copy), p9 (copy), p15 (copy), p16 (copy), p17 (copy), FFlagPurchasePromptSubtitleForTimedOptions (copy), p18 (copy), b1 (copy), OpenGoToAvatarEditorPrompt (copy), OpenPremiumUpsellPrompt (copy), ItemData (copy), clickDisabledButton (copy)
		local v56 = p19:getState()
		local v57, v58

		if p13 and p14 then
			v57 = p13
			v58 = p14
		else
			v57 = p12.current.params.itemId
			v58 = p12.current.params.itemType
		end

		local v59 = SelectItemPromptType(v56, v57, v58, {})
		local fromContentFeed = p12.current.params.fromContentFeed
		local fromProfile = p12.current.params.fromProfile
		local widgetInfo = p12.current.params.widgetInfo

		if not widgetInfo then
			local TryOnItems = v56.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

			if tutils.fieldCount(TryOnItems) == 1 then
				local _, v65 = next(TryOnItems)

				widgetInfo = v65.widgetInfo
			end
		end

		if v59 == Constants.ItemPromptType.OpenPurchasePrompt then
			p19:dispatch(OpenPurchasePrompt(p8, p10, p11, p9, fromProfile, p12, v57, v58, p15, p16, widgetInfo, fromContentFeed, p17, if not FFlagPurchasePromptSubtitleForTimedOptions then nil else p18, b1))

			return
		end

		if v59 == Constants.ItemPromptType.OpenGoToAvatarEditorPrompt then
			p19:dispatch(OpenGoToAvatarEditorPrompt(p10, p11, p12, v57, v58))

			return
		end

		if v59 == Constants.ItemPromptType.OpenPremiumUpsellPrompt then
			p19:dispatch(OpenPremiumUpsellPrompt(p8, p9, p10, p11, nil, v57, v58))

			return
		end

		if v59 == Constants.ItemPromptType.Disabled then
			local v66 = ItemData(v56.AvatarExperience.Common, v57, v58)

			clickDisabledButton(p19, v56, v66, p8)
		end
	end
end
