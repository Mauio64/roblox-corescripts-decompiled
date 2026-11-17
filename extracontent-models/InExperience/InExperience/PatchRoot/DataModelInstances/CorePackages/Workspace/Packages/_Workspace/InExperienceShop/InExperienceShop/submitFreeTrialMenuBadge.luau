local LocalizationService = game:GetService("LocalizationService")

local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Signals = require(parent.Signals)
local AppLocales = require(parent.AppLocales)
local Localization = AppLocales.Localization
local NotificationsOrchestrator = require(parent.NotificationsOrchestrator)

local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
local FIntMaxTrialBadgeImpressions = require(InExperienceShop.Flags.FIntMaxTrialBadgeImpressions)
local FStringTrialBadgeLifecycleKey = require(InExperienceShop.Flags.FStringTrialBadgeLifecycleKey)
local FIntTrialBadgeCooldownSeconds = require(InExperienceShop.Flags.FIntTrialBadgeCooldownSeconds)
local FFlagTrialNotificationBadgeOnStudio = require(InExperienceShop.Flags.FFlagTrialNotificationBadgeOnStudio)
local FFlagEnableActiveFreeTrialShopMenuBadge = require(InExperienceShop.Flags.FFlagEnableActiveFreeTrialShopMenuBadge)
local FFlagEnableRedeemedFreeTrialShopMenuBadge = require(InExperienceShop.Flags.FFlagEnableRedeemedFreeTrialShopMenuBadge)

require(InExperienceShop.Types)

local v = nil
local v2 = nil

local signal, v3 = Signals.createSignal(nil)

local function hasTrialToBadge(data): boolean
	if
		next(data.available) ~= nil
		or FFlagEnableActiveFreeTrialShopMenuBadge and next(data.active) ~= nil
		or FFlagEnableRedeemedFreeTrialShopMenuBadge and next(data.redeemed) ~= nil
	then
		return true
	end

	return false
end

local function freeTrialLabel() -- 1 equivalent call inferred from this helper
	return Localization.new(LocalizationService.RobloxLocaleId):Format("Feature.InExperienceShop.Label.FreeTrial")
end

local function shopMenuBadgeText(p)
	local v4 = NotificationsOrchestrator.getActiveForSlot(NotificationsOrchestrator.SlotId.ShopMenuBadge)(p)

	local v5 = signal(p)

	if v4 == nil or v4.payload.slot ~= "ShopMenuBadge" or v4.handle ~= v5 then
		return nil
	end

	return v4.payload.text
end

local function activeHandle() -- 1 equivalent call inferred from this helper
	local v4 = NotificationsOrchestrator.getActiveForSlot(NotificationsOrchestrator.SlotId.ShopMenuBadge)(false)

	if v4 == nil or v4.payload.slot ~= "ShopMenuBadge" or v4.handle ~= signal(false) then
		return nil
	end

	return v4.handle
end

local function report(p) -- 4 equivalent calls inferred from this helper
	local v4 = activeHandle() -- inferred equivalent call

	if v4 == nil then
		return
	end

	NotificationsOrchestrator.report(NotificationsOrchestrator.SlotId.ShopMenuBadge, v4, p)
end

local function submitFreeTrialMenuBadge() -- 1 equivalent call inferred from this helper
	local v4 = v2

	if v4 ~= nil then
		return v4
	end

	local v5 = false
	local v6 = getInExperienceShopStore(false)
	v = Signals.createEffect(function(p)
		local trialAvailabilities = v6.getTrialAvailabilities(p)

		if
			v5
			or next(trialAvailabilities.available) == nil
			and (not FFlagEnableActiveFreeTrialShopMenuBadge or next(trialAvailabilities.active) == nil)
			and (not FFlagEnableRedeemedFreeTrialShopMenuBadge or next(trialAvailabilities.redeemed) == nil)
		then
			return
		end

		local text = freeTrialLabel() -- inferred equivalent call
		v5 = true
		v3(NotificationsOrchestrator.submit({
			slotId = NotificationsOrchestrator.SlotId.ShopMenuBadge,
			priority = 0,
			enableOnStudio = FFlagTrialNotificationBadgeOnStudio,
			lifecycleKey = FStringTrialBadgeLifecycleKey,
			lifecyclePolicy = {
				frequency = {
					maxImpressions = FIntMaxTrialBadgeImpressions,
					window = "forever",
					cooldownSeconds = FIntTrialBadgeCooldownSeconds
				}
			},
			source = "GamePassFreeTrial",
			slotDisplayPayload = { slot = "ShopMenuBadge", text = text }
		}))
	end)

	v2 = shopMenuBadgeText
	return shopMenuBadgeText
end

return (setmetatable({
	reportMounted = function()
		report({ type = "mounted" }) -- inferred equivalent call
	end,
	reportViewed = function()
		report({ type = "viewed" }) -- inferred equivalent call
	end,
	reportActivated = function()
		if not NotificationsOrchestrator.Flags.FFlagEnableNotificationsOrchestratorUnifiedLogging then
			return
		end

		report({ type = "activated" }) -- inferred equivalent call
	end,
	dismiss = function()
		report({ type = "dismissed", reason = "activated" }) -- inferred equivalent call
	end
}, {
	__call = function(_)
		return submitFreeTrialMenuBadge() -- inferred equivalent call
	end
}))
