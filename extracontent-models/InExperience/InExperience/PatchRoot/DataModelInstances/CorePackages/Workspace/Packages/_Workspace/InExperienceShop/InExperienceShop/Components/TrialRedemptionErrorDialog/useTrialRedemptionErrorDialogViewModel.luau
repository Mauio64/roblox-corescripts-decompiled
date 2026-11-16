local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local SignalsReact = require(parent.SignalsReact)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
local initiateShopItemPurchase = require(InExperienceShop.initiateShopItemPurchase)
local getTrialRedemptionErrorKeys = require(script.Parent.getTrialRedemptionErrorKeys)
require(InExperienceShop.Types)

local v = { FreeTrialAlreadyRedeemed = true, GamePassTrialNotEnabled = true }

local function useTrialRedemptionErrorDialogViewModel()
	local v2 = SignalsReact.useSignalState(getInExperienceShopStore)
	local v3 = SignalsReact.useSignalState(v2.getTrialRedemptionError)
	local errorCode

	if v3 ~= nil then
		errorCode = v3.errorCode
	end

	local trialRedemptionErrorKeys = getTrialRedemptionErrorKeys(errorCode)
	local v4 = useLocalization({
		title = trialRedemptionErrorKeys.title,
		body = trialRedemptionErrorKeys.body,
		okText = "CommonUI.Controls.Action.OK",
		buyText = "Feature.Catalog.Action.Buy"
	})

	if v3 == nil then
		return nil
	end

	local dismissTrialRedemptionError = v2.dismissTrialRedemptionError

	if errorCode == nil or not v[errorCode] then
		return {
			title = v4.title,
			body = v4.body,
			actionText = v4.okText,
			onAction = dismissTrialRedemptionError,
			onClose = dismissTrialRedemptionError
		}
	end

	local gamePassId = v3.gamePassId
	local purchaseContext = v3.purchaseContext or {}
	return {
		title = v4.title,
		body = v4.body,
		actionText = v4.buyText,
		onAction = function()
			dismissTrialRedemptionError()
			initiateShopItemPurchase(
				gamePassId,
				"GamePass",
				purchaseContext.shopPageType,
				purchaseContext.categoryLocation
			)
		end,
		onClose = dismissTrialRedemptionError
	}
end

return useTrialRedemptionErrorDialogViewModel
