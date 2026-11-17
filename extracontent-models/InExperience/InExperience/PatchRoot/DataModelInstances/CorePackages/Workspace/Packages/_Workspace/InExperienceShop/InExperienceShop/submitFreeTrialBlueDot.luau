local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Signals = require(parent.Signals)
local NotificationsOrchestrator = require(parent.NotificationsOrchestrator)
local InExperienceOffers = require(parent.InExperienceOffers)

local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
local GetShopGlobalIconStore = require(InExperienceShop.Stores.GetShopGlobalIconStore)
local FIntMaxTrialBlueDotImpressions = require(InExperienceShop.Flags.FIntMaxTrialBlueDotImpressions)
local FIntMaxRedeemedTrialBlueDotImpressions = require(InExperienceShop.Flags.FIntMaxRedeemedTrialBlueDotImpressions)
local FStringAvailableTrialBlueDotLifecycleKey = require(InExperienceShop.Flags.FStringAvailableTrialBlueDotLifecycleKey)
local FStringRedeemedTrialBlueDotLifecycleKey = require(InExperienceShop.Flags.FStringRedeemedTrialBlueDotLifecycleKey)
local FIntTrialBlueDotCooldownSeconds = require(InExperienceShop.Flags.FIntTrialBlueDotCooldownSeconds)
local FIntRedeemedTrialBlueDotCooldownSeconds = require(InExperienceShop.Flags.FIntRedeemedTrialBlueDotCooldownSeconds)
local FFlagEnableExperienceShopGlobalIcon = require(InExperienceShop.Flags.FFlagEnableExperienceShopGlobalIcon)
local FFlagTrialNotificationBlueDotOnStudio = require(InExperienceShop.Flags.FFlagTrialNotificationBlueDotOnStudio)
local FFlagEnableActiveFreeTrialBlueDot = require(InExperienceShop.Flags.FFlagEnableActiveFreeTrialBlueDot)
local FFlagEnableRedeemedFreeTrialBlueDot = require(InExperienceShop.Flags.FFlagEnableRedeemedFreeTrialBlueDot)
local hasRedeemedTrialWithinWindow = require(InExperienceShop.Utils.hasRedeemedTrialWithinWindow)

require(InExperienceShop.Types)

local v = {
	lifecycleKey = FStringRedeemedTrialBlueDotLifecycleKey,
	maxImpressions = FIntMaxRedeemedTrialBlueDotImpressions,
	cooldownSeconds = FIntRedeemedTrialBlueDotCooldownSeconds
}

local v2 = {
	available = {
		lifecycleKey = FStringAvailableTrialBlueDotLifecycleKey,
		maxImpressions = FIntMaxTrialBlueDotImpressions,
		cooldownSeconds = FIntTrialBlueDotCooldownSeconds
	},
	active = v,
	redeemed = v
}

local function asBlueDotSlot(p: string)
	return p
end

local function asTrialKind(p: string)
	return p
end

local v3 = nil
local v4 = nil
local signal, v5 = Signals.createSignal(nil)

local v6 = nil
local v7 = nil

local function trialKind(trialAvailabilities): nil | string -- 1 equivalent call inferred from this helper
	if FFlagEnableActiveFreeTrialBlueDot and next(trialAvailabilities.active) ~= nil then
		return "active"
	end

	if FFlagEnableRedeemedFreeTrialBlueDot and hasRedeemedTrialWithinWindow(trialAvailabilities.redeemed) then
		return "redeemed"
	end

	if next(trialAvailabilities.available) == nil then
		return nil
	end

	return "available"
end

local function chooseSlot(p): nil | string
	local isShopAvailable = InExperienceOffers.getOffersStore(false).getIsShopAvailable(p)

	if FFlagEnableExperienceShopGlobalIcon then
		if GetShopGlobalIconStore(false).getEnabled(p) then
			return "ShopIconBlueDot"
		end

		local v8 = getInExperienceShopStore(false)

		if v8.getLoading(p) or v8.getGlobalIconBackendEnabled(p) then
			return nil
		end

		return if isShopAvailable then "HamburgerBlueDot" else nil
	else
		return if isShopAvailable then "HamburgerBlueDot" else nil
	end
end

local function submitBlueDot(slotId: string, p: string)
	local lifecycle = NotificationsOrchestrator.getSlotConfig(slotId).lifecycle
	local visibility

	if lifecycle ~= nil then
		visibility = lifecycle.visibility
	end

	local slotDisplayPayload = slotId == "ShopIconBlueDot" and { slot = "ShopIconBlueDot" }
		or { slot = "HamburgerBlueDot" }
	local v8 = v2[p]
	return NotificationsOrchestrator.submit({
		slotId = slotId,
		priority = 0,
		lifecycleKey = v8.lifecycleKey,
		lifecyclePolicy = {
			frequency = {
				maxImpressions = v8.maxImpressions,
				window = "forever",
				cooldownSeconds = v8.cooldownSeconds
			},
			visibility = visibility
		},
		source = "GamePassFreeTrialBlueDot",
		slotDisplayPayload = slotDisplayPayload,
		enableOnStudio = FFlagTrialNotificationBlueDotOnStudio
	})
end

local function isActiveNotification(p: string, p2): boolean -- 5 equivalent calls inferred from this helper
	local v8 = signal(p2)
	local v9 = NotificationsOrchestrator.getActiveForSlot(p)(p2)

	return v8 ~= nil and v8.slotId == p and v9 ~= nil and v9.payload.slot == p and v9.handle == v8.handle
end

local function activeHandle() -- 1 equivalent call inferred from this helper
	local v8 = signal(false)

	if v8 ~= nil and isActiveNotification(v8.slotId, false) then -- inferred equivalent call
		return v8.handle
	end

	return nil
end

local function isTrialBlueDotShowing(p)
	local v8 = signal(p)

	if v8 == nil then
		return false
	end

	return isActiveNotification(v8.slotId, p) -- inferred equivalent call
end

local function isShowingOnSlot(p: string, p2)
	return isActiveNotification(p, p2) -- inferred equivalent call
end

local function report(p)
	local v8 = signal(false)
	local v9 = activeHandle() -- inferred equivalent call

	if v8 == nil or v9 == nil then
		return
	end

	if p.type == "mounted" then
		if v6 == v9 then
			return
		end

		v6 = v9
	elseif p.type == "viewed" then
		if v7 == v9 then
			return
		end

		v7 = v9
	end

	NotificationsOrchestrator.report(v8.slotId, v9, p)
end

local v8 = false

local function dismiss()
	v8 = true
	report({ type = "dismissed", reason = "activated" })
end

local function submitFreeTrialBlueDot() -- 1 equivalent call inferred from this helper
	local v9 = v4

	if v9 ~= nil then
		return v9
	end

	local v10 = false
	local v11 = getInExperienceShopStore(false)
	v3 = Signals.createEffect(function(p)
		local trialAvailabilities = v11.getTrialAvailabilities(p)

		if v8 or v10 then
			return
		end

		local v12 = trialKind(trialAvailabilities) -- inferred equivalent call

		if v12 == nil then
			return
		end

		local slotId = chooseSlot(p)

		if slotId == nil then
			return
		end

		v10 = true

		v5({ slotId = slotId, handle = submitBlueDot(slotId, v12) })
	end)

	v4 = isTrialBlueDotShowing
	return isTrialBlueDotShowing
end

return (setmetatable({
	reportMounted = function()
		report({ type = "mounted" })
	end,
	reportViewed = function()
		report({ type = "viewed" })
	end,
	reportActivated = function()
		if not NotificationsOrchestrator.Flags.FFlagEnableNotificationsOrchestratorUnifiedLogging then
			return
		end

		report({ type = "activated" })
	end,
	dismiss = dismiss,
	isHamburgerBlueDotShowing = function(p)
		return isActiveNotification("HamburgerBlueDot", p) -- inferred equivalent call
	end,
	isShopIconBlueDotShowing = function(p)
		return isActiveNotification("ShopIconBlueDot", p) -- inferred equivalent call
	end
}, {
	__call = function(_)
		return submitFreeTrialBlueDot() -- inferred equivalent call
	end
}))
