local CorePackages = game:GetService("CorePackages")

local tutils = require(CorePackages.Packages.tutils)

local module = require("@luauforge/bundled/dPN")
local module2 = require("@luauforge/bundled/dVl")
local module3 = require("@luauforge/bundled/dzE")

local module4 = require("@luauforge/deferred/fCv")

local module5 = require("@luauforge/deferred/fCw")
local module6 = require("@luauforge/deferred/fCR")
local module7 = require("@luauforge/deferred/fCT")
local module8 = require("@luauforge/bundled/dFm")
local module9 = require("@luauforge/bundled/fCy")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local itemData = AvatarExperienceCommon.State.Selectors.ItemData

local module11 = require("@luauforge/bundled/dVq")

local fFlagPurchasePromptSubtitleForTimedOptions = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagPurchasePromptSubtitleForTimedOptions

local fFlagAXFixItemDetailsPurchaseAttribution = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFixItemDetailsPurchaseAttribution

local v5 = {
	toastMessage = "Feature.Catalog.LabelNoResellers",
	toastSubMessage = "Feature.Catalog.Label.NoSellersWarning",
	isLocalized = false,
	toastType = module3.SuccessConfirmation
}

local v6 = {
	toastMessage = "Feature.Catalog.Heading.NotForSale",
	toastSubMessage = "Feature.Catalog.Label.NoLongerAvailable",
	isLocalized = false,
	toastType = module3.SuccessConfirmation
}

local v7 = {
	toastMessage = "Feature.Catalog.Heading.InExperienceOnly",
	toastSubMessage = "Feature.Catalog.Label.InExperienceOnly",
	isLocalized = false,
	toastType = module3.SuccessConfirmation
}

local v8 = {
	toastMessage = "Feature.Catalog.Heading.QuantityLimitReached",
	toastSubMessage = "Feature.Catalog.Label.QuantityLimitReached",
	isLocalized = false,
	toastType = module3.SuccessConfirmation
}

local function fetchRobuxBalance(object, p2, p3)
	local localUserId = p2.LocalUserId

	if typeof(localUserId) == "string" and localUserId ~= "" then
		object:dispatch(module9(p3, localUserId, false))
	end
end

local function clickDisabledButton(object, state, p2, p3)
	local resellerUserAssetIds = p2 and p2.resellerUserAssetIds
	local isResellable = module2.IsResellable(p2)
	local collectibleItemId = p2 and p2.collectibleItemId

	local v9 = resellerUserAssetIds and resellerUserAssetIds[1]
	local userAsset = state.AvatarExperience.Catalog.UserAssets[v9]
	local v10 = isResellable and userAsset == nil

	if state.UserRobux[state.LocalUserId] == nil then
		local localUserId = state.LocalUserId

		if typeof(localUserId) == "string" and localUserId ~= "" then
			object:dispatch(module9(p3, localUserId, false))
		end
	else
		local v11

		if collectibleItemId then
			local v12 = state.AvatarExperience.Common.Collectibles.CollectiblesItemInfo[collectibleItemId]

			v11 = not module2.isOriginalStockSellableInShop(v12)
			v10 = not v12 or not v12.hasResellers
		else
			v11 = false
		end

		local v12

		if collectibleItemId then
			local v13 = state.AvatarExperience.Common.Collectibles.CollectiblesItemInfo[collectibleItemId]

			local collectiblesResellableInstance = state.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances[collectibleItemId]
			v10 = not v13 or not v13.hasResellers

			v12 = v10 and module2.reachQuantityLimit(v13, collectiblesResellableInstance)
		else
			v12 = false
		end

		if v11 then
			if module11() then
				return object:dispatch(module8(v7))
			end
		else
			if v12 then
				return object:dispatch(module8(v8))
			end

			if isResellable and v10 then
				return object:dispatch(module8(v5))
			end
		end

		return object:dispatch(module8(v6))
	end
end

return function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13)
	return function(object)
		local state = object:getState()
		local v9, v10

		if p7 and p8 then
			v9 = p7
			v10 = p8
		else
			v9 = p6.current.params.itemId
			v10 = p6.current.params.itemType
		end

		local v11 = module4(state, v9, v10, {})

		local fromContentFeed = p6.current.params.fromContentFeed
		local fromProfile = p6.current.params.fromProfile
		local widgetInfo = p6.current.params.widgetInfo

		if not widgetInfo then
			local tryOnItems = state.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

			if fFlagAXFixItemDetailsPurchaseAttribution then
				local tryOnItem = tryOnItems[getTryOnItemReducerKey(v9, v10)]

				if tryOnItem then
					widgetInfo = tryOnItem.widgetInfo
				end
			elseif tutils.fieldCount(tryOnItems) == 1 then
				local v12, v13 = next(tryOnItems)
				widgetInfo = v13.widgetInfo
			end
		end

		if v11 == module.ItemPromptType.OpenPurchasePrompt then
			object:dispatch(module5(
				p2,
				p4,
				p5,
				p3,
				fromProfile,
				p6,
				v9,
				v10,
				p9,
				p10,
				widgetInfo,
				fromContentFeed,
				p11,
				if fFlagPurchasePromptSubtitleForTimedOptions then p12 else nil,
				p13
			))
		elseif v11 == module.ItemPromptType.OpenGoToAvatarEditorPrompt then
			object:dispatch(module7(p4, p5, p6, v9, v10))
		elseif v11 == module.ItemPromptType.OpenPremiumUpsellPrompt then
			object:dispatch(module6(p2, p3, p4, p5, nil, v9, v10))
		elseif v11 == module.ItemPromptType.Disabled then
			clickDisabledButton(object, state, itemData(state.AvatarExperience.Common, v9, v10), p2)
		end
	end
end
